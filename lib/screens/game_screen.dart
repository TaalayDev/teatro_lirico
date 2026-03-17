import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../audio/audio_engine.dart';
import '../models/game_models.dart';
import '../models/track_data.dart';
import '../painters/concert_painter.dart';
import '../painters/rhythm_painter.dart';

/// Lane ↔ key mapping (same order as the web version).
final _keyToLane = {
  LogicalKeyboardKey.arrowLeft: 0,
  LogicalKeyboardKey.arrowDown: 1,
  LogicalKeyboardKey.arrowUp: 2,
  LogicalKeyboardKey.arrowRight: 3,
};

const _scrollSpeed = 500.0; // px / sec
const _singerSpriteLinger = 0.5; // seconds

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  // ── Audio ────────────────────────────────────────────────
  final AudioEngine _audio = AudioEngine();

  // ── Game state ───────────────────────────────────────────
  GameState _state = GameState.menu;
  int _currentAct = 0;
  int _score = 0;
  int _combo = 0;
  final HitStats _hits = HitStats();

  List<GameNote> _notes = [];
  final List<Particle> _particles = [];
  final List<FeedbackText> _feedbacks = [];
  final Set<int> _pressedLanes = {};

  double _trackDuration = 0; // seconds
  bool _singerActive = false;
  double _singerHoldUntil = 0;
  bool _showPostActContinue = false;
  Timer? _postActTimer;

  // ── Timing ──────────────────────────────────────────────
  final Stopwatch _stopwatch = Stopwatch();
  double get _elapsed => _stopwatch.elapsedMilliseconds / 1000.0;

  // ── Curtain animation ────────────────────────────────────
  static const _curtainDuration = 2.8; // seconds to fully open
  final Stopwatch _curtainWatch = Stopwatch();
  double get _curtainProgress =>
      (_curtainWatch.elapsedMilliseconds / 1000.0 / _curtainDuration).clamp(
        0.0,
        1.0,
      );

  // ── Animation ───────────────────────────────────────────
  late final Ticker _ticker;

  // ── Focus for keyboard ──────────────────────────────────
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _postActTimer?.cancel();
    _ticker.dispose();
    _focusNode.dispose();
    _audio.dispose();
    super.dispose();
  }

  // ─── TICK (every frame) ─────────────────────────────────
  void _onTick(Duration _) {
    if (_state != GameState.playing) return;
    final t = _elapsed;

    // Check act end
    if (t >= _trackDuration + 2) {
      _endAct();
      return;
    }

    // Update note misses
    bool vocal = false;
    for (final n in _notes) {
      if (!n.hit && !n.missed && t > n.time + 0.2) {
        n.missed = true;
        _hits.miss++;
        _combo = 0;
        _addFeedback(n.lane, 'MISS', Colors.red);
      }
      // Active held note → vocal
      if (n.hit && !n.releasedEarly && t >= n.time && t <= n.endTime) {
        if (n.duration < 0.3 || _pressedLanes.contains(n.lane)) {
          vocal = true;
        }
      }
      // Long-note completion bonus
      if (n.hit &&
          !n.releasedEarly &&
          t >= n.endTime &&
          !n.completedScoreGiven) {
        n.completedScoreGiven = true;
        if (n.duration >= 0.3) {
          _score += 50;
          _spawnParticles(n.lane);
        }
      }
    }

    if (vocal) {
      _singerHoldUntil = t + _singerSpriteLinger;
    }
    _singerActive = vocal || t < _singerHoldUntil;

    // Update particles & feedbacks
    _particles
      ..forEach((p) => p.update())
      ..removeWhere((p) => p.life <= 0);
    _feedbacks
      ..forEach((f) => f.update())
      ..removeWhere((f) => f.life <= 0);

    setState(() {}); // repaint
  }

  // ─── START AN ACT ───────────────────────────────────────
  Future<void> _startAct(int actIndex) async {
    await _audio.initialize();
    _postActTimer?.cancel();
    _showPostActContinue = false;
    await _audio.stopClapping();
    _currentAct = actIndex;

    _particles.clear();
    _feedbacks.clear();
    _pressedLanes.clear();
    _combo = 0;
    _singerActive = false;
    _singerHoldUntil = 0;
    _stopwatch
      ..stop()
      ..reset();
    _curtainWatch
      ..stop()
      ..reset();

    final result = await _audio.scheduleAct(tracks[actIndex]);
    _notes = result.notes;
    _trackDuration = result.trackEndTime;

    // Curtain animation starts before playback so the opening is visible
    // from the first frame. Stopwatch must NOT start until audio actually
    // begins — otherwise elapsed time races ahead during the async gap and
    // notes at t=0 are already "in the past" when the first tick fires.
    _curtainWatch.start();

    setState(() => _state = GameState.playing);
    _focusNode.requestFocus();

    await _audio.startPlayback();
    _stopwatch.start(); // start exactly when audio begins
  }

  void _endAct() {
    _stopwatch.stop();
    _curtainWatch.stop();
    _audio.pausePlayback();

    _postActTimer?.cancel();
    _showPostActContinue = false;
    _audio.playClapping();
    _singerActive = false;
    _singerHoldUntil = 0;

    if (_currentAct < tracks.length - 1) {
      setState(() => _state = GameState.intermission);
    } else {
      setState(() => _state = GameState.finale);
    }

    _postActTimer = Timer(const Duration(seconds: 12), () async {
      if (!mounted) return;
      await _audio.stopClapping();
      if (!mounted) return;
      setState(() => _showPostActContinue = true);
    });
  }

  // ─── INPUT: KEY DOWN ────────────────────────────────────
  void _onKeyDown(int lane) {
    if (_state != GameState.playing) return;
    _pressedLanes.add(lane);

    final t = _elapsed;
    const hitWindow = 0.2;

    GameNote? target;
    for (final n in _notes) {
      if (n.lane == lane && !n.hit && !n.missed) {
        if ((n.time - t).abs() <= hitWindow) {
          target = n;
          break;
        }
      }
    }

    _spawnTapParticle(lane);

    if (target != null) {
      target.hit = true;
      final diff = (target.time - t).abs();

      if (diff < 0.08) {
        _score += 100 + (_combo * 10);
        _hits.perfect++;
        _combo++;
        _addFeedback(lane, 'PERFECT', _laneColor(lane));
      } else {
        _score += 50;
        _hits.good++;
        _combo++;
        _addFeedback(lane, 'GOOD', Colors.white);
      }
      _spawnParticles(lane);

      _audio.triggerVocal(
        target.noteName,
        Duration(milliseconds: (target.duration * 1000).toInt()),
      );
    } else {
      _combo = 0;
      _addFeedback(lane, 'MISS', Colors.red);
      _audio.playMiss();
    }
  }

  // ─── INPUT: KEY UP ──────────────────────────────────────
  void _onKeyUp(int lane) {
    _pressedLanes.remove(lane);
    if (_state != GameState.playing) return;
    final t = _elapsed;

    for (final n in _notes) {
      if (n.lane == lane &&
          n.hit &&
          !n.releasedEarly &&
          !n.completedScoreGiven) {
        if (n.duration >= 0.3 && t < n.endTime - 0.1) {
          n.releasedEarly = true;
          _combo = 0;
          _hits.miss++;
          _addFeedback(lane, 'MISS', Colors.red);
        }
      }
    }
  }

  // ─── HELPERS ────────────────────────────────────────────
  Color _laneColor(int lane) {
    const c = [
      Color(0xFFC1121F),
      Color(0xFFFDF5A9),
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
    ];
    return c[lane.clamp(0, 3)];
  }

  void _addFeedback(int lane, String text, Color color) {
    // Position will be calculated by the painter relative to its own size
    _feedbacks.add(
      FeedbackText(
        text: text,
        x: 0, // placeholder – set in build from layout
        y: 0,
        color: color,
      ),
    );
    // We set x/y in build based on actual rhythm panel width
    final fb = _feedbacks.last;
    // Defer actual position to paint time using lane fraction
    fb.x = lane.toDouble(); // store lane index; painter resolves position
    fb.y = -50; // offset from hitZone
  }

  void _spawnParticles(int lane) {
    for (int i = 0; i < 12; i++) {
      _particles.add(
        Particle(
          x: lane.toDouble(), // store lane; painter resolves
          y: 0,
          color: _laneColor(lane),
          speed: 8,
          size: 4,
        ),
      );
    }
  }

  void _spawnTapParticle(int lane) {
    _particles.add(
      Particle(
        x: lane.toDouble(),
        y: 0,
        color: Colors.white,
        speed: 4,
        size: 8,
      ),
    );
  }

  String _currentSingerAsset() {
    final singerNumber = (_currentAct % 3) + 1;
    final stateSuffix = switch (_state) {
      GameState.intermission || GameState.finale => 'bow',
      GameState.playing when _singerActive => 'sing',
      _ => '',
    };

    if (stateSuffix.isEmpty) {
      return 'assets/singer_$singerNumber.png';
    }
    return 'assets/singer_${stateSuffix}_$singerNumber.png';
  }

  Widget _buildSingerSprite(double width, double height) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: height * 0.18),
          child: Image.asset(
            _currentSingerAsset(),
            width: width * 0.24,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }

  // ─── BUILD ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ── Game canvas ───────────────────────────────
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final concertW = w * 0.7;
                final rhythmW = w * 0.3;
                final hitZoneY = h * 0.85;

                // Resolve particle / feedback positions now that we know dimensions
                _resolvePositions(rhythmW, hitZoneY);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left: Concert
                    SizedBox(
                      width: concertW,
                      height: h,
                      child: ClipRect(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CustomPaint(
                              painter: ConcertPainter(
                                time: _elapsed,
                                actColor:
                                    _state == GameState.playing
                                        ? tracks[_currentAct].color
                                        : const Color(0xFFC1121F),
                                bpm:
                                    _state == GameState.playing
                                        ? tracks[_currentAct].bpm
                                        : 70,
                                singerActive: _singerActive,
                                actIndex: _currentAct,
                                stageTheme:
                                    _state == GameState.playing
                                        ? tracks[_currentAct].theme
                                        : StageTheme.classic,
                                paintForeground: false,
                                curtainOpenProgress:
                                    _state == GameState.playing
                                        ? _curtainProgress
                                        : 1.0,
                              ),
                            ),
                            _buildSingerSprite(concertW, h),
                            CustomPaint(
                              painter: ConcertPainter(
                                time: _elapsed,
                                actColor:
                                    _state == GameState.playing
                                        ? tracks[_currentAct].color
                                        : const Color(0xFFC1121F),
                                bpm:
                                    _state == GameState.playing
                                        ? tracks[_currentAct].bpm
                                        : 70,
                                singerActive: _singerActive,
                                actIndex: _currentAct,
                                stageTheme:
                                    _state == GameState.playing
                                        ? tracks[_currentAct].theme
                                        : StageTheme.classic,
                                paintBackdrop: false,
                                curtainOpenProgress:
                                    _state == GameState.playing
                                        ? _curtainProgress
                                        : 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Gold divider
                    Container(width: 3, color: const Color(0xFFB89947)),
                    // Right: Rhythm game
                    Expanded(
                      child: ClipRect(
                        child: CustomPaint(
                          painter: RhythmPainter(
                            time: _elapsed,
                            hitZoneY: hitZoneY,
                            scrollSpeed: _scrollSpeed,
                            notes: _notes,
                            particles: _particles,
                            feedbacks: _feedbacks,
                            pressedLanes: _pressedLanes,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // ── HUD ───────────────────────────────────────
            if (_state == GameState.playing) _buildHUD(),

            // ── Combo pop ─────────────────────────────────
            if (_state == GameState.playing && _combo >= 5)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.45,
                right: MediaQuery.of(context).size.width * 0.35,
                child: Text(
                  'COMBO $_combo',
                  style: const TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFDF5A9),
                    shadows: [Shadow(color: Color(0xFFB89947), blurRadius: 20)],
                  ),
                ),
              ),

            // ── MENUS ─────────────────────────────────────
            if (_state == GameState.menu) _buildMainMenu(),
            if (_state == GameState.intermission) _buildIntermission(),
            if (_state == GameState.finale) _buildFinale(),
          ],
        ),
      ),
    );
  }

  void _resolvePositions(double rhythmW, double hitZoneY) {
    for (final f in _feedbacks) {
      // x currently holds lane index as double
      if (f.x < 4) {
        final lane = f.x.round();
        f.x = _laneXFraction(lane) * rhythmW;
        f.y = hitZoneY + f.y; // y held relative offset
      }
    }
    for (final p in _particles) {
      if (p.x < 4) {
        final lane = p.x.round();
        p.x = _laneXFraction(lane) * rhythmW;
        p.y = hitZoneY;
      }
    }
  }

  double _laneXFraction(int lane) {
    const fracs = [0.15, 0.40, 0.60, 0.85];
    return fracs[lane.clamp(0, 3)];
  }

  String _actLabel(int index) {
    const labels = [
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
      'IX',
      'X',
      'XI',
      'XII',
      'XIII',
      'XIV',
      'XV',
      'XVI',
    ];
    return labels[index.clamp(0, labels.length - 1)];
  }

  void _handleKeyEvent(KeyEvent event) {
    final lane = _keyToLane[event.logicalKey];
    if (lane == null) return;

    if (event is KeyDownEvent) {
      _onKeyDown(lane);
    } else if (event is KeyUpEvent) {
      _onKeyUp(lane);
    }
  }

  // ─── UI WIDGETS ─────────────────────────────────────────

  Widget _buildHUD() {
    final actName = tracks[_currentAct].name;
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.62),
          border: Border.all(
            color: const Color(0xFFB89947).withValues(alpha: 0.7),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ACT ${_actLabel(_currentAct)}',
                  style: const TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 11,
                    letterSpacing: 3,
                    color: Color(0xFFB89947),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 10,
                  color: const Color(0xFFB89947).withValues(alpha: 0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  actName,
                  style: const TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 11,
                    letterSpacing: 1,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFFDF5A9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _hudStat('✦', _score.toString(), const Color(0xFFFDF5A9)),
                const SizedBox(width: 14),
                _hudStat(
                  '◎',
                  _hits.perfect.toString(),
                  const Color(0xFF90EE90),
                ),
                const SizedBox(width: 14),
                _hudStat('✕', _hits.miss.toString(), const Color(0xFFFF6B6B)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _hudStat(String icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(fontSize: 10, color: color)),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
      ],
    );
  }

  Widget _buildMainMenu() {
    final difficulties = [
      'Facile',
      'Moderato',
      'Medio',
      'Arduo',
      'Difficile',
      'Maestro',
      'Estremo',
      'Incubo',
      'Divino',
      'Celestiale',
      'Imperiale',
      'Leggendario',
      'Apocalittico',
    ];
    final diffColors = [
      const Color(0xFF90EE90),
      const Color(0xFF7EC8E3),
      const Color(0xFFFDF5A9),
      const Color(0xFFFFB347),
      const Color(0xFFFF6B6B),
      const Color(0xFFE040FB),
      const Color(0xFFFF3333),
      const Color(0xFFFF44FF),
      const Color(0xFFFFFFFF),
      const Color(0xFFBDE0FE),
      const Color(0xFFFFD166),
      const Color(0xFFA7F3D0),
      const Color(0xFFFFA69E),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.92),
            const Color(0xFF1A0000).withValues(alpha: 0.96),
          ],
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Left panel: title + controls ──────────────────────
            SizedBox(
              width: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ornamental top rule
                  _ornamentDivider(),
                  const SizedBox(height: 18),
                  const Text(
                    'TEATRO',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 12,
                      color: Color(0xFFFDF5A9),
                      shadows: [
                        Shadow(color: Color(0xFFB89947), blurRadius: 18),
                        Shadow(color: Color(0xFFB89947), blurRadius: 40),
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'LIRICO',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 16,
                      color: Color(0xFFB89947),
                      shadows: [
                        Shadow(color: Color(0xFFC1121F), blurRadius: 20),
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '— A Symphonic Rhythm Experience —',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      letterSpacing: 1.5,
                      color: Color(0xFFB89947),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ornamentDivider(),
                  const SizedBox(height: 28),
                  // Controls box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      border: Border.all(
                        color: const Color(0xFFB89947).withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'THE ORCHESTRA AWAITS',
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 12,
                            letterSpacing: 3,
                            color: Color(0xFFB89947),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Press ARROW KEYS in time with the notes.\nHOLD for sustained phrases.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFAAAAAA),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _keyChip('◄', const Color(0xFFC1121F)),
                            const SizedBox(width: 10),
                            _keyChip('▼', const Color(0xFFFDF5A9)),
                            const SizedBox(width: 10),
                            _keyChip('▲', const Color(0xFF4CAF50)),
                            const SizedBox(width: 10),
                            _keyChip('►', const Color(0xFF2196F3)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 48),

            // ── Right panel: act list ──────────────────────────────
            SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SELECT YOUR ACT',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 12,
                      letterSpacing: 4,
                      color: Color(0xFFB89947),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(tracks.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _actListItem(
                        label: 'ACT ${_actLabel(i)}',
                        title: tracks[i].name,
                        bpm: tracks[i].bpm,
                        difficulty:
                            difficulties[i.clamp(0, difficulties.length - 1)],
                        diffColor:
                            diffColors[i.clamp(0, diffColors.length - 1)],
                        actColor: tracks[i].color,
                        theme: tracks[i].theme,
                        onTap: () => _startAct(i),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actListItem({
    required String label,
    required String title,
    required int bpm,
    required String difficulty,
    required Color diffColor,
    required Color actColor,
    required StageTheme theme,
    required VoidCallback onTap,
  }) {
    final themeLabel = switch (theme) {
      StageTheme.classic => '🎭 Classic',
      StageTheme.gothic => '🗡 Gothic',
      StageTheme.steampunk => '⚙ Steampunk',
    };
    final themeColor = switch (theme) {
      StageTheme.classic => const Color(0xFFB89947),
      StageTheme.gothic => const Color(0xFF9080C0),
      StageTheme.steampunk => const Color(0xFFB87030),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            border: Border(
              left: BorderSide(color: actColor, width: 3),
              top: BorderSide(
                color: const Color(0xFFB89947).withValues(alpha: 0.25),
                width: 1,
              ),
              bottom: BorderSide(
                color: const Color(0xFFB89947).withValues(alpha: 0.25),
                width: 1,
              ),
              right: BorderSide(
                color: const Color(0xFFB89947).withValues(alpha: 0.25),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Act number badge
              Container(
                width: 38,
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 10,
                    letterSpacing: 1,
                    color: actColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: const Color(0xFFB89947).withValues(alpha: 0.3),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFFDF5A9),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          themeLabel,
                          style: TextStyle(fontSize: 10, color: themeColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$bpm BPM',
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(
                              0xFFB89947,
                            ).withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: diffColor.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Text(
                  difficulty,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 10,
                    letterSpacing: 1,
                    color: diffColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntermission() {
    final nextAct = _currentAct + 1;
    final total = _hits.perfect + _hits.good + _hits.miss;
    final accuracy =
        total > 0 ? ((_hits.perfect + _hits.good) / total * 100).round() : 0;
    final stars =
        accuracy >= 95
            ? 3
            : accuracy >= 70
            ? 2
            : 1;

    return Container(
      decoration:
          _showPostActContinue
              ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0D0000).withValues(alpha: 0.97),
                    Colors.black.withValues(alpha: 0.97),
                  ],
                ),
              )
              : null,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Applause header
            const Text(
              'BRAVO!',
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 64,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: Color(0xFFFDF5A9),
                shadows: [
                  Shadow(color: Color(0xFFB89947), blurRadius: 24),
                  Shadow(color: Color(0xFFB89947), blurRadius: 50),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'ACT ${_actLabel(_currentAct)}  ·  ${tracks[_currentAct].name}',
              style: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 16,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
                color: Color(0xFFB89947),
              ),
            ),
            const SizedBox(height: 20),
            // Stars
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    i < stars ? '★' : '☆',
                    style: TextStyle(
                      fontSize: 36,
                      color:
                          i < stars
                              ? const Color(0xFFFFD700)
                              : const Color(0xFF555544),
                      shadows:
                          i < stars
                              ? const [
                                Shadow(
                                  color: Color(0xFFFFD700),
                                  blurRadius: 12,
                                ),
                              ]
                              : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Score card
            Container(
              width: 380,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                border: Border.all(
                  color: const Color(0xFFB89947).withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _scoreRow(
                    'SCORE',
                    _score.toString(),
                    const Color(0xFFFDF5A9),
                    large: true,
                  ),
                  const Divider(color: Color(0x44B89947), height: 20),
                  _scoreRow(
                    'PERFECT',
                    _hits.perfect.toString(),
                    const Color(0xFF90EE90),
                  ),
                  const SizedBox(height: 8),
                  _scoreRow(
                    'GOOD',
                    _hits.good.toString(),
                    const Color(0xFFFDF5A9),
                  ),
                  const SizedBox(height: 8),
                  _scoreRow(
                    'MISS',
                    _hits.miss.toString(),
                    const Color(0xFFFF6B6B),
                  ),
                  const Divider(color: Color(0x44B89947), height: 20),
                  _scoreRow('ACCURACY', '$accuracy%', const Color(0xFFB89947)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Next act preview
            if (nextAct < tracks.length) ...[
              Text(
                'NEXT  ·  ACT ${_actLabel(nextAct)}  ·  ${tracks[nextAct].name}',
                style: const TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 12,
                  letterSpacing: 2,
                  color: Color(0xFF888866),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_showPostActContinue)
              _goldButton(
                'PROCEED TO ACT ${_actLabel(nextAct)}',
                () => _startAct(nextAct),
              )
            else
              const Text(
                'The applause swells through the hall...',
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 12,
                  letterSpacing: 2,
                  color: Color(0xFFB89947),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinale() {
    final total = _hits.perfect + _hits.good + _hits.miss;
    final accuracy =
        total > 0 ? ((_hits.perfect + _hits.good) / total * 100).round() : 0;
    final stars =
        accuracy >= 95
            ? 3
            : accuracy >= 70
            ? 2
            : 1;
    final rank =
        accuracy >= 95
            ? 'VIRTUOSO'
            : accuracy >= 70
            ? 'MAESTRO'
            : 'ARTISTA';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0000), Color(0xFF000000)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ornamentDivider(),
            const SizedBox(height: 20),
            const Text(
              'STANDING OVATION',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 44,
                fontWeight: FontWeight.w900,
                letterSpacing: 6,
                color: Color(0xFFFDF5A9),
                shadows: [
                  Shadow(color: Color(0xFFB89947), blurRadius: 22),
                  Shadow(color: Color(0xFFB89947), blurRadius: 50),
                  Shadow(
                    color: Colors.black,
                    offset: Offset(2, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Il Sipario Cade  ·  The Curtain Falls',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                letterSpacing: 2,
                color: Color(0xFFB89947),
              ),
            ),
            const SizedBox(height: 20),
            // Stars row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    i < stars ? '★' : '☆',
                    style: TextStyle(
                      fontSize: 40,
                      color:
                          i < stars
                              ? const Color(0xFFFFD700)
                              : const Color(0xFF444433),
                      shadows:
                          i < stars
                              ? const [
                                Shadow(
                                  color: Color(0xFFFFD700),
                                  blurRadius: 14,
                                ),
                                Shadow(
                                  color: Color(0xFFFFD700),
                                  blurRadius: 30,
                                ),
                              ]
                              : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              rank,
              style: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 18,
                letterSpacing: 6,
                color: Color(0xFFB89947),
              ),
            ),
            const SizedBox(height: 24),
            // Final score card
            Container(
              width: 420,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                border: Border.all(color: const Color(0xFFB89947), width: 1),
                boxShadow: const [
                  BoxShadow(color: Color(0x44B89947), blurRadius: 30),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'FINAL SCORE',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 11,
                      letterSpacing: 4,
                      color: Color(0xFFB89947),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _score.toString(),
                    style: const TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFDF5A9),
                      shadows: [
                        Shadow(color: Color(0xFFB89947), blurRadius: 16),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0x44B89947), height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _finaleStat(
                        'PERFECT',
                        _hits.perfect.toString(),
                        const Color(0xFF90EE90),
                      ),
                      _finaleStat(
                        'GOOD',
                        _hits.good.toString(),
                        const Color(0xFFFDF5A9),
                      ),
                      _finaleStat(
                        'MISS',
                        _hits.miss.toString(),
                        const Color(0xFFFF6B6B),
                      ),
                      _finaleStat(
                        'ACCURACY',
                        '$accuracy%',
                        const Color(0xFFB89947),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            if (_showPostActContinue)
              _goldButton('ENCORE  ·  PLAY AGAIN', () {
                _score = 0;
                _hits.reset();
                _startAct(0);
              })
            else
              const Text(
                'The applause swells through the hall...',
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 12,
                  letterSpacing: 2,
                  color: Color(0xFFB89947),
                ),
              ),
            const SizedBox(height: 20),
            _ornamentDivider(),
          ],
        ),
      ),
    );
  }

  Widget _finaleStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            color: Color(0xFF888877),
          ),
        ),
      ],
    );
  }

  // ─── Reusable styled widgets ────────────────────────────

  Widget _keyChip(String char, Color color) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8),
        ],
      ),
      child: Text(char, style: TextStyle(fontSize: 20, color: color)),
    );
  }

  Widget _scoreRow(
    String label,
    String value,
    Color color, {
    bool large = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: large ? 13 : 11,
            letterSpacing: 2,
            color: const Color(0xFF888877),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: large ? 28 : 18,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: [
              Shadow(color: color.withValues(alpha: 0.5), blurRadius: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ornamentDivider() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 60, height: 1, color: const Color(0xFFB89947)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '✦',
            style: TextStyle(fontSize: 14, color: Color(0xFFB89947)),
          ),
        ),
        Container(width: 60, height: 1, color: const Color(0xFFB89947)),
      ],
    );
  }

  Widget _goldButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB89947),
        foregroundColor: const Color(0xFF1A0000),
        padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        elevation: 10,
        shadowColor: const Color(0xFFB89947),
      ),
      child: Text(label),
    );
  }
}
