import 'package:flutter/widgets.dart';

import '../profile_demo/domain/simulation_models.dart';
import 'generated/app_localizations.dart';

extension LocalizationBuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppLocalizationsX on AppLocalizations {
  String scenarioLabel(ActivationScenario scenario) => switch (scenario) {
    ActivationScenario.fast => scenarioFast,
    ActivationScenario.typical => scenarioTypical,
    ActivationScenario.boundary => scenarioBoundary,
    ActivationScenario.never => scenarioNever,
  };

  String scenarioDescription(ActivationScenario scenario) => switch (scenario) {
    ActivationScenario.fast => scenarioFastDescription,
    ActivationScenario.typical => scenarioTypicalDescription,
    ActivationScenario.boundary => scenarioBoundaryDescription,
    ActivationScenario.never => scenarioNeverDescription,
  };

  String timelineMessage(TimelineEntry entry, int maxAttempts) =>
      switch (entry.event) {
        TimelineEventType.commandDispatched => timelineCommandDispatched,
        TimelineEventType.futureCompleted => timelineFutureCompleted,
        TimelineEventType.readinessAssumed => timelineReadinessAssumed,
        TimelineEventType.verificationStarted => timelineVerificationStarted,
        TimelineEventType.pollingAttempt => timelinePollingAttempt(
          entry.attempt!,
          maxAttempts,
        ),
        TimelineEventType.activationVerified => timelineActivationVerified(
          entry.attempt!,
        ),
        TimelineEventType.verificationFailed => timelineVerificationFailed,
        TimelineEventType.profileActivated => timelineProfileActivated,
      };
}
