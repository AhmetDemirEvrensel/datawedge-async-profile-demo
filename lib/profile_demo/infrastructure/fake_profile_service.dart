import 'dart:async';

import '../domain/profile_service.dart';
import '../domain/simulation_models.dart';

class ProfileRunCancelled implements Exception {
  const ProfileRunCancelled();
}

class FakeProfileService implements ProfileService {
  FakeProfileService(
    this._elapsed, {
    this.policy = defaultSimulationPolicy,
    DelayFunction? delay,
  }) : _delay = delay ?? Future<void>.delayed;

  final ElapsedReader _elapsed;
  final DelayFunction _delay;
  final SimulationPolicy policy;
  final StreamController<ProfileServiceEvent> _events =
      StreamController<ProfileServiceEvent>.broadcast(sync: true);

  Timer? _activationTimer;
  int _generation = 0;
  String? _activeProfile;
  String? _pendingProfile;
  Duration? _activationAt;
  Duration? _dispatchedAt;

  @override
  Stream<ProfileServiceEvent> get events => _events.stream;

  @override
  Duration? get dispatchedAt => _dispatchedAt;

  @override
  Future<void> createProfile({
    required String profileName,
    required Duration? activationDelay,
  }) async {
    final generation = ++_generation;
    _activationTimer?.cancel();
    _activeProfile = null;
    _pendingProfile = profileName;
    _dispatchedAt = _elapsed();
    _activationAt = activationDelay == null
        ? null
        : _dispatchedAt! + activationDelay;

    _events.add(
      ProfileServiceEvent(
        type: ProfileServiceEventType.commandDispatched,
        elapsed: _dispatchedAt!,
      ),
    );

    if (activationDelay != null) {
      _activationTimer = Timer(activationDelay, () {
        if (generation == _generation) {
          _activateProfile();
        }
      });
    }

    await _delay(policy.commandLatency);
    if (generation != _generation) {
      throw const ProfileRunCancelled();
    }
  }

  @override
  Future<String?> readActiveProfile() async {
    _refreshActivationFromClock();
    return _activeProfile;
  }

  void _refreshActivationFromClock() {
    final activationAt = _activationAt;
    if (_activeProfile == null &&
        activationAt != null &&
        _elapsed() >= activationAt) {
      _activateProfile();
    }
  }

  void _activateProfile() {
    final pendingProfile = _pendingProfile;
    if (_activeProfile != null ||
        pendingProfile == null ||
        _activationAt == null) {
      return;
    }

    _activeProfile = pendingProfile;
    _activationTimer?.cancel();
    _activationTimer = null;
    _events.add(
      ProfileServiceEvent(
        type: ProfileServiceEventType.profileActivated,
        elapsed: _elapsed(),
      ),
    );
  }

  @override
  void reset() {
    _generation++;
    _activationTimer?.cancel();
    _activationTimer = null;
    _activeProfile = null;
    _pendingProfile = null;
    _activationAt = null;
    _dispatchedAt = null;
  }

  @override
  void dispose() {
    reset();
    unawaited(_events.close());
  }
}
