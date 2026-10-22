import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quizTimerProvider = StateNotifierProvider.family<QuizTimerController, int, int>((ref, durationMinutes) {
  return QuizTimerController(durationMinutes * 60);
});

class QuizTimerController extends StateNotifier<int> {
  Timer? _timer;

  QuizTimerController(int initialSeconds) : super(initialSeconds) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state = state - 1;
      } else {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
