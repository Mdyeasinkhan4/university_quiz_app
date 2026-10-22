import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../course/data/models/course_model.dart';
import '../../../quiz_attempt/data/models/question_model.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '20');
  CourseModel _selectedCourse = CourseModel.mockCourses.first;
  bool _negativeMarking = true;
  final List<QuestionModel> _questions = [];

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _addQuestion(QuestionModel question) {
    setState(() {
      _questions.add(question);
    });
  }

  void _saveQuiz() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one question to the quiz.')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz created & published successfully!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty: Create Quiz'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: 'Quiz Title',
                hint: 'e.g. Final Exam: Advanced Algorithms',
                controller: _titleController,
                validator: (val) => Validators.validateRequired(val, 'Quiz Title'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CourseModel>(
                value: _selectedCourse,
                decoration: InputDecoration(
                  labelText: 'Select Course',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                items: CourseModel.mockCourses.map((course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Text('${course.code} - ${course.title}', overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCourse = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Duration (Minutes)',
                hint: '20',
                controller: _durationController,
                keyboardType: TextInputType.number,
                validator: (val) => Validators.validateRequired(val, 'Duration'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Negative Marking'),
                subtitle: const Text('Deduct 0.25 marks for incorrect answers'),
                value: _negativeMarking,
                onChanged: (val) {
                  setState(() {
                    _negativeMarking = val;
                  });
                },
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Questions List (${_questions.length})', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final newQ = await context.push<QuestionModel>('/add-question');
                      if (newQ != null) {
                        _addQuestion(newQ);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Question'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_questions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('No questions added yet. Click "Add Question" above.'),
                )
              else
                ..._questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final q = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(q.questionText, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('Options: ${q.options.length} • Correct: Option ${q.correctOptionIndex + 1}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _questions.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Publish Quiz',
                onPressed: _saveQuiz,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
