import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/formatters.dart';
import '../controllers/quiz_timer_controller.dart';

class TimerWidget extends ConsumerWidget {
  final int durationMinutes;
  final VoidCallback onTimeExpired;

  const TimerWidget({
    super.key,
    required this.durationMinutes,
    required this.onTimeExpired,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainingSeconds = ref.watch(quizTimerProvider(durationMinutes));
    final theme = Theme.of(context);

    if (remainingSeconds <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onTimeExpired();
      });
    }

    final isWarning = remainingSeconds < 120; // Last 2 minutes

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isWarning ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: isWarning ? theme.colorScheme.onErrorContainer : theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            Formatters.formatDuration(Duration(seconds: remainingSeconds)),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isWarning ? theme.colorScheme.onErrorContainer : theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
