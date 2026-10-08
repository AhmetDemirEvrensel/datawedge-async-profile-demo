import 'package:flutter/material.dart';

import '../../../l10n/app_localizations_x.dart';
import '../../domain/simulation_models.dart';

class ScenarioSelector extends StatelessWidget {
  const ScenarioSelector({
    super.key,
    required this.selected,
    required this.isRunning,
    required this.policy,
    required this.onSelected,
    required this.onRun,
    required this.onReset,
  });

  final ActivationScenario selected;
  final bool isRunning;
  final SimulationPolicy policy;
  final Future<void> Function(ActivationScenario scenario) onSelected;
  final Future<void> Function() onRun;
  final Future<void> Function() onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.chooseActivationDelay,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.scenarioDescription(selected),
              style: const TextStyle(color: Color(0xFF687083), height: 1.4),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ActivationScenario.values.map((scenario) {
                return ChoiceChip(
                  label: Text(l10n.scenarioLabel(scenario)),
                  selected: selected == scenario,
                  onSelected: (isSelected) async {
                    if (isSelected) {
                      await onSelected(scenario);
                    }
                  },
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 18,
              runSpacing: 8,
              children: <Widget>[
                _PolicyValue(
                  label: l10n.policyCommandFuture,
                  value: '${policy.commandLatency.inMilliseconds} ms',
                ),
                _PolicyValue(
                  label: l10n.policyPollInterval,
                  value: '${policy.pollInterval.inMilliseconds} ms',
                ),
                _PolicyValue(
                  label: l10n.policyMaxAttempts,
                  value: '${policy.maxAttempts}',
                ),
                _PolicyValue(
                  label: l10n.policyTimeout,
                  value: '${policy.verificationTimeout.inMilliseconds} ms',
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton.icon(
                    key: const Key('run-comparison-button'),
                    onPressed: isRunning ? null : onRun,
                    icon: isRunning
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      isRunning ? l10n.simulationRunning : l10n.runSimulation,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  key: const Key('reset-button'),
                  onPressed: onReset,
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: Text(l10n.reset),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyValue extends StatelessWidget {
  const _PolicyValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(
          context,
        ).style.copyWith(color: const Color(0xFF687083)),
        children: <InlineSpan>[
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF242936),
            ),
          ),
        ],
      ),
    );
  }
}
