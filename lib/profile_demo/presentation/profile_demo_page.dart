import 'package:flutter/material.dart';

import '../../l10n/app_localizations_x.dart';
import '../application/profile_demo_controller.dart';
import '../domain/simulation_models.dart';
import 'widgets/approach_card.dart';
import 'widgets/scenario_selector.dart';
import 'widgets/timeline_panel.dart';

class ProfileDemoPage extends StatefulWidget {
  const ProfileDemoPage({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<ProfileDemoPage> createState() => _ProfileDemoPageState();
}

class _ProfileDemoPageState extends State<ProfileDemoPage> {
  late final ProfileDemoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileDemoController()..addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: SelectionArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _HeroSection(
                      locale: widget.locale,
                      onLocaleChanged: widget.onLocaleChanged,
                    ),
                    const SizedBox(height: 20),
                    const _SimulationNotice(),
                    const SizedBox(height: 20),
                    ScenarioSelector(
                      selected: _controller.scenario,
                      isRunning: _controller.isRunning,
                      policy: _controller.policy,
                      onSelected: _controller.selectScenario,
                      onRun: _controller.runComparison,
                      onReset: _controller.reset,
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cards = <Widget>[
                          ApproachCard(
                            key: const Key('approach-a-card'),
                            label: l10n.approachA,
                            title: l10n.approachATitle,
                            description: l10n.approachADescription,
                            snapshot: _controller.assumption,
                            accent: const Color(0xFFE8871E),
                            verificationExpected: false,
                            isRunning: _controller.isRunning,
                            maxAttempts: _controller.policy.maxAttempts,
                          ),
                          ApproachCard(
                            key: const Key('approach-b-card'),
                            label: l10n.approachB,
                            title: l10n.approachBTitle,
                            description: l10n.approachBDescription,
                            snapshot: _controller.verification,
                            accent: const Color(0xFF1B8A68),
                            verificationExpected: true,
                            isRunning: _controller.isRunning,
                            maxAttempts: _controller.policy.maxAttempts,
                          ),
                        ];

                        if (constraints.maxWidth >= 820) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(child: cards.first),
                              const SizedBox(width: 20),
                              Expanded(child: cards.last),
                            ],
                          );
                        }

                        return Column(
                          children: <Widget>[
                            cards.first,
                            const SizedBox(height: 20),
                            cards.last,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TimelinePanel(
                      entries: _controller.timeline,
                      isRunning: _controller.isRunning,
                      maxAttempts: _controller.policy.maxAttempts,
                    ),
                    if (_controller.scenario ==
                        ActivationScenario.boundary) ...<Widget>[
                      const SizedBox(height: 20),
                      const _BoundaryNote(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.locale, required this.onLocaleChanged});

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                l10n.heroEyebrow,
                style: textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _LanguageSelector(locale: locale, onLocaleChanged: onLocaleChanged),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          l10n.heroTitle,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.08,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.heroDescription,
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF5E6678),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.locale,
    required this.onLocaleChanged,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.languageSelectorLabel,
      child: SegmentedButton<String>(
        key: const Key('language-selector'),
        showSelectedIcon: false,
        segments: const <ButtonSegment<String>>[
          ButtonSegment<String>(value: 'tr', label: Text('TR')),
          ButtonSegment<String>(value: 'en', label: Text('EN')),
        ],
        selected: <String>{locale.languageCode},
        onSelectionChanged: (selection) {
          onLocaleChanged(Locale(selection.single));
        },
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _SimulationNotice extends StatelessWidget {
  const _SimulationNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFC8D5FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.science_outlined, color: Color(0xFF3155D9)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.simulationNotice,
              style: const TextStyle(
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: Color(0xFF24345E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoundaryNote extends StatelessWidget {
  const _BoundaryNote();

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
              l10n.boundaryTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.boundaryDescription,
              style: const TextStyle(height: 1.5, color: Color(0xFF5E6678)),
            ),
          ],
        ),
      ),
    );
  }
}
