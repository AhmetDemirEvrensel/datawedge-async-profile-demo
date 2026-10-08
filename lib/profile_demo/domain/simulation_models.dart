enum ActivationScenario { fast, typical, boundary, never }

extension ActivationScenarioDetails on ActivationScenario {
  Duration? get activationDelay => switch (this) {
    ActivationScenario.fast => const Duration(milliseconds: 200),
    ActivationScenario.typical => const Duration(milliseconds: 1500),
    ActivationScenario.boundary => const Duration(milliseconds: 5000),
    ActivationScenario.never => null,
  };
}

class SimulationPolicy {
  const SimulationPolicy({
    this.commandLatency = const Duration(milliseconds: 40),
    this.pollInterval = const Duration(seconds: 1),
    this.maxAttempts = 5,
    this.verificationTimeout = const Duration(seconds: 5),
  });

  final Duration commandLatency;
  final Duration pollInterval;
  final int maxAttempts;
  final Duration verificationTimeout;
}

enum TimelineLane { assumption, verification }

enum TimelineKind { info, success, warning, error }

enum TimelineEventType {
  commandDispatched,
  futureCompleted,
  readinessAssumed,
  verificationStarted,
  pollingAttempt,
  activationVerified,
  verificationFailed,
  profileActivated,
}

class TimelineEntry {
  const TimelineEntry({
    required this.elapsed,
    required this.lane,
    required this.event,
    required this.kind,
    this.attempt,
  });

  final Duration elapsed;
  final TimelineLane lane;
  final TimelineEventType event;
  final TimelineKind kind;
  final int? attempt;
}

enum VerificationOutcome { idle, assumedReady, verifying, verified, failed }

class ApproachSnapshot {
  const ApproachSnapshot({
    this.commandDispatched = false,
    this.futureCompleted = false,
    this.profileActive = false,
    this.activationVerified = false,
    this.pollCount = 0,
    this.outcome = VerificationOutcome.idle,
    this.readinessAssumedAt,
    this.profileActiveWhenAssumed,
    this.profileActivatedAt,
    this.verificationFinishedAt,
  });

  final bool commandDispatched;
  final bool futureCompleted;
  final bool profileActive;
  final bool activationVerified;
  final int pollCount;
  final VerificationOutcome outcome;
  final Duration? readinessAssumedAt;
  final bool? profileActiveWhenAssumed;
  final Duration? profileActivatedAt;
  final Duration? verificationFinishedAt;

  bool get verificationFailed => outcome == VerificationOutcome.failed;

  ApproachSnapshot copyWith({
    bool? commandDispatched,
    bool? futureCompleted,
    bool? profileActive,
    bool? activationVerified,
    int? pollCount,
    VerificationOutcome? outcome,
    Duration? readinessAssumedAt,
    bool? profileActiveWhenAssumed,
    Duration? profileActivatedAt,
    Duration? verificationFinishedAt,
  }) {
    return ApproachSnapshot(
      commandDispatched: commandDispatched ?? this.commandDispatched,
      futureCompleted: futureCompleted ?? this.futureCompleted,
      profileActive: profileActive ?? this.profileActive,
      activationVerified: activationVerified ?? this.activationVerified,
      pollCount: pollCount ?? this.pollCount,
      outcome: outcome ?? this.outcome,
      readinessAssumedAt: readinessAssumedAt ?? this.readinessAssumedAt,
      profileActiveWhenAssumed:
          profileActiveWhenAssumed ?? this.profileActiveWhenAssumed,
      profileActivatedAt: profileActivatedAt ?? this.profileActivatedAt,
      verificationFinishedAt:
          verificationFinishedAt ?? this.verificationFinishedAt,
    );
  }
}

enum VerificationResultType { verified, failed, cancelled }

class VerificationResult {
  const VerificationResult({
    required this.type,
    required this.attempts,
    required this.elapsed,
  });

  final VerificationResultType type;
  final int attempts;
  final Duration elapsed;
}
