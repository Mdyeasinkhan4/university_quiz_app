import 'package:flutter/material.dart';
import '../../data/models/question_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int questionNumber;
  final int totalQuestions;
  final bool isFlagged;
  final VoidCallback onToggleFlag;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.isFlagged,
    required this.onToggleFlag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question $questionNumber of $totalQuestions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(
                isFlagged ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isFlagged ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: onToggleFlag,
              tooltip: 'Flag for review',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          question.questionText,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        if (question.codeSnippet != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
            ),
            child: Text(
              question.codeSnippet!,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
