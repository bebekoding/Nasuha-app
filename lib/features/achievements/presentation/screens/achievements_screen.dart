import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/achievement_repository.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAch = ref.watch(achievementsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pencapaian')),
      body: asyncAch.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final a = list[i];
              final unlocked = a.isUnlocked;
              final progress = (a.currentValue / a.targetValue).clamp(0.0, 1.0);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: unlocked
                            ? const Color(0xFFC1923C).withValues(alpha: 0.2)
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        child: Icon(
                          unlocked
                              ? Icons.emoji_events
                              : Icons.lock_outline,
                          color: unlocked
                              ? const Color(0xFFC1923C)
                              : Theme.of(context).colorScheme.outline,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            Text(a.description,
                                style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${a.currentValue} / ${a.targetValue}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
