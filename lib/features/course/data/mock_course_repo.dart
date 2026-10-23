import '../../../../core/database/database_helper.dart';
import '../../../../core/network/mock_client.dart';
import 'models/course_model.dart';

class MockCourseRepository {
  Future<List<CourseModel>> getCourses() async {
    return MockClient.simulateNetworkCall(
      onSuccess: () async {
        return await DatabaseHelper.instance.getCourses();
      },
      delayMs: 500,
    );
  }

  Future<CourseModel> getCourseById(String id) async {
    return MockClient.simulateNetworkCall(
      onSuccess: () async {
        final course = await DatabaseHelper.instance.getCourseById(id);
        return course ?? CourseModel.mockCourses.first;
      },
      delayMs: 300,
    );
  }
}
