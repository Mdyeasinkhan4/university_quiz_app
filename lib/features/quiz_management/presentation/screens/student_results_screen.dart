import 'package:flutter/material.dart';

class StudentResultsScreen extends StatelessWidget {
  const StudentResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mockResults = [
      {'name': 'Alex Johnson', 'id': 'CSE-2023-045', 'score': '5/5', 'percentage': '100%'},
      {'name': 'Sarah Smith', 'id': 'CSE-2023-046', 'score': '4/5', 'percentage': '80%'},
      {'name': 'Michael Brown', 'id': 'CSE-2023-047', 'score': '3/5', 'percentage': '60%'},
      {'name': 'Emily Davis', 'id': 'CSE-2023-048', 'score': '5/5', 'percentage': '100%'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Submissions & Results'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockResults.length,
        itemBuilder: (context, index) {
          final res = mockResults[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text('${index + 1}', style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
              ),
              title: Text(res['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('ID: ${res['id']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(res['score']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(res['percentage']!, style: TextStyle(color: theme.colorScheme.primary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
