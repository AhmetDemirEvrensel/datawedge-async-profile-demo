import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/profile_service.dart';
import '../domain/simulation_models.dart';
import '../infrastructure/fake_profile_service.dart';
import 'profile_activation_verifier.dart';

class ProfileDemoController extends ChangeNotifier {
  ProfileDemoController({this.policy = defaultSimulationPolicy});

  static const String profileName = 'DemoProfile';

  final SimulationPolicy policy;
  final Stopwatch _stopwatch = Stopwatch();
  final List<TimelineEntry> _timeline = <TimelineEntry>[];

  ActivationScenario _scenario = ActivationScenario.typical;
  ApproachSnapshot _assumption = const ApproachSnapshot();
  ApproachSnapshot _verification = const ApproachSnapshot();
  FakeProfileService? _assumptionService;
  FakeProfileService? _verificationService;
  StreamSubscription<ProfileServiceEvent>? _assumptionSubscription;
  StreamSubscription<ProfileServiceEvent>? _verificationSubscription;
  int _runToken = 0;
  bool _isRunning = false;
  bool _isDisposed = false;

  ActivationScenario get scenario => _scenario;
  ApproachSnapshot get assumption => _assumption;
  ApproachSnapshot get verification => _verification;
  List<TimelineEntry> get timeline =>
      List<TimelineEntry>.unmodifiable(_timeline);
  bool get isRunning => _isRunning;

  Future<void> selectScenario(ActivationScenario scenario) async {
    if (scenario == _scenario) {
      return;
    }
    _scenario = scenario;
    await _clearRun(notify: true);
  }

  Future<void> runComparison() async {
    await _clearRun(notify: false);
    final runToken = ++_runToken;

    _stopwatch
      ..reset()
      ..start();
    _assumption = const ApproachSnapshot();
    _verification = const ApproachSnapshot();
    _timeline.clear();
    _isRunning = true;
    final activationDelay = _scenario.activationDelay;

    _assumptionService = FakeProfileService(_readElapsed, policy: policy);
    _verificationService = FakeProfileService(_readElapsed, policy: policy);
    _assumptionSubscription = _listenToService(
      _assumptionService!,
      TimelineLane.assumption,
      runToken,
    );
    _verificationSubscription = _listenToService(
      _verificationService!,
      TimelineLane.verification,
      runToken,
    );
    _notify();

    await Future.wait<void>(<Future<void>>[
      _runAssumption(_assumptionService!, runToken, activationDelay),
      _runVerification(_verificationService!, runToken, activationDelay),
    ]);

    if (_isCurrentRun(runToken)) {
      _isRunning = false;
      _stopwatch.stop();
      _notify();
    }
  }

  Future<void> reset() async {
    await _clearRun(notify: true);
  }

  Future<void> _runAssumption(
    FakeProfileService service,
    int runToken,
    Duration? activationDelay,
  ) async {
    try {
      await service.createProfile(
        profileName: profileName,
        activationDelay: activationDelay,
      );
      if (!_isCurrentRun(runToken)) {
        return;
      }

      final completedAt = _readElapsed();
      final wasActiveAtAssumption = _assumption.profileActive;
      _assumption = _assumption.copyWith(
        futureCompleted: true,
        outcome: VerificationOutcome.assumedReady,
        readinessAssumedAt: completedAt,
        profileActiveWhenAssumed: wasActiveAtAssumption,
      );
      _addTimeline(
        lane: TimelineLane.assumption,
        event: TimelineEventType.futureCompleted,
        kind: TimelineKind.info,
        elapsed: completedAt,
      );
      _addTimeline(
        lane: TimelineLane.assumption,
        event: TimelineEventType.readinessAssumed,
        kind: TimelineKind.warning,
        elapsed: completedAt,
      );
      _notify();
    } on ProfileRunCancelled {
      return;
    }
  }

