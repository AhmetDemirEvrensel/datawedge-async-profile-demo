import 'package:flutter/material.dart';

import '../../../l10n/app_localizations_x.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../domain/simulation_models.dart';

class ApproachCard extends StatelessWidget {
  const ApproachCard({
    super.key,
    required this.label,
    required this.title,
    required this.description,
    required this.snapshot,
    required this.accent,
    required this.verificationExpected,
    required this.isRunning,
    required this.maxAttempts,
  });

  final String label;
  final String title;
  final String description;
  final ApproachSnapshot snapshot;
  final Color accent;
  final bool verificationExpected;
  final bool isRunning;
  final int maxAttempts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Color(0xFF687083), height: 1.45),
            ),
            const SizedBox(height: 22),
            _StatusRow(
              label: l10n.statusCommandDispatched,
              state: snapshot.commandDispatched
                  ? _IndicatorState.success
                  : _IndicatorState.pending,
            ),
            _StatusRow(
              label: l10n.statusFutureCompleted,
              state: snapshot.futureCompleted
                  ? _IndicatorState.success
                  : _IndicatorState.pending,
            ),
            if (!verificationExpected)
              _StatusRow(
                label: l10n.statusReadinessAssumed,
                state: snapshot.readinessAssumedAt != null
                    ? _IndicatorState.warning
                    : _IndicatorState.pending,
              ),
            _StatusRow(
              label: l10n.statusServiceProfileActive,
              state: snapshot.profileActive
                  ? _IndicatorState.success
                  : snapshot.outcome == VerificationOutcome.idle || isRunning
                  ? _IndicatorState.pending
                  : _IndicatorState.negative,
            ),
            _StatusRow(
              label: l10n.statusActivationVerified,
              state: snapshot.activationVerified
                  ? _IndicatorState.success
                  : snapshot.verificationFailed
                  ? _IndicatorState.negative
                  : verificationExpected
                  ? _IndicatorState.pending
                  : _IndicatorState.notApplicable,
            ),
            if (verificationExpected)
              _StatusRow(
                label: l10n.statusVerificationFailed,
                state: snapshot.verificationFailed
                    ? _IndicatorState.failure
                    : snapshot.activationVerified
                    ? _IndicatorState.negative
                    : _IndicatorState.pending,
              ),
            const SizedBox(height: 18),
            _MeasurementPanel(
              snapshot: snapshot,
              verificationExpected: verificationExpected,
              isRunning: isRunning,
              maxAttempts: maxAttempts,
            ),
            const SizedBox(height: 18),
            _OutcomeBanner(
              snapshot: snapshot,
              accent: accent,
              verificationExpected: verificationExpected,
            ),
          ],
        ),
      ),
    );
  }
}

