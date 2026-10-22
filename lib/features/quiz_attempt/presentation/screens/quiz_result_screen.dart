import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/attempt_model.dart';
import '../../data/models/quiz_model.dart';

class QuizResultScreen extends StatelessWidget {
  final AttemptModel attempt;

  const QuizResultScreen({super.key, required this.attempt});

  @override
  Widget build(BuildContext context) {
    final quiz = QuizModel.mockQuiz; // or fetched quiz
    final theme = Theme.of(context);
    final incorrectCount = attempt.totalQuestions - attempt.score;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Quiz Result & Review'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    attempt.isPassed ? '🎉 Excellent Job!' : '📚 Keep Practicing!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${attempt.score} / ${attempt.totalQuestions}',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Score: ${attempt.percentage.toStringAsFixed(1)}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _badge(Icons.timer_outlined, 'Time: ${Formatters.formatDuration(attempt.timeTaken)}'),
                      const SizedBox(width: 16),
                      _badge(Icons.check_circle_outline, 'Passed: ${attempt.isPassed ? "Yes" : "No"}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Breakdown Stats
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(height: 8),
                          const Text('Correct', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${attempt.score}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.cancel, color: Colors.red),
                          const SizedBox(height: 8),
                          const Text('Incorrect', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('$incorrectCount', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Question-by-Question Review',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(quiz.questions.length, (index) {
              final question = quiz.questions[index];
              final studentChoice = attempt.selectedAnswers[index];
              final isCorrect = studentChoice == question.correctOptionIndex;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text('Question ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(question.questionText, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Text('Your Answer: ${studentChoice != null ? question.options[studentChoice] : "Not Answered"}',
                          style: TextStyle(color: isCorrect ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                      if (!isCorrect)
                        Text('Correct Answer: ${question.options[question.correctOptionIndex]}',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Explanation: ${question.explanation}'),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Back to Dashboard',
              onPressed: () => context.go('/student-dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
