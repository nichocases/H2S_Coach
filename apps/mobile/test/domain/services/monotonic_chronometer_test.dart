import 'package:flutter_test/flutter_test.dart';
import 'package:inline_hockey_coach/domain/services/monotonic_chronometer.dart';

void main() {
  test('starts at zero and does not advance while paused', () {
    final time = _FakeTimeSource();
    final chronometer = MonotonicChronometer(timeSource: time);

    expect(chronometer.elapsedMs, 0);
    time.advance(const Duration(seconds: 7));
    expect(chronometer.elapsedMs, 0);
    expect(formatChronometerMs(chronometer.elapsedMs), '00:00');
  });

  test('pauses and resumes from accumulated elapsed time', () {
    final time = _FakeTimeSource();
    final chronometer = MonotonicChronometer(timeSource: time)..start();

    time.advance(const Duration(seconds: 12, milliseconds: 500));
    expect(chronometer.pause(), 12500);

    time.advance(const Duration(seconds: 5));
    expect(chronometer.elapsedMs, 12500);

    chronometer.start();
    time.advance(const Duration(seconds: 3));
    expect(chronometer.elapsedMs, 15500);
  });

  test('restores an in-progress chronometer from persisted elapsed time', () {
    final time = _FakeTimeSource();
    final chronometer = MonotonicChronometer(
      timeSource: time,
      initialElapsedMs: 42000,
      initiallyRunning: true,
    );

    time.advance(const Duration(seconds: 8));

    expect(chronometer.chronometerMsForAction(), 50000);
    expect(formatChronometerMs(chronometer.elapsedMs), '00:50');
  });
}

class _FakeTimeSource implements MonotonicTimeSource {
  int _nowMicros = 0;

  @override
  int nowMicros() => _nowMicros;

  void advance(Duration duration) {
    _nowMicros += duration.inMicroseconds;
  }
}
