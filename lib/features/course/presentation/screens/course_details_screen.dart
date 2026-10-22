import 'package:flutter/material.dart';
import '../../data/models/course_model.dart';

class CourseDetailsScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              course.department,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow(context, Icons.person_outline, 'Instructor', course.instructor),
                    const Divider(height: 24),
                    _infoRow(context, Icons.group_outlined, 'Enrolled Students', '${course.enrolledStudents} Students'),
                    const Divider(height: 24),
                    _infoRow(context, Icons.analytics_outlined, 'Course Progress', '${(course.progress * 100).toInt()}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Syllabus & Modules',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(4, (index) {
              return ExpansionTile(
                title: Text('Module ${index + 1}: Core Concepts & Practice'),
                subtitle: Text('Week ${index + 1} Lectures & Quiz'),
                children: [
                  ListTile(
                    leading: const Icon(Icons.menu_book_outlined),
                    title: const Text('Lecture Notes & Slides'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.quiz_outlined),
                    title: const Text('Practice Quiz'),
                    onTap: () {},
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
