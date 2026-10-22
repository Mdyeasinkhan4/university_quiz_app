class QuestionModel {
  final String id;
  final String questionText;
  final String? codeSnippet;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuestionModel({
    required this.id,
    required this.questionText,
    this.codeSnippet,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      codeSnippet: json['codeSnippet'] as String?,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'codeSnippet': codeSnippet,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }

  static const List<QuestionModel> mockQuestions = [
    QuestionModel(
      id: 'q_1',
      questionText: 'What is the time complexity of searching in a balanced Binary Search Tree (BST)?',
      options: ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
      correctOptionIndex: 1,
      explanation: 'In a balanced BST, height is log n, so search operations take O(log n) time.',
    ),
    QuestionModel(
      id: 'q_2',
      questionText: 'Which widget in Flutter is best suited for building infinite lazy-loading lists with optimal performance?',
      codeSnippet: 'ListView.builder(\n  itemCount: 100,\n  itemBuilder: (context, index) => ListTile(...),\n)',
      options: ['Column', 'ListView', 'ListView.builder', 'SingleChildScrollView'],
      correctOptionIndex: 2,
      explanation: 'ListView.builder creates items on demand as they scroll into view, making it extremely memory efficient.',
    ),
    QuestionModel(
      id: 'q_3',
      questionText: 'In relational database normalization, which normal form eliminates transitive dependencies?',
      options: ['First Normal Form (1NF)', 'Second Normal Form (2NF)', 'Third Normal Form (3NF)', 'Boyce-Codd Normal Form (BCNF)'],
      correctOptionIndex: 2,
      explanation: '3NF requires that all non-key attributes are fully functional dependent only on the primary key, eliminating transitive dependencies.',
    ),
    QuestionModel(
      id: 'q_4',
      questionText: 'What does the Riverpod provider modifier `.family` allow you to do?',
      options: [
        'Cache state across app restarts',
        'Pass arguments/parameters to providers',
        'Auto-dispose when no listeners are active',
        'Run providers in background isolates'
      ],
      correctOptionIndex: 1,
      explanation: 'The .family modifier allows passing external parameters into providers when creating or reading them.',
    ),
    QuestionModel(
      id: 'q_5',
      questionText: 'Which HTTP status code signifies successful resource creation?',
      options: ['200 OK', '201 Created', '204 No Content', '400 Bad Request'],
      correctOptionIndex: 1,
      explanation: 'HTTP 201 Created indicates that the request has succeeded and led to the creation of a resource.',
    ),
  ];
}
