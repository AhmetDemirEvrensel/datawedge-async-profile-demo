// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Async Profile Readiness Demo';

  @override
  String get heroEyebrow => 'ASYNC READINESS LAB';

  @override
  String get heroTitle =>
      'A completed Future is not the same as a ready external system.';

  @override
  String get heroDescription =>
      'Run both approaches under the exact same simulated activation delay and watch their timelines diverge.';

  @override
  String get simulationNotice =>
      'This app does not connect to Zebra DataWedge. It is a controlled simulation of a broader async integration problem: command acknowledgement can arrive before external readiness.';

  @override
  String get chooseActivationDelay => 'Choose an activation delay';

  @override
  String get scenarioFast => '200 ms';

  @override
  String get scenarioTypical => '1500 ms';

  @override
  String get scenarioBoundary => '5000 ms';

  @override
  String get scenarioNever => 'Never activates';

  @override
  String get scenarioFastDescription =>
      'The profile activates before the first poll.';

  @override
  String get scenarioTypicalDescription =>
      'The first poll misses it; a later poll succeeds.';

  @override
  String get scenarioBoundaryDescription =>
      'Activation lands exactly on the verification deadline.';

  @override
  String get scenarioNeverDescription => 'No activation event is produced.';

  @override
  String get policyCommandFuture => 'Command Future';

  @override
  String get policyPollInterval => 'Poll interval';

  @override
  String get policyMaxAttempts => 'Max attempts';

  @override
  String get policyTimeout => 'Timeout';

  @override
  String get simulationRunning => 'Simulation running…';

  @override
  String get runSimulation => 'Run simulation';

  @override
  String get reset => 'Reset';

  @override
  String get approachA => 'Approach A';

  @override
  String get approachATitle => 'Assume the Future means ready';

  @override
  String get approachADescription =>
      'Stops at Future completion and never checks the external state.';

  @override
  String get approachB => 'Approach B';

  @override
  String get approachBTitle => 'Verify the observable state';

  @override
  String get approachBDescription =>
      'Polls the active profile with bounded attempts and a hard deadline.';

  @override
  String get statusCommandDispatched => 'Command dispatched';

  @override
  String get statusFutureCompleted => 'Future completed';

  @override
  String get statusReadinessAssumed => 'Readiness assumed';

  @override
  String get statusServiceProfileActive => 'Simulated service profile active';

  @override
  String get statusActivationVerified => 'Activation verified';

  @override
  String get statusVerificationFailed => 'Verification failed / timeout';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get statusYes => 'Yes';

  @override
  String get statusNo => 'No';

  @override
  String get statusNotChecked => 'Not checked';

  @override
  String get statusNotObserved => 'Not observed';

  @override
  String get measurementAssumedAt => 'Ready assumed at';

  @override
  String get measurementProfileAtAssumption => 'Profile active at that moment';

  @override
  String get measurementServiceActivation => 'Simulated service activation';

  @override
  String get measurementVerificationAt => 'Activation verified at';

  @override
  String get measurementVerificationAttempt => 'Successful polling attempt';

  @override
  String get measurementTimeoutAt => 'Timeout reported at';

  @override
  String millisecondsValue(int milliseconds) {
    return '$milliseconds ms';
  }

  @override
  String attemptValue(int attempt, int maxAttempts) {
    return 'Attempt $attempt of $maxAttempts';
  }

  @override
  String get valuePending => 'Pending';

  @override
  String get valueEmpty => '—';

  @override
  String get outcomeIdle => 'Run the comparison to see this approach.';

  @override
  String get outcomeAssumedAfterActivation =>
      'Result: readiness was assumed after the simulated profile was already active, but Approach A still did not verify it.';

  @override
  String get outcomeAssumedInactive =>
      'Result: readiness was assumed while the profile was still inactive.';

  @override
  String outcomeVerifying(int count) {
    return 'Polling active profile… $count completed.';
  }

  @override
  String get outcomeVerified =>
      'Ready was declared only after the active profile matched.';

  @override
  String get outcomeFailed =>
      'Readiness was not observed within the bounded policy.';

  @override
  String get timelineTitle => 'Live timeline';

  @override
  String get timelineStopwatchDescription =>
      'Every timestamp comes from the Stopwatch used by this run.';

  @override
  String get timelineEmpty =>
      'No events yet. Pick a delay and run the comparison.';

  @override
  String get timelineCommandDispatched => 'createProfile command dispatched.';

  @override
  String get timelineFutureCompleted => 'Command Future completed.';

  @override
  String get timelineReadinessAssumed =>
      'Approach A assumed the profile was ready without verification.';

  @override
  String get timelineVerificationStarted =>
      'Approach B started readiness verification.';

  @override
  String timelinePollingAttempt(int attempt, int maxAttempts) {
    return 'Active profile queried (attempt $attempt/$maxAttempts).';
  }

  @override
  String timelineActivationVerified(int count) {
    return 'Activation verified after $count poll(s).';
  }

  @override
  String get timelineVerificationFailed =>
      'Verification failed: timeout or maximum attempts reached.';

  @override
  String get timelineProfileActivated =>
      'The profile became active in the simulated service.';

  @override
  String get boundaryTitle => 'Boundary rule';

  @override
  String get boundaryDescription =>
      'At exactly 5000 ms, the verifier performs its final profile query before declaring a timeout. Activation scheduled on the deadline is therefore accepted; activation after the deadline is not.';

  @override
  String get languageSelectorLabel => 'Language';
}