  Future<void> _runVerification(
    FakeProfileService service,
    int runToken,
    Duration? activationDelay,
  ) async {
    try {
      await service.createProfile(
        profileName: profileName,
        activationDelay: activationDelay,
      );
      if (!_isCurrentRun(runToken)) {
        return;
      }

      final completedAt = _readElapsed();
      _verification = _verification.copyWith(
        futureCompleted: true,
        outcome: VerificationOutcome.verifying,
      );
      _addTimeline(
        lane: TimelineLane.verification,
        event: TimelineEventType.futureCompleted,
        kind: TimelineKind.info,
        elapsed: completedAt,
      );
      _addTimeline(
        lane: TimelineLane.verification,
        event: TimelineEventType.verificationStarted,
        kind: TimelineKind.info,
        elapsed: completedAt,
      );
      _notify();

      final verifier = ProfileActivationVerifier(
        policy: policy,
        elapsed: _readElapsed,
        delay: Future<void>.delayed,
      );
      final result = await verifier.verify(
        service: service,
        expectedProfile: profileName,
        shouldContinue: () => _isCurrentRun(runToken),
        onPoll: (attempt, elapsed) {
          if (!_isCurrentRun(runToken)) {
            return;
          }
          _verification = _verification.copyWith(pollCount: attempt);
          _timeline.add(
            TimelineEntry(
              elapsed: elapsed,
              lane: TimelineLane.verification,
              event: TimelineEventType.pollingAttempt,
              kind: TimelineKind.info,
              attempt: attempt,
            ),
          );
          _notify();
        },
      );

      if (!_isCurrentRun(runToken) ||
          result.type == VerificationResultType.cancelled) {
        return;
      }
      if (result.type == VerificationResultType.verified) {
        _verification = _verification.copyWith(
          activationVerified: true,
          outcome: VerificationOutcome.verified,
          verificationFinishedAt: result.elapsed,
        );
        _addTimeline(
          lane: TimelineLane.verification,
          event: TimelineEventType.activationVerified,
          kind: TimelineKind.success,
          attempt: result.attempts,
          elapsed: result.elapsed,
        );
      } else {
        _verification = _verification.copyWith(
          outcome: VerificationOutcome.failed,
          verificationFinishedAt: result.elapsed,
        );
        _addTimeline(
          lane: TimelineLane.verification,
          event: TimelineEventType.verificationFailed,
          kind: TimelineKind.error,
          elapsed: result.elapsed,
        );
      }
      _notify();
    } on ProfileRunCancelled {
      return;
    }
  }

  StreamSubscription<ProfileServiceEvent> _listenToService(
    FakeProfileService service,
    TimelineLane lane,
    int runToken,
  ) {
    return service.events.listen((event) {
      if (!_isCurrentRun(runToken)) {
        return;
      }

      switch (event.type) {
        case ProfileServiceEventType.commandDispatched:
          _updateLane(
            lane,
            (snapshot) => snapshot.copyWith(commandDispatched: true),
          );
          _timeline.add(
            TimelineEntry(
              elapsed: event.elapsed,
              lane: lane,
              event: TimelineEventType.commandDispatched,
              kind: TimelineKind.info,
            ),
          );
        case ProfileServiceEventType.profileActivated:
          _updateLane(
            lane,
            (snapshot) => snapshot.copyWith(
              profileActive: true,
              profileActivatedAt: event.elapsed,
            ),
          );
          _timeline.add(
            TimelineEntry(
              elapsed: event.elapsed,
              lane: lane,
              event: TimelineEventType.profileActivated,
              kind: TimelineKind.success,
            ),
          );
      }
      _notify();
    });
  }

  void _updateLane(
    TimelineLane lane,
    ApproachSnapshot Function(ApproachSnapshot snapshot) update,
  ) {
    if (lane == TimelineLane.assumption) {
      _assumption = update(_assumption);
    } else {
      _verification = update(_verification);
    }
  }

  void _addTimeline({
    required TimelineLane lane,
    required TimelineEventType event,
    required TimelineKind kind,
    int? attempt,
    Duration? elapsed,
  }) {
    _timeline.add(
      TimelineEntry(
        elapsed: elapsed ?? _readElapsed(),
        lane: lane,
        event: event,
        kind: kind,
        attempt: attempt,
      ),
    );
  }

  Duration _readElapsed() => _stopwatch.elapsed;

  bool _isCurrentRun(int runToken) => !_isDisposed && runToken == _runToken;

  Future<void> _clearRun({required bool notify}) async {
    _runToken++;
    _stopwatch.stop();
    final assumptionCancellation = _assumptionSubscription?.cancel();
    final verificationCancellation = _verificationSubscription?.cancel();
    _assumptionSubscription = null;
    _verificationSubscription = null;
    _assumptionService?.dispose();
    _verificationService?.dispose();
    _assumptionService = null;
    _verificationService = null;
    _assumption = const ApproachSnapshot();
    _verification = const ApproachSnapshot();
    _timeline.clear();
    _isRunning = false;
    if (notify) {
      _notify();
    }
    await assumptionCancellation;
    await verificationCancellation;
  }

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _runToken++;
    _stopwatch.stop();
    unawaited(_assumptionSubscription?.cancel());
    unawaited(_verificationSubscription?.cancel());
    _assumptionService?.dispose();
    _verificationService?.dispose();
    super.dispose();
  }
}
