import 'package:datawedge_async_profile_demo/profile_demo/application/profile_demo_controller.dart';
import 'package:datawedge_async_profile_demo/profile_demo/domain/simulation_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Approach A keeps its early assumption while service activation is observed later',
    () async {
      const policy = SimulationPolicy(
        commandLatency: Duration.zero,
        pollInterval: Duration(milliseconds: 250),
        maxAttempts: 1,
        verificationTimeout: Duration(milliseconds: 250),
      );
      final controller = ProfileDemoController(policy: policy);
      await controller.selectScenario(ActivationScenario.fast);

      final run = controller.runComparison();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(controller.assumption.futureCompleted, isTrue);
      expect(controller.assumption.readinessAssumedAt, isNotNull);
      expect(controller.assumption.profileActiveWhenAssumed, isFalse);
      expect(controller.assumption.activationVerified, isFalse);

      final assumptionEvents = controller.timeline
          .where((entry) => entry.lane == TimelineLane.assumption)
          .toList();
      expect(
        assumptionEvents.map((entry) => entry.event).take(3),
        orderedEquals(<TimelineEventType>[
          TimelineEventType.commandDispatched,
          TimelineEventType.futureCompleted,
          TimelineEventType.readinessAssumed,
        ]),
      );
      expect(assumptionEvents[1].elapsed, assumptionEvents[2].elapsed);

      await run;

      expect(controller.assumption.profileActive, isTrue);
      expect(controller.assumption.profileActivatedAt, isNotNull);
      expect(controller.assumption.profileActiveWhenAssumed, isFalse);
      expect(controller.verification.activationVerified, isTrue);
      expect(controller.verification.pollCount, 1);
      expect(controller.verification.verificationFinishedAt, isNotNull);

      controller.dispose();
    },
  );
}
