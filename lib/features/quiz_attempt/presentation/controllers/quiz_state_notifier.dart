import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/attempt_model.dart';

class QuizState {
  final QuizModel quiz;
  final int currentIndex;
  final Map<int, int> selectedAnswers;
  final Set<int> flaggedQuestions;
  final bool isSubmitted;
  final AttemptModel? attemptResult;

  const QuizState({
    required this.quiz,
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.flaggedQuestions = const {},
    this.isSubmitted = false,
    this.attemptResult,
  });

  QuizState copyWith({
    QuizModel? quiz,
    int? currentIndex,
    Map<int, int>? selectedAnswers,
    Set<int>? flaggedQuestions,
    bool? isSubmitted,
    AttemptModel? attemptResult,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      flaggedQuestions: flaggedQuestions ?? this.flaggedQuestions,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      attemptResult: attemptResult ?? this.attemptResult,
    );
  }
}

final quizStateNotifierProvider = StateNotifierProvider.family<QuizStateNotifier, QuizState, QuizModel>((ref, quiz) {
  return QuizStateNotifier(quiz);
});

class QuizStateNotifier extends StateNotifier<QuizState> {
  QuizStateNotifier(QuizModel quiz) : super(QuizState(quiz: quiz));

  void selectOption(int questionIndex, int optionIndex) {
    final updatedAnswers = Map<int, int>.from(state.selectedAnswers);
    updatedAnswers[questionIndex] = optionIndex;
    state = state.copyWith(selectedAnswers: updatedAnswers);
  }

  void toggleFlag(int questionIndex) {
    final updatedFlags = Set<int>.from(state.flaggedQuestions);
    if (updatedFlags.contains(questionIndex)) {
      updatedFlags.remove(questionIndex);
    } else {
      updatedFlags.add(questionIndex);
    }
    state = state.copyWith(flaggedQuestions: updatedFlags);
  }

  void nextQuestion() {
    if (state.currentIndex < state.quiz.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < state.quiz.questions.length) {
      state = state.copyWith(currentIndex: index);
    }
  }

  AttemptModel submitQuiz({required Duration timeTaken, required String studentId}) {
    int correctCount = 0;
    state.selectedAnswers.forEach((qIndex, selectedOpt) {
      if (state.quiz.questions[qIndex].correctOptionIndex == selectedOpt) {
        correctCount++;
      }
    });

    final attempt = AttemptModel(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      quizId: state.quiz.id,
      studentId: studentId,
      selectedAnswers: state.selectedAnswers,
      flaggedQuestions: state.flaggedQuestions,
      score: correctCount,
      totalQuestions: state.quiz.questions.length,
      timeTaken: timeTaken,
      submittedAt: DateTime.now(),
    );

    state = state.copyWith(isSubmitted: true, attemptResult: attempt);
    return attempt;
  }
}
