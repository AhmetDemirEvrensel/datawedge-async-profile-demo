import 'simulation_models.dart';

enum ProfileServiceEventType { commandDispatched, profileActivated }

class ProfileServiceEvent {
  const ProfileServiceEvent({required this.type, required this.elapsed});

  final ProfileServiceEventType type;
  final Duration elapsed;
}

abstract interface class ProfileService {
  Stream<ProfileServiceEvent> get events;

  Duration? get dispatchedAt;

  Future<void> createProfile({
    required String profileName,
    required Duration? activationDelay,
  });

  Future<String?> readActiveProfile();

  void reset();

  void dispose();
}

typedef ElapsedReader = Duration Function();
typedef DelayFunction = Future<void> Function(Duration duration);

const defaultSimulationPolicy = SimulationPolicy();
