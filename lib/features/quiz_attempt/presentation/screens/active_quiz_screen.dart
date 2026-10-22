import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/quiz_model.dart';
import '../controllers/quiz_state_notifier.dart';
import '../controllers/quiz_timer_controller.dart';
import '../widgets/option_selector.dart';
import '../widgets/question_card.dart';
import '../widgets/submit_dialog.dart';
import '../widgets/timer_widget.dart';

class ActiveQuizScreen extends ConsumerStatefulWidget {
  final QuizModel quiz;

  const ActiveQuizScreen({super.key, required this.quiz});

  @override
  ConsumerState<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
}

class _ActiveQuizScreenState extends ConsumerState<ActiveQuizScreen> with WidgetsBindingObserver {
  bool _isBlurred = false;
  int _blurIncidentCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      setState(() {
        _isBlurred = true;
        _blurIncidentCount++;
      });
      _showAntiCheatWarning();
    }
  }

  void _showAntiCheatWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚠️ Anti-Cheat Warning: App minimization/blur detected! Incident #$_blurIncidentCount'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _submitQuiz(WidgetRef ref) {
    ref.read(quizTimerProvider(widget.quiz.durationMinutes).notifier).stopTimer();
    final quizNotifier = ref.read(quizStateNotifierProvider(widget.quiz).notifier);
    final attempt = quizNotifier.submitQuiz(
      timeTaken: Duration(minutes: widget.quiz.durationMinutes) - 
          Duration(seconds: ref.read(quizTimerProvider(widget.quiz.durationMinutes))),
      studentId: 'CSE-2023-045',
    );
    context.go('/quiz-result', extra: attempt);
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizStateNotifierProvider(widget.quiz));
    final quizNotifier = ref.read(quizStateNotifierProvider(widget.quiz).notifier);
    final theme = Theme.of(context);
    final currentQ = quizState.quiz.questions[quizState.currentIndex];

    return WillPopScope(
      onWillPop: () async => false, // Prevent accidental back button press during exam
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(widget.quiz.courseCode),
              actions: [
                Center(
                  child: TimerWidget(
                    durationMinutes: widget.quiz.durationMinutes,
                    onTimeExpired: () => _submitQuiz(ref),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: (quizState.currentIndex + 1) / quizState.quiz.questions.length,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          QuestionCard(
                            question: currentQ,
                            questionNumber: quizState.currentIndex + 1,
                            totalQuestions: quizState.quiz.questions.length,
                            isFlagged: quizState.flaggedQuestions.contains(quizState.currentIndex),
                            onToggleFlag: () => quizNotifier.toggleFlag(quizState.currentIndex),
                          ),
                          const SizedBox(height: 24),
                          OptionSelector(
                            options: currentQ.options,
                            selectedIndex: quizState.selectedAnswers[quizState.currentIndex],
                            onSelected: (optionIndex) {
                              quizNotifier.selectOption(quizState.currentIndex, optionIndex);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom Navigation Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: quizState.currentIndex > 0 ? quizNotifier.previousQuestion : null,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Previous'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.grid_view_rounded),
                          onPressed: () => _showQuestionGridSheet(context, quizState, quizNotifier),
                          tooltip: 'Question Palette',
                        ),
                        if (quizState.currentIndex < quizState.quiz.questions.length - 1)
                          FilledButton.icon(
                            onPressed: quizNotifier.nextQuestion,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('Next'),
                          )
                        else
                          FilledButton.icon(
                            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
                            onPressed: () => _showSubmitDialog(context, quizState),
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Submit'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isBlurred)
            Container(
              color: Colors.black54,
              child: Center(
                child: AlertDialog(
                  title: const Text('⚠️ Warning: Exam Focus Lost'),
                  content: Text('You navigated away from the exam screen ($_blurIncidentCount incident(s)). Please return immediately.'),
                  actions: [
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _isBlurred = false;
                        });
                      },
                      child: const Text('Resume Exam'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSubmitDialog(BuildContext context, QuizState quizState) {
    showDialog(
      context: context,
      builder: (ctx) => SubmitDialog(
        answeredCount: quizState.selectedAnswers.length,
        totalCount: quizState.quiz.questions.length,
        flaggedCount: quizState.flaggedQuestions.length,
        onSubmitConfirmed: () => _submitQuiz(ref),
      ),
    );
  }

  void _showQuestionGridSheet(BuildContext context, QuizState quizState, QuizStateNotifier quizNotifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question Palette', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: quizState.quiz.questions.length,
                itemBuilder: (context, index) {
                  final isAnswered = quizState.selectedAnswers.containsKey(index);
                  final isFlagged = quizState.flaggedQuestions.contains(index);
                  final isCurrent = quizState.currentIndex == index;

                  Color bgColor = Theme.of(context).colorScheme.surfaceContainerHighest;
                  if (isAnswered) bgColor = Theme.of(context).colorScheme.primaryContainer;
                  if (isFlagged) bgColor = Colors.orange.shade200;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      quizNotifier.jumpToQuestion(index);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent ? Theme.of(context).colorScheme.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isAnswered ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
