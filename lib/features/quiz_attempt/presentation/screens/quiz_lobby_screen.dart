import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/quiz_model.dart';

class QuizLobbyScreen extends StatelessWidget {
  const QuizLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = QuizModel.mockQuiz;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Lobby'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(quiz.courseCode),
                    backgroundColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    quiz.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quiz.courseTitle,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Exam Instructions & Rules',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _instructionItem(context, Icons.timer_outlined, 'Duration: ${quiz.durationMinutes} Minutes'),
            _instructionItem(context, Icons.quiz_outlined, 'Total Questions: ${quiz.questions.length} MCQs'),
            _instructionItem(context, Icons.remove_circle_outline, quiz.negativeMarking ? 'Negative Marking Enabled (0.25 per wrong answer)' : 'No Negative Marking'),
            _instructionItem(context, Icons.security_outlined, 'Anti-Cheat Protection: App minimizes / blurs will be logged'),
            _instructionItem(context, Icons.wifi_outlined, 'Ensure stable internet connection before starting'),
            const SizedBox(height: 36),
            CustomButton(
              text: 'Start Quiz Now',
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                context.push('/active-quiz', extra: quiz);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _instructionItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
