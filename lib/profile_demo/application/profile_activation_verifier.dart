import '../domain/profile_service.dart';
import '../domain/simulation_models.dart';

typedef PollCallback = void Function(int attempt, Duration elapsed);

class ProfileActivationVerifier {
  const ProfileActivationVerifier({
    required this.policy,
    required this.elapsed,
    required this.delay,
  });

  final SimulationPolicy policy;
  final ElapsedReader elapsed;
  final DelayFunction delay;

  Future<VerificationResult> verify({
    required ProfileService service,
    required String expectedProfile,
    required bool Function() shouldContinue,
    PollCallback? onPoll,
  }) async {
    final dispatchedAt = service.dispatchedAt;
    if (dispatchedAt == null) {
      return VerificationResult(
        type: VerificationResultType.failed,
        attempts: 0,
        elapsed: elapsed(),
      );
    }

    var attempts = 0;
    for (var attempt = 1; attempt <= policy.maxAttempts; attempt++) {
      final regularOffset = Duration(
        microseconds: policy.pollInterval.inMicroseconds * attempt,
      );
      final targetOffset = regularOffset > policy.verificationTimeout
          ? policy.verificationTimeout
          : regularOffset;
      final targetTime = dispatchedAt + targetOffset;
      final remaining = targetTime - elapsed();

      if (remaining > Duration.zero) {
        await delay(remaining);
      }
      if (!shouldContinue()) {
        return VerificationResult(
          type: VerificationResultType.cancelled,
          attempts: attempts,
          elapsed: elapsed(),
        );
      }

      attempts = attempt;
      onPoll?.call(attempt, elapsed());
      final activeProfile = await service.readActiveProfile();
      if (!shouldContinue()) {
        return VerificationResult(
          type: VerificationResultType.cancelled,
          attempts: attempts,
          elapsed: elapsed(),
        );
      }
      if (activeProfile == expectedProfile) {
        return VerificationResult(
          type: VerificationResultType.verified,
          attempts: attempts,
          elapsed: elapsed(),
        );
      }
      if (targetOffset >= policy.verificationTimeout) {
        break;
      }
    }

    return VerificationResult(
      type: VerificationResultType.failed,
      attempts: attempts,
      elapsed: elapsed(),
    );
  }
}