enum _IndicatorState {
  pending,
  success,
  warning,
  failure,
  negative,
  notApplicable,
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.state});

  final String label;
  final _IndicatorState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (icon, color, text) = switch (state) {
      _IndicatorState.pending => (
        Icons.radio_button_unchecked,
        const Color(0xFF98A0B3),
        l10n.statusWaiting,
      ),
      _IndicatorState.success => (
        Icons.check_circle_rounded,
        const Color(0xFF1B8A68),
        l10n.statusYes,
      ),
      _IndicatorState.warning => (
        Icons.warning_amber_rounded,
        const Color(0xFFE8871E),
        l10n.statusYes,
      ),
      _IndicatorState.failure => (
        Icons.error_rounded,
        const Color(0xFFC33D3D),
        l10n.statusYes,
      ),
      _IndicatorState.negative => (
        Icons.cancel_outlined,
        const Color(0xFF687083),
        l10n.statusNo,
      ),
      _IndicatorState.notApplicable => (
        Icons.remove_circle_outline_rounded,
        const Color(0xFF98A0B3),
        l10n.statusNotChecked,
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MeasurementPanel extends StatelessWidget {
  const _MeasurementPanel({
    required this.snapshot,
    required this.verificationExpected,
    required this.isRunning,
    required this.maxAttempts,
  });

  final ApproachSnapshot snapshot;
  final bool verificationExpected;
  final bool isRunning;
  final int maxAttempts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = verificationExpected
        ? <Widget>[
            _MeasurementRow(
              label: snapshot.verificationFailed
                  ? l10n.measurementTimeoutAt
                  : l10n.measurementVerificationAt,
              value: _timeValue(
                l10n,
                snapshot.verificationFinishedAt,
                pending: isRunning,
              ),
              valueKey: const Key('verification-time-value'),
            ),
            _MeasurementRow(
              label: l10n.measurementVerificationAttempt,
              value: snapshot.pollCount == 0
                  ? (isRunning ? l10n.valuePending : l10n.valueEmpty)
                  : l10n.attemptValue(snapshot.pollCount, maxAttempts),
              valueKey: const Key('verification-attempt-value'),
            ),
            _MeasurementRow(
              label: l10n.measurementServiceActivation,
              value: _activationValue(l10n),
            ),
          ]
        : <Widget>[
            _MeasurementRow(
              label: l10n.measurementAssumedAt,
              value: _timeValue(
                l10n,
                snapshot.readinessAssumedAt,
                pending: isRunning,
              ),
              valueKey: const Key('assumption-time-value'),
            ),
            _MeasurementRow(
              label: l10n.measurementProfileAtAssumption,
              value: switch (snapshot.profileActiveWhenAssumed) {
                true => l10n.statusYes,
                false => l10n.statusNo,
                null => isRunning ? l10n.valuePending : l10n.valueEmpty,
              },
              valueKey: const Key('profile-at-assumption-value'),
            ),
            _MeasurementRow(
              label: l10n.measurementServiceActivation,
              value: _activationValue(l10n),
              valueKey: const Key('service-activation-time-value'),
            ),
          ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: rows),
    );
  }

  String _activationValue(AppLocalizations l10n) {
    final activatedAt = snapshot.profileActivatedAt;
    if (activatedAt != null) {
      return l10n.millisecondsValue(activatedAt.inMilliseconds);
    }
    if (snapshot.outcome == VerificationOutcome.idle) {
      return l10n.valueEmpty;
    }
    return isRunning ? l10n.valuePending : l10n.statusNotObserved;
  }

  String _timeValue(
    AppLocalizations l10n,
    Duration? value, {
    required bool pending,
  }) {
    if (value != null) {
      return l10n.millisecondsValue(value.inMilliseconds);
    }
    return pending ? l10n.valuePending : l10n.valueEmpty;
  }
}

class _MeasurementRow extends StatelessWidget {
  const _MeasurementRow({
    required this.label,
    required this.value,
    this.valueKey,
  });

  final String label;
  final String value;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF687083), height: 1.35),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            key: valueKey,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w800, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _OutcomeBanner extends StatelessWidget {
  const _OutcomeBanner({
    required this.snapshot,
    required this.accent,
    required this.verificationExpected,
  });

  final ApproachSnapshot snapshot;
  final Color accent;
  final bool verificationExpected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = switch (snapshot.outcome) {
      VerificationOutcome.idle => l10n.outcomeIdle,
      VerificationOutcome.assumedReady =>
        snapshot.profileActiveWhenAssumed == true
            ? l10n.outcomeAssumedAfterActivation
            : l10n.outcomeAssumedInactive,
      VerificationOutcome.verifying => l10n.outcomeVerifying(
        snapshot.pollCount,
      ),
      VerificationOutcome.verified => l10n.outcomeVerified,
      VerificationOutcome.failed => l10n.outcomeFailed,
    };
    final color =
        snapshot.outcome == VerificationOutcome.failed ||
            (!verificationExpected &&
                snapshot.outcome == VerificationOutcome.assumedReady &&
                snapshot.profileActiveWhenAssumed == false)
        ? const Color(0xFFC33D3D)
        : accent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.4,
        ),
      ),
    );
  }
}
