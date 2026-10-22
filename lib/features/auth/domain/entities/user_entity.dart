enum UserRole { student, faculty }

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final String department;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.department,
    required this.role,
  });

  bool get isFaculty => role == UserRole.faculty;
  bool get isStudent => role == UserRole.student;
}
