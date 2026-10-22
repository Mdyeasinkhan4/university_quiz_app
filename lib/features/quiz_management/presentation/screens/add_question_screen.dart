import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../quiz_attempt/data/models/question_model.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _codeController = TextEditingController();
  final _opt1Controller = TextEditingController();
  final _opt2Controller = TextEditingController();
  final _opt3Controller = TextEditingController();
  final _opt4Controller = TextEditingController();
  final _explanationController = TextEditingController();
  int _correctOptionIndex = 0;

  @override
  void dispose() {
    _questionController.dispose();
    _codeController.dispose();
    _opt1Controller.dispose();
    _opt2Controller.dispose();
    _opt3Controller.dispose();
    _opt4Controller.dispose();
    _explanationController.dispose();
    super.dispose();
  }

  void _saveQuestion() {
    if (_formKey.currentState?.validate() ?? false) {
      final question = QuestionModel(
        id: 'q_${DateTime.now().millisecondsSinceEpoch}',
        questionText: _questionController.text.trim(),
        codeSnippet: _codeController.text.trim().isEmpty ? null : _codeController.text.trim(),
        options: [
          _opt1Controller.text.trim(),
          _opt2Controller.text.trim(),
          _opt3Controller.text.trim(),
          _opt4Controller.text.trim(),
        ],
        correctOptionIndex: _correctOptionIndex,
        explanation: _explanationController.text.trim(),
      );
      context.pop(question);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: 'Question Text',
                hint: 'Enter your question statement',
                controller: _questionController,
                maxLines: 3,
                validator: (val) => Validators.validateRequired(val, 'Question'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Code Snippet (Optional)',
                hint: 'e.g. void main() { ... }',
                controller: _codeController,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              Text('Options (Select Correct Answer below)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _optionInput(0, 'Option A', _opt1Controller),
              const SizedBox(height: 12),
              _optionInput(1, 'Option B', _opt2Controller),
              const SizedBox(height: 12),
              _optionInput(2, 'Option C', _opt3Controller),
              const SizedBox(height: 12),
              _optionInput(3, 'Option D', _opt4Controller),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Explanation',
                hint: 'Why is the correct answer right?',
                controller: _explanationController,
                maxLines: 2,
                validator: (val) => Validators.validateRequired(val, 'Explanation'),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Question',
                onPressed: _saveQuestion,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionInput(int index, String label, TextEditingController controller) {
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: _correctOptionIndex,
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _correctOptionIndex = val;
              });
            }
          },
        ),
        Expanded(
          child: CustomTextField(
            label: label,
            controller: controller,
            validator: (val) => Validators.validateRequired(val, label),
          ),
        ),
      ],
    );
  }
}
