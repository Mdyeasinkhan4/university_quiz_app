import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';

class SubmitDialog extends StatelessWidget {
  final int answeredCount;
  final int totalCount;
  final int flaggedCount;
  final VoidCallback onSubmitConfirmed;

  const SubmitDialog({
    super.key,
    required this.answeredCount,
    required this.totalCount,
    required this.flaggedCount,
    required this.onSubmitConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Submit Quiz Confirmation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Are you sure you want to submit your quiz? Once submitted, you cannot modify your answers.'),
          const SizedBox(height: 20),
          _statRow(context, 'Answered Questions', '$answeredCount / $totalCount', theme.colorScheme.primary),
          const SizedBox(height: 8),
          _statRow(context, 'Flagged for Review', '$flaggedCount', theme.colorScheme.error),
          const SizedBox(height: 8),
          _statRow(context, 'Unanswered', '${totalCount - answeredCount}', theme.colorScheme.secondary),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Continue Quiz'),
        ),
        SizedBox(
          width: 120,
          child: CustomButton(
            text: 'Submit',
            onPressed: () {
              Navigator.pop(context);
              onSubmitConfirmed();
            },
          ),
        ),
      ],
    );
  }

  Widget _statRow(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
