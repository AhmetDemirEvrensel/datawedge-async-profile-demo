import 'package:flutter/material.dart';

import '../../../l10n/app_localizations_x.dart';
import '../../domain/simulation_models.dart';

class TimelinePanel extends StatelessWidget {
  const TimelinePanel({
    super.key,
    required this.entries,
    required this.isRunning,
    required this.maxAttempts,
  });

  final List<TimelineEntry> entries;
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    l10n.timelineTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (isRunning)
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.timelineStopwatchDescription,
              style: const TextStyle(color: Color(0xFF687083)),
            ),
            const SizedBox(height: 18),
            if (entries.isEmpty)
              const _EmptyTimeline()
            else
              ...entries.map(
                (entry) => _TimelineRow(entry: entry, maxAttempts: maxAttempts),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        context.l10n.timelineEmpty,
        style: const TextStyle(color: Color(0xFF7C8496)),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry, required this.maxAttempts});

  final TimelineEntry entry;
  final int maxAttempts;

  @override
  Widget build(BuildContext context) {
    final laneColor = entry.lane == TimelineLane.assumption
        ? const Color(0xFFE8871E)
        : const Color(0xFF1B8A68);
    final laneLabel = entry.lane == TimelineLane.assumption ? 'A' : 'B';
    final eventColor = switch (entry.kind) {
      TimelineKind.info => const Color(0xFF3155D9),
      TimelineKind.success => const Color(0xFF1B8A68),
      TimelineKind.warning => const Color(0xFFE8871E),
      TimelineKind.error => const Color(0xFFC33D3D),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 82,
            child: Text(
              '${entry.elapsed.inMilliseconds.toString().padLeft(4)} ms',
              style: const TextStyle(
                fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: laneColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              laneLabel,
              style: TextStyle(color: laneColor, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: eventColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.timelineMessage(entry, maxAttempts),
              style: const TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
