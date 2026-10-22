class AttemptModel {
  final String id;
  final String quizId;
  final String studentId;
  final Map<int, int> selectedAnswers; // questionIndex -> optionIndex
  final Set<int> flaggedQuestions;
  final int score;
  final int totalQuestions;
  final Duration timeTaken;
  final DateTime submittedAt;

  const AttemptModel({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.selectedAnswers,
    required this.flaggedQuestions,
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
    required this.submittedAt,
  });

  double get percentage => (score / totalQuestions) * 100;
  bool get isPassed => percentage >= 50.0;
}
