import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/course_model.dart';

class EnrolledCoursesScreen extends StatelessWidget {
  const EnrolledCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = CourseModel.mockCourses;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrolled Courses'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/course-details', extra: course),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(course.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                          backgroundColor: theme.colorScheme.primaryContainer,
                        ),
                        Text('${(course.progress * 100).toInt()}% Completed',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Instructor: ${course.instructor}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: course.progress,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
