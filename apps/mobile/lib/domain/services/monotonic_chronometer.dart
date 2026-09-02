// The one-method boundary keeps stopwatch time injectable for deterministic
// pause/resume/restore tests without exposing wall-clock time to the domain.
// ignore: one_member_abstracts
abstract class MonotonicTimeSource {
  int nowMicros();
}

class StopwatchMonotonicTimeSource implements MonotonicTimeSource {
  StopwatchMonotonicTimeSource() : _stopwatch = Stopwatch()..start();

  final Stopwatch _stopwatch;

  @override
  int nowMicros() => _stopwatch.elapsedMicroseconds;
}

class MonotonicChronometer {
  MonotonicChronometer({
    required MonotonicTimeSource timeSource,
    int initialElapsedMs = 0,
    bool initiallyRunning = false,
  }) : _timeSource = timeSource,
       _accumulatedMs = initialElapsedMs {
    if (initiallyRunning) {
      _runningSinceMicros = _timeSource.nowMicros();
    }
  }

  final MonotonicTimeSource _timeSource;
  int _accumulatedMs;
  int? _runningSinceMicros;

  bool get isRunning => _runningSinceMicros != null;

  int get elapsedMs {
    final runningSince = _runningSinceMicros;
    if (runningSince == null) {
      return _accumulatedMs;
    }
    final deltaMicros = _timeSource.nowMicros() - runningSince;
    return _accumulatedMs +
        (deltaMicros ~/ Duration.microsecondsPerMillisecond);
  }

  void start() {
    if (isRunning) {
      return;
    }
    _runningSinceMicros = _timeSource.nowMicros();
  }

  int pause() {
    if (!isRunning) {
      return _accumulatedMs;
    }
    _accumulatedMs = elapsedMs;
    _runningSinceMicros = null;
    return _accumulatedMs;
  }

  int chronometerMsForAction() => elapsedMs;
}

String formatChronometerMs(int elapsedMs) {
  final totalSeconds = elapsedMs ~/ Duration.millisecondsPerSecond;
  final minutes = (totalSeconds ~/ Duration.secondsPerMinute)
      .toString()
      .padLeft(
        2,
        '0',
      );
  final seconds = (totalSeconds % Duration.secondsPerMinute).toString().padLeft(
    2,
    '0',
  );
  return '$minutes:$seconds';
}
