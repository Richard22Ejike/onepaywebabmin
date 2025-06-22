import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class TimerState {
  final int secondsRemaining;
  final bool isActive;

  TimerState({required this.secondsRemaining, required this.isActive});
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(TimerState(secondsRemaining: 30, isActive: false));

  Timer? _timer;

  void startTimer() {
    state = TimerState(secondsRemaining: 30, isActive: true);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        state = TimerState(secondsRemaining: state.secondsRemaining - 1, isActive: true);
      } else {
        state = TimerState(secondsRemaining: 0, isActive: false);
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
