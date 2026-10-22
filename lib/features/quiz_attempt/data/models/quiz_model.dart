import 'question_model.dart';

class QuizModel {
  final String id;
  final String title;
  final String courseCode;
  final String courseTitle;
  final int durationMinutes;
  final bool negativeMarking;
  final List<QuestionModel> questions;
  final DateTime deadline;

  const QuizModel({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.courseTitle,
    required this.durationMinutes,
    required this.negativeMarking,
    required this.questions,
    required this.deadline,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      title: json['title'] as String,
      courseCode: json['courseCode'] as String,
      courseTitle: json['courseTitle'] as String,
      durationMinutes: json['durationMinutes'] as int,
      negativeMarking: json['negativeMarking'] as bool,
      questions: (json['questions'] as List)
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
      deadline: DateTime.parse(json['deadline'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'durationMinutes': durationMinutes,
      'negativeMarking': negativeMarking,
      'questions': questions.map((q) => q.toJson()).toList(),
      'deadline': deadline.toIso8601String(),
    };
  }

  static QuizModel mockQuiz = QuizModel(
    id: 'quiz_001',
    title: 'Midterm Examination: Data Structures & Algorithms',
    courseCode: 'CSE-3101',
    courseTitle: 'Advanced Data Structures & Algorithms',
    durationMinutes: 15,
    negativeMarking: true,
    questions: QuestionModel.mockQuestions,
    deadline: DateTime.now().add(const Duration(hours: 4)),
  );
}
