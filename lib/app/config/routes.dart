import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/course/data/models/course_model.dart';
import '../../features/course/presentation/screens/course_details_screen.dart';
import '../../features/course/presentation/screens/enrolled_courses_screen.dart';
import '../../features/dashboard/presentation/screens/student_dashboard.dart';
import '../../features/dashboard/presentation/screens/teacher_dashboard.dart';
import '../../features/quiz_attempt/data/models/attempt_model.dart';
import '../../features/quiz_attempt/data/models/quiz_model.dart';
import '../../features/quiz_attempt/presentation/screens/active_quiz_screen.dart';
import '../../features/quiz_attempt/presentation/screens/quiz_lobby_screen.dart';
import '../../features/quiz_attempt/presentation/screens/quiz_result_screen.dart';
import '../../features/quiz_management/presentation/screens/add_question_screen.dart';
import '../../features/quiz_management/presentation/screens/create_quiz_screen.dart';
import '../../features/quiz_management/presentation/screens/student_results_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.hasValue && authState.value != null;
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) {
        final user = authState.value!;
        return user.isFaculty ? '/teacher-dashboard' : '/student-dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/student-dashboard',
        builder: (context, state) => const StudentDashboard(),
      ),
      GoRoute(
        path: '/teacher-dashboard',
        builder: (context, state) => const TeacherDashboard(),
      ),
      GoRoute(
        path: '/enrolled-courses',
        builder: (context, state) => const EnrolledCoursesScreen(),
      ),
      GoRoute(
        path: '/course-details',
        builder: (context, state) {
          final course = state.extra as CourseModel;
          return CourseDetailsScreen(course: course);
        },
      ),
      GoRoute(
        path: '/quiz-lobby',
        builder: (context, state) => const QuizLobbyScreen(),
      ),
      GoRoute(
        path: '/active-quiz',
        builder: (context, state) {
          final quiz = state.extra as QuizModel;
          return ActiveQuizScreen(quiz: quiz);
        },
      ),
      GoRoute(
        path: '/quiz-result',
        builder: (context, state) {
          final attempt = state.extra as AttemptModel;
          return QuizResultScreen(attempt: attempt);
        },
      ),
      GoRoute(
        path: '/create-quiz',
        builder: (context, state) => const CreateQuizScreen(),
      ),
      GoRoute(
        path: '/add-question',
        builder: (context, state) => const AddQuestionScreen(),
      ),
      GoRoute(
        path: '/student-results',
        builder: (context, state) => const StudentResultsScreen(),
      ),
    ],
  );
});
