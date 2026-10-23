import '../../../../core/database/database_helper.dart';
import '../../../../core/network/mock_client.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repository_interfaces/auth_repository.dart';
import 'models/user_model.dart';

class MockAuthRepository implements AuthRepository {
  UserEntity? _cachedUser;

  @override
  Future<UserEntity> login(String email, String password, UserRole role) async {
    return MockClient.simulateNetworkCall(
      onSuccess: () async {
        // Query local sqflite database
        var user = await DatabaseHelper.instance.getUserByEmail(email);
        if (user == null) {
          // Fallback to default mock if not found in db
          user = role == UserRole.faculty ? UserModel.mockFaculty : UserModel.mockStudent;
          await DatabaseHelper.instance.insertUser(user);
        }
        _cachedUser = user;
        return user;
      },
      delayMs: 600,
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
      onSuccess: () async {
        final user = UserModel(
          id: 'u_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          email: email,
          studentId: studentId,
          department: department,
          role: role,
        );
        // Save to local sqflite database
        await DatabaseHelper.instance.insertUser(user);
        _cachedUser = user;
        return user;
      },
      delayMs: 600,
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
