import '../../../../core/network/mock_client.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repository_interfaces/auth_repository.dart';
import 'models/user_model.dart';

class MockAuthRepository implements AuthRepository {
  UserEntity? _cachedUser;

  @override
  Future<UserEntity> login(String email, String password, UserRole role) async {
    return MockClient.simulateNetworkCall(
      onSuccess: () {
        final user = role == UserRole.faculty ? UserModel.mockFaculty : UserModel.mockStudent;
        _cachedUser = user;
        return user;
      },
    );
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String studentId,
    required String department,
    required UserRole role,
  }) async {
    return MockClient.simulateNetworkCall(
      onSuccess: () {
        final user = UserModel(
          id: 'u_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          email: email,
          studentId: studentId,
          department: department,
          role: role,
        );
        _cachedUser = user;
        return user;
      },
    );
  }

  @override
  Future<void> logout() async {
    return MockClient.simulateNetworkCall(
      onSuccess: () {
        _cachedUser = null;
      },
      delayMs: 300,
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _cachedUser;
  }
}
