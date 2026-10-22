import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../course/data/models/course_model.dart';
import '../../../quiz_attempt/data/models/quiz_model.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final theme = Theme.of(context);
    final activeQuiz = QuizModel.mockQuiz;
    final courses = CourseModel.mockCourses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.name ?? "Student"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem('GPA', '3.85', theme.colorScheme.onPrimary),
                  _verticalDivider(),
                  _statItem('Completed', '14 Tests', theme.colorScheme.onPrimary),
                  _verticalDivider(),
                  _statItem('Enrolled', '${courses.length} Courses', theme.colorScheme.onPrimary),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Examination', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => context.push('/enrolled-courses'),
                  child: const Text('All Courses'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(activeQuiz.courseCode),
                          backgroundColor: theme.colorScheme.primaryContainer,
                        ),
                        Text(
                          DateTimeHelpers.timeRemaining(activeQuiz.deadline),
                          style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      activeQuiz.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Duration: ${activeQuiz.durationMinutes} mins • ${activeQuiz.questions.length} MCQs'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => context.push('/quiz-lobby', extra: activeQuiz),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Enter Quiz Lobby'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text('Enrolled Courses', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...courses.take(3).map((course) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${course.code} • ${course.instructor}'),
                  trailing: Text('${(course.progress * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  onTap: () => context.push('/course-details', extra: course),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: textColor.withOpacity(0.8))),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 30, width: 1, color: Colors.white24);
  }
}
