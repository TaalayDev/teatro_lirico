import 'dart:ui';

// ─── Game State ───────────────────────────────────────────────
enum GameState { menu, playing, intermission, finale }

// ─── Stage Theme ──────────────────────────────────────────────
enum StageTheme { classic, gothic, steampunk }

// ─── Score Tracking ───────────────────────────────────────────
class HitStats {
  int perfect = 0;
  int good = 0;
  int miss = 0;

  void reset() {
    perfect = 0;
    good = 0;
    miss = 0;
  }
}

// ─── Game Note (scrolling note on the rhythm lane) ────────────
class GameNote {
  final double time; // seconds from start
  final double endTime;
  final double duration;
  final int lane; // 0-3
  final String noteName;
  double y = -100;

  bool hit = false;
  bool missed = false;
  bool releasedEarly = false;
  bool completedScoreGiven = false;

  GameNote({
    required this.time,
    required this.endTime,
    required this.duration,
    required this.lane,
    required this.noteName,
  });
}

// ─── Melody Event ─────────────────────────────────────────────
class MelodyEvent {
  final String time; // "measure:beat" format
  final String note;
  final String dur;

  const MelodyEvent(this.time, this.note, this.dur);
}

// ─── Chord Event ──────────────────────────────────────────────
class ChordEvent {
  final String time;
  final List<String> notes;
  final String dur;

  const ChordEvent(this.time, this.notes, this.dur);
}

// ─── Brass Event ──────────────────────────────────────────────
class BrassEvent {
  final String time;
  final List<String> notes;
  final String dur;

  const BrassEvent(this.time, this.notes, this.dur);
}

// ─── Track / Act ──────────────────────────────────────────────
class Track {
  final String name;
  final int bpm;
  final Color color;
  final StageTheme theme;
  final List<MelodyEvent> melody;
  final List<ChordEvent> chords;
  final List<BrassEvent> brass;
  final List<String> timpani;

  /// How many times the 4-measure pattern repeats (default 4 = ~60–100 s).
  /// Increase for harder/longer acts.
  final int loops;

  const Track({
    required this.name,
    required this.bpm,
    required this.color,
    this.theme = StageTheme.classic,
    required this.melody,
    required this.chords,
    required this.brass,
    required this.timpani,
    this.loops = 4,
  });
}

// ─── Visual Particle ──────────────────────────────────────────
class Particle {
  double x, y;
  double vx, vy;
  double life;
  double size;
  final Color color;

  Particle({required this.x, required this.y, required this.color, required double speed, required this.size})
    : vx = (0.5 - _nextRandom()) * speed,
      vy = (0.5 - _nextRandom()) * speed,
      life = 1.0;

  static int _seed = 42;
  static double _nextRandom() {
    _seed = (_seed * 1103515245 + 12345) & 0x7FFFFFFF;
    return _seed / 0x7FFFFFFF;
  }

  void update() {
    x += vx;
    y += vy;
    life -= 0.05;
  }
}

// ─── Feedback Text (PERFECT / GOOD / MISS) ────────────────────
class FeedbackText {
  final String text;
  double x, y;
  final Color color;
  double life;

  FeedbackText({required this.text, required this.x, required this.y, required this.color}) : life = 1.0;

  void update() {
    y -= 1;
    life -= 0.02;
  }
}
