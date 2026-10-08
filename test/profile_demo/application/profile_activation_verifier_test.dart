import 'package:datawedge_async_profile_demo/profile_demo/application/profile_activation_verifier.dart';
import 'package:datawedge_async_profile_demo/profile_demo/domain/simulation_models.dart';
import 'package:datawedge_async_profile_demo/profile_demo/infrastructure/fake_profile_service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = SimulationPolicy(
    commandLatency: Duration(milliseconds: 40),
    pollInterval: Duration(seconds: 1),
    maxAttempts: 5,
    verificationTimeout: Duration(seconds: 5),
  );

  test('verifies a profile that activates before the first poll', () {
    fakeAsync((async) {
      final result = _runVerification(
        async: async,
        policy: policy,
        activationDelay: const Duration(milliseconds: 200),
      );

      async.elapse(const Duration(seconds: 1));
      async.flushMicrotasks();

      expect(result.value?.type, VerificationResultType.verified);
      expect(result.value?.attempts, 1);
    });
  });

  test('keeps polling when the profile activates later', () {
    fakeAsync((async) {
      final polls = <int>[];
      final result = _runVerification(
        async: async,
        policy: policy,
        activationDelay: const Duration(milliseconds: 1500),
        onPoll: polls.add,
      );

      async.elapse(const Duration(seconds: 1));
      async.flushMicrotasks();
      expect(result.value, isNull);
      expect(polls, <int>[1]);

      async.elapse(const Duration(seconds: 1));
      async.flushMicrotasks();
      expect(result.value?.type, VerificationResultType.verified);
      expect(result.value?.attempts, 2);
    });
  });

  test('fails after timeout when the profile never activates', () {
    fakeAsync((async) {
      final result = _runVerification(
        async: async,
        policy: policy,
        activationDelay: null,
      );

      async.elapse(policy.verificationTimeout);
      async.flushMicrotasks();

      expect(result.value?.type, VerificationResultType.failed);
      expect(result.value?.attempts, policy.maxAttempts);
    });
  });

  test('accepts activation exactly on the timeout boundary', () {
    fakeAsync((async) {
      final result = _runVerification(
        async: async,
        policy: policy,
        activationDelay: policy.verificationTimeout,
      );

      async.elapse(policy.verificationTimeout);
      async.flushMicrotasks();

      expect(result.value?.type, VerificationResultType.verified);
      expect(result.value?.attempts, policy.maxAttempts);
      expect(result.value?.elapsed, policy.verificationTimeout);
    });
  });

  test('never exceeds the configured maximum attempt count', () {
    fakeAsync((async) {
      const limitedPolicy = SimulationPolicy(
        commandLatency: Duration(milliseconds: 40),
        pollInterval: Duration(seconds: 1),
        maxAttempts: 3,
        verificationTimeout: Duration(seconds: 10),
      );
      final polls = <int>[];
      final result = _runVerification(
        async: async,
        policy: limitedPolicy,
        activationDelay: const Duration(seconds: 6),
        onPoll: polls.add,
      );

      async.elapse(const Duration(seconds: 3));
      async.flushMicrotasks();

      expect(result.value?.type, VerificationResultType.failed);
      expect(result.value?.attempts, 3);
      expect(polls, <int>[1, 2, 3]);
    });
  });

  test('both approaches share conditions but report readiness differently', () {
    fakeAsync((async) {
      final assumptionService = FakeProfileService(
        () => async.elapsed,
        policy: policy,
      );
      final verificationService = FakeProfileService(
        () => async.elapsed,
        policy: policy,
      );
      var assumptionDeclaredReady = false;
      VerificationResult? verificationResult;

      assumptionService
          .createProfile(
            profileName: 'DemoProfile',
            activationDelay: const Duration(milliseconds: 1500),
          )
          .then((_) => assumptionDeclaredReady = true);
      verificationService
          .createProfile(
            profileName: 'DemoProfile',
            activationDelay: const Duration(milliseconds: 1500),
          )
          .then((_) {
            final verifier = ProfileActivationVerifier(
              policy: policy,
              elapsed: () => async.elapsed,
              delay: Future<void>.delayed,
            );
            verifier
                .verify(
                  service: verificationService,
                  expectedProfile: 'DemoProfile',
                  shouldContinue: () => true,
                )
                .then((value) => verificationResult = value);
          });

      async.elapse(policy.commandLatency);
      async.flushMicrotasks();
      expect(assumptionDeclaredReady, isTrue);
      expect(verificationResult, isNull);
      _expectActiveProfile(async, assumptionService, isNull);

      async.elapse(const Duration(milliseconds: 1960));
      async.flushMicrotasks();
      _expectActiveProfile(async, assumptionService, 'DemoProfile');
      expect(verificationResult?.type, VerificationResultType.verified);

      assumptionService.dispose();
      verificationService.dispose();
    });
  });
}

_ResultBox _runVerification({
  required FakeAsync async,
  required SimulationPolicy policy,
  required Duration? activationDelay,
  void Function(int attempt)? onPoll,
}) {
  final service = FakeProfileService(() => async.elapsed, policy: policy);
  final result = _ResultBox();

  service
      .createProfile(
        profileName: 'DemoProfile',
        activationDelay: activationDelay,
      )
      .then((_) {
        final verifier = ProfileActivationVerifier(
          policy: policy,
          elapsed: () => async.elapsed,
          delay: Future<void>.delayed,
        );
        verifier
            .verify(
              service: service,
              expectedProfile: 'DemoProfile',
              shouldContinue: () => true,
              onPoll: (attempt, _) => onPoll?.call(attempt),
            )
            .then((value) {
              result.value = value;
              service.dispose();
            });
      });

  async.elapse(policy.commandLatency);
  async.flushMicrotasks();
  return result;
}

void _expectActiveProfile(
  FakeAsync async,
  FakeProfileService service,
  Object? matcher,
) {
  String? activeProfile;
  service.readActiveProfile().then((value) => activeProfile = value);
  async.flushMicrotasks();
  expect(activeProfile, matcher);
}

class _ResultBox {
  VerificationResult? value;
}
