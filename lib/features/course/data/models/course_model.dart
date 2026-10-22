class CourseModel {
  final String id;
  final String code;
  final String title;
  final String instructor;
  final String department;
  final int enrolledStudents;
  final double progress;

  const CourseModel({
    required this.id,
    required this.code,
    required this.title,
    required this.instructor,
    required this.department,
    required this.enrolledStudents,
    required this.progress,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      department: json['department'] as String,
      enrolledStudents: json['enrolledStudents'] as int,
      progress: (json['progress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'instructor': instructor,
      'department': department,
      'enrolledStudents': enrolledStudents,
      'progress': progress,
    };
  }

  static const List<CourseModel> mockCourses = [
    CourseModel(
      id: 'c_101',
      code: 'CSE-3101',
      title: 'Advanced Data Structures & Algorithms',
      instructor: 'Dr. Alan Turing',
      department: 'Computer Science & Engineering',
      enrolledStudents: 120,
      progress: 0.75,
    ),
    CourseModel(
      id: 'c_102',
      code: 'CSE-3102',
      title: 'Database Management Systems',
      instructor: 'Dr. Edgar Codd',
      department: 'Computer Science & Engineering',
      enrolledStudents: 98,
      progress: 0.60,
    ),
    CourseModel(
      id: 'c_103',
      code: 'SWE-3201',
      title: 'Mobile Application Development with Flutter',
      instructor: 'Prof. Dennis Ritchie',
      department: 'Software Engineering',
      enrolledStudents: 145,
      progress: 0.85,
    ),
    CourseModel(
      id: 'c_104',
      code: 'AI-4101',
      title: 'Artificial Intelligence & Neural Networks',
      instructor: 'Dr. Geoffrey Hinton',
      department: 'Data Science & Analytics',
      enrolledStudents: 110,
      progress: 0.40,
    ),
  ];
}
