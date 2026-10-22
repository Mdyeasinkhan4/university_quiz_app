import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password, UserRole role);
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String studentId,
    required String department,
    required UserRole role,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
