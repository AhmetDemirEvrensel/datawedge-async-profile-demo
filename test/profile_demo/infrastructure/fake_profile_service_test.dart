import 'package:datawedge_async_profile_demo/profile_demo/domain/simulation_models.dart';
import 'package:datawedge_async_profile_demo/profile_demo/infrastructure/fake_profile_service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = SimulationPolicy(commandLatency: Duration(milliseconds: 40));

  test('command Future can complete before the profile becomes active', () {
    fakeAsync((async) {
      final service = FakeProfileService(() => async.elapsed, policy: policy);
      var commandCompleted = false;

      service
          .createProfile(
            profileName: 'DemoProfile',
            activationDelay: const Duration(milliseconds: 200),
          )
          .then((_) => commandCompleted = true);

      async.elapse(policy.commandLatency);
      async.flushMicrotasks();

      expect(commandCompleted, isTrue);
      _expectActiveProfile(async, service, isNull);

      async.elapse(const Duration(milliseconds: 160));
      _expectActiveProfile(async, service, 'DemoProfile');
      service.dispose();
    });
  });

  test('reset cancels timers and responses from the previous run', () {
    fakeAsync((async) {
      final service = FakeProfileService(() => async.elapsed, policy: policy);

      service
          .createProfile(
            profileName: 'OldProfile',
            activationDelay: const Duration(milliseconds: 200),
          )
          .catchError((Object _) {});
      async.elapse(const Duration(milliseconds: 10));
      service.reset();
      service.createProfile(
        profileName: 'NewProfile',
        activationDelay: const Duration(milliseconds: 500),
      );

      async.elapse(const Duration(milliseconds: 190));
      async.flushMicrotasks();
      _expectActiveProfile(async, service, isNull);

      async.elapse(const Duration(milliseconds: 310));
      _expectActiveProfile(async, service, 'NewProfile');
      service.dispose();
    });
  });
}

void _expectActiveProfile(
  FakeAsync async,
  FakeProfileService service,
  Object? matcher,
) {
  String? activeProfile;
  var completed = false;
  service.readActiveProfile().then((value) {
    activeProfile = value;
    completed = true;
  });
  async.flushMicrotasks();
  expect(completed, isTrue);
  expect(activeProfile, matcher);
}
