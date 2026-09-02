import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_providers.dart';
import 'package:inline_hockey_coach/features/sync/application/sync_service.dart';

class SyncStatusPanel extends ConsumerWidget {
  const SyncStatusPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(syncSummaryProvider);

    return summary.when(
      data: (value) => _SyncStatusContent(summary: value),
      error: (error, _) => _SyncStatusContent(
        summary: const SyncSummary(
          failedCount: 1,
          pendingCount: 0,
          status: SyncDisplayStatus.error,
          syncingCount: 0,
        ),
        errorText: '$error',
      ),
      loading: () => const LinearProgressIndicator(minHeight: 4),
    );
  }
}

class _SyncStatusContent extends ConsumerWidget {
  const _SyncStatusContent({required this.summary, this.errorText});

  final String? errorText;
  final SyncSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = switch (summary.status) {
      SyncDisplayStatus.synced => colors.primary,
      SyncDisplayStatus.pending => colors.tertiary,
      SyncDisplayStatus.syncing => colors.tertiary,
      SyncDisplayStatus.offline => colors.outline,
      SyncDisplayStatus.error => colors.error,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.sync, color: statusColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    summary.status.label,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (summary.status == SyncDisplayStatus.syncing)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SyncCount(label: 'Pendientes', value: summary.pendingCount),
                _SyncCount(label: 'Enviando', value: summary.syncingCount),
                _SyncCount(label: 'Errores', value: summary.failedCount),
              ],
            ),
            if (errorText != null) ...[
              const SizedBox(height: 8),
              Text(errorText!, style: TextStyle(color: colors.error)),
            ],
            if (summary.hasFailures) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(syncControllerProvider).manualRetry();
                    ref.invalidate(syncSummaryProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SyncCount extends StatelessWidget {
  const _SyncCount({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Text('$label $value');
  }
}
