import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.studentId,
    required super.department,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      studentId: json['studentId'] as String,
      department: json['department'] as String,
      role: json['role'] == 'faculty' ? UserRole.faculty : UserRole.student,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
      'department': department,
      'role': role == UserRole.faculty ? 'faculty' : 'student',
    };
  }

  static const UserModel mockStudent = UserModel(
    id: 'u_001',
    name: 'Alex Johnson',
    email: 'alex.student@university.edu',
    studentId: 'CSE-2023-045',
    department: 'Computer Science & Engineering',
    role: UserRole.student,
  );

  static const UserModel mockFaculty = UserModel(
    id: 'u_002',
    name: 'Dr. Alan Turing',
    email: 'alan.turing@university.edu',
    studentId: 'FAC-CSE-01',
    department: 'Computer Science & Engineering',
    role: UserRole.faculty,
  );
}
