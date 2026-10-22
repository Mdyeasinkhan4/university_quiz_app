import 'dart:async';

class MockClient {
  static Future<T> simulateNetworkCall<T>({
    required T Function() onSuccess,
    int delayMs = 800,
    bool shouldFail = false,
  }) async {
    await Future.delayed(Duration(milliseconds: delayMs));
    if (shouldFail) {
      throw Exception('Simulated network error');
    }
    return onSuccess();
  }
}
