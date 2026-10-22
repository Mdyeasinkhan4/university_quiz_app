import '../../../../core/network/mock_client.dart';
import 'models/course_model.dart';

class MockCourseRepository {
  Future<List<CourseModel>> getCourses() async {
    return MockClient.simulateNetworkCall(
      onSuccess: () => CourseModel.mockCourses,
      delayMs: 600,
    );
  }

  Future<CourseModel> getCourseById(String id) async {
    return MockClient.simulateNetworkCall(
      onSuccess: () {
        return CourseModel.mockCourses.firstWhere(
          (c) => c.id == id,
          orElse: () => CourseModel.mockCourses.first,
        );
      },
      delayMs: 400,
    );
  }
}
