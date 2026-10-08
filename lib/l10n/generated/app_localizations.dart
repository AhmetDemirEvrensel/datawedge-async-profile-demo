import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Async Profile Readiness Demo'**
  String get appTitle;

  /// No description provided for @heroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ASYNC READINESS LAB'**
  String get heroEyebrow;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'A completed Future is not the same as a ready external system.'**
  String get heroTitle;

  /// No description provided for @heroDescription.
  ///
  /// In en, this message translates to:
  /// **'Run both approaches under the exact same simulated activation delay and watch their timelines diverge.'**
  String get heroDescription;

  /// No description provided for @simulationNotice.
  ///
  /// In en, this message translates to:
  /// **'This app does not connect to Zebra DataWedge. It is a controlled simulation of a broader async integration problem: command acknowledgement can arrive before external readiness.'**
  String get simulationNotice;

  /// No description provided for @chooseActivationDelay.
  ///
  /// In en, this message translates to:
  /// **'Choose an activation delay'**
  String get chooseActivationDelay;

  /// No description provided for @scenarioFast.
  ///
  /// In en, this message translates to:
  /// **'200 ms'**
  String get scenarioFast;

  /// No description provided for @scenarioTypical.
  ///
  /// In en, this message translates to:
  /// **'1500 ms'**
  String get scenarioTypical;

  /// No description provided for @scenarioBoundary.
  ///
  /// In en, this message translates to:
  /// **'5000 ms'**
  String get scenarioBoundary;

  /// No description provided for @scenarioNever.
  ///
  /// In en, this message translates to:
  /// **'Never activates'**
  String get scenarioNever;

  /// No description provided for @scenarioFastDescription.
  ///
  /// In en, this message translates to:
  /// **'The profile activates before the first poll.'**
  String get scenarioFastDescription;

  /// No description provided for @scenarioTypicalDescription.
  ///
  /// In en, this message translates to:
  /// **'The first poll misses it; a later poll succeeds.'**
  String get scenarioTypicalDescription;

  /// No description provided for @scenarioBoundaryDescription.
  ///
  /// In en, this message translates to:
  /// **'Activation lands exactly on the verification deadline.'**
  String get scenarioBoundaryDescription;

  /// No description provided for @scenarioNeverDescription.
  ///
  /// In en, this message translates to:
  /// **'No activation event is produced.'**
  String get scenarioNeverDescription;

  /// No description provided for @policyCommandFuture.
  ///
  /// In en, this message translates to:
  /// **'Command Future'**
  String get policyCommandFuture;

  /// No description provided for @policyPollInterval.
  ///
  /// In en, this message translates to:
  /// **'Poll interval'**
  String get policyPollInterval;

  /// No description provided for @policyMaxAttempts.
  ///
  /// In en, this message translates to:
  /// **'Max attempts'**
  String get policyMaxAttempts;

  /// No description provided for @policyTimeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get policyTimeout;

  /// No description provided for @simulationRunning.
  ///
  /// In en, this message translates to:
  /// **'Simulation running…'**
  String get simulationRunning;

  /// No description provided for @runSimulation.
  ///
  /// In en, this message translates to:
  /// **'Run simulation'**
  String get runSimulation;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @approachA.
  ///
  /// In en, this message translates to:
  /// **'Approach A'**
  String get approachA;

  /// No description provided for @approachATitle.
  ///
  /// In en, this message translates to:
  /// **'Assume the Future means ready'**
  String get approachATitle;

  /// No description provided for @approachADescription.
  ///
  /// In en, this message translates to:
  /// **'Stops at Future completion and never checks the external state.'**
  String get approachADescription;

  /// No description provided for @approachB.
  ///
  /// In en, this message translates to:
  /// **'Approach B'**
  String get approachB;

  /// No description provided for @approachBTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify the observable state'**
  String get approachBTitle;

  /// No description provided for @approachBDescription.
  ///
  /// In en, this message translates to:
  /// **'Polls the active profile with bounded attempts and a hard deadline.'**
  String get approachBDescription;

  /// No description provided for @statusCommandDispatched.
  ///
  /// In en, this message translates to:
  /// **'Command dispatched'**
  String get statusCommandDispatched;

  /// No description provided for @statusFutureCompleted.
  ///
  /// In en, this message translates to:
  /// **'Future completed'**
  String get statusFutureCompleted;

  /// No description provided for @statusReadinessAssumed.
  ///
  /// In en, this message translates to:
  /// **'Readiness assumed'**
  String get statusReadinessAssumed;

  /// No description provided for @statusServiceProfileActive.
  ///
  /// In en, this message translates to:
  /// **'Simulated service profile active'**
  String get statusServiceProfileActive;

  /// No description provided for @statusActivationVerified.
  ///
  /// In en, this message translates to:
  /// **'Activation verified'**
  String get statusActivationVerified;

  /// No description provided for @statusVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed / timeout'**
  String get statusVerificationFailed;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// No description provided for @statusYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get statusYes;

  /// No description provided for @statusNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get statusNo;

  /// No description provided for @statusNotChecked.
  ///
  /// In en, this message translates to:
  /// **'Not checked'**
  String get statusNotChecked;

  /// No description provided for @statusNotObserved.
  ///
  /// In en, this message translates to:
  /// **'Not observed'**
  String get statusNotObserved;

  /// No description provided for @measurementAssumedAt.
  ///
  /// In en, this message translates to:
  /// **'Ready assumed at'**
  String get measurementAssumedAt;

  /// No description provided for @measurementProfileAtAssumption.
  ///
  /// In en, this message translates to:
  /// **'Profile active at that moment'**
  String get measurementProfileAtAssumption;

  /// No description provided for @measurementServiceActivation.
  ///
  /// In en, this message translates to:
  /// **'Simulated service activation'**
  String get measurementServiceActivation;

  /// No description provided for @measurementVerificationAt.
  ///
  /// In en, this message translates to:
  /// **'Activation verified at'**
  String get measurementVerificationAt;

  /// No description provided for @measurementVerificationAttempt.
  ///
  /// In en, this message translates to:
  /// **'Successful polling attempt'**
  String get measurementVerificationAttempt;

  /// No description provided for @measurementTimeoutAt.
  ///
  /// In en, this message translates to:
  /// **'Timeout reported at'**
  String get measurementTimeoutAt;

  /// No description provided for @millisecondsValue.
  ///
  /// In en, this message translates to:
  /// **'{milliseconds} ms'**
  String millisecondsValue(int milliseconds);

  /// No description provided for @attemptValue.
  ///
  /// In en, this message translates to:
  /// **'Attempt {attempt} of {maxAttempts}'**
  String attemptValue(int attempt, int maxAttempts);

  /// No description provided for @valuePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get valuePending;

  /// No description provided for @valueEmpty.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get valueEmpty;

  /// No description provided for @outcomeIdle.
  ///
  /// In en, this message translates to:
  /// **'Run the comparison to see this approach.'**
  String get outcomeIdle;

  /// No description provided for @outcomeAssumedAfterActivation.
  ///
  /// In en, this message translates to:
  /// **'Result: readiness was assumed after the simulated profile was already active, but Approach A still did not verify it.'**
  String get outcomeAssumedAfterActivation;

  /// No description provided for @outcomeAssumedInactive.
  ///
  /// In en, this message translates to:
  /// **'Result: readiness was assumed while the profile was still inactive.'**
  String get outcomeAssumedInactive;

  /// No description provided for @outcomeVerifying.
  ///
  /// In en, this message translates to:
  /// **'Polling active profile… {count} completed.'**
  String outcomeVerifying(int count);

  /// No description provided for @outcomeVerified.
  ///
  /// In en, this message translates to:
  /// **'Ready was declared only after the active profile matched.'**
  String get outcomeVerified;

  /// No description provided for @outcomeFailed.
  ///
  /// In en, this message translates to:
  /// **'Readiness was not observed within the bounded policy.'**
  String get outcomeFailed;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Live timeline'**
  String get timelineTitle;

  /// No description provided for @timelineStopwatchDescription.
  ///
  /// In en, this message translates to:
  /// **'Every timestamp comes from the Stopwatch used by this run.'**
  String get timelineStopwatchDescription;

  /// No description provided for @timelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events yet. Pick a delay and run the comparison.'**
  String get timelineEmpty;

  /// No description provided for @timelineCommandDispatched.
  ///
  /// In en, this message translates to:
  /// **'createProfile command dispatched.'**
  String get timelineCommandDispatched;

  /// No description provided for @timelineFutureCompleted.
  ///
  /// In en, this message translates to:
  /// **'Command Future completed.'**
  String get timelineFutureCompleted;

  /// No description provided for @timelineReadinessAssumed.
  ///
  /// In en, this message translates to:
  /// **'Approach A assumed the profile was ready without verification.'**
  String get timelineReadinessAssumed;

  /// No description provided for @timelineVerificationStarted.
  ///
  /// In en, this message translates to:
  /// **'Approach B started readiness verification.'**
  String get timelineVerificationStarted;

  /// No description provided for @timelinePollingAttempt.
  ///
  /// In en, this message translates to:
  /// **'Active profile queried (attempt {attempt}/{maxAttempts}).'**
  String timelinePollingAttempt(int attempt, int maxAttempts);

  /// No description provided for @timelineActivationVerified.
  ///
  /// In en, this message translates to:
  /// **'Activation verified after {count} poll(s).'**
  String timelineActivationVerified(int count);

  /// No description provided for @timelineVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed: timeout or maximum attempts reached.'**
  String get timelineVerificationFailed;

  /// No description provided for @timelineProfileActivated.
  ///
  /// In en, this message translates to:
  /// **'The profile became active in the simulated service.'**
  String get timelineProfileActivated;

  /// No description provided for @boundaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Boundary rule'**
  String get boundaryTitle;

  /// No description provided for @boundaryDescription.
  ///
  /// In en, this message translates to:
  /// **'At exactly 5000 ms, the verifier performs its final profile query before declaring a timeout. Activation scheduled on the deadline is therefore accepted; activation after the deadline is not.'**
  String get boundaryDescription;

  /// No description provided for @languageSelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectorLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
