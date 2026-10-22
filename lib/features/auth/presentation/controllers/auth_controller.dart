import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository_interfaces/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserEntity?>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password, UserRole role) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.login(email, password, role);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String studentId,
    required String department,
    required UserRole role,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        studentId: studentId,
        department: department,
        role: role,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
