import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import 'stages/classic_stage.dart';
import 'stages/gothic_stage.dart';
import 'stages/steampunk_stage.dart';

class ConcertPainter extends CustomPainter {
  final double time;
  final Color actColor;
  final int bpm;
  final bool singerActive;
  final int actIndex;
  final StageTheme stageTheme;
  final bool paintBackdrop;
  final bool paintForeground;

  /// 0.0 = curtains fully closed, 1.0 = curtains fully open.
  final double curtainOpenProgress;

  ConcertPainter({
    required this.time,
    required this.actColor,
    required this.bpm,
    required this.singerActive,
    required this.actIndex,
    required this.stageTheme,
    this.paintBackdrop = true,
    this.paintForeground = true,
    this.curtainOpenProgress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final stage = _buildStage();

    if (paintBackdrop) {
      stage.paintBackdrop(canvas, w, h);
      _drawAudience(canvas, w, h);
    }

    if (paintForeground) {
      stage.paintForeground(canvas, w, h);
    }
  }

  // ── Stage dispatcher ──────────────────────────────────────────────────────

  dynamic _buildStage() {
    switch (stageTheme) {
      case StageTheme.gothic:
        return GothicStage(
          time: time,
          actColor: actColor,
          bpm: bpm,
          curtainOpenProgress: curtainOpenProgress,
        );
      case StageTheme.steampunk:
        return SteampunkStage(
          time: time,
          actColor: actColor,
          bpm: bpm,
          curtainOpenProgress: curtainOpenProgress,
        );
      case StageTheme.classic:
        return ClassicStage(
          time: time,
          actColor: actColor,
          bpm: bpm,
          curtainOpenProgress: curtainOpenProgress,
        );
    }
  }

  // ── Audience — mass crowd silhouettes (shared across all themes) ──────────

  void _drawAudience(Canvas canvas, double w, double h) {
    final beatFreq = bpm / 60.0;

    // Ambient shadow
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.82, w, h * 0.18),
      Paint()
        ..shader = ui.Gradient.linear(Offset(0, h * 0.82), Offset(0, h), [
          Colors.black.withValues(alpha: 0.0),
          Colors.black.withValues(alpha: 0.55),
        ]),
    );

    // 5 rows drawn back-to-front
    _drawMassCrowdRow(
      canvas,
      w,
      h,
      h * 0.865,
      headSize: 9.0,
      color: const Color(0xFF010000),
      bobAmp: 1.5,
      beatFreq: beatFreq,
      phaseOffset: 2.3,
    );
    _drawMassCrowdRow(
      canvas,
      w,
      h,
      h * 0.895,
      headSize: 13.0,
      color: const Color(0xFF020000),
      bobAmp: 2.5,
      beatFreq: beatFreq,
      phaseOffset: 1.7,
    );
    _drawMassCrowdRow(
      canvas,
      w,
      h,
      h * 0.928,
      headSize: 17.0,
      color: const Color(0xFF040101),
      bobAmp: 3.5,
      beatFreq: beatFreq,
      phaseOffset: 1.0,
    );
    _drawMassCrowdRow(
      canvas,
      w,
      h,
      h * 0.963,
      headSize: 22.0,
      color: const Color(0xFF060101),
      bobAmp: 5.0,
      beatFreq: beatFreq,
      phaseOffset: 0.4,
    );
    _drawMassCrowdRow(
      canvas,
      w,
      h,
      h * 1.005,
      headSize: 28.0,
      color: const Color(0xFF0A0202),
      bobAmp: 7.5,
      beatFreq: beatFreq,
      phaseOffset: 0.0,
    );

    _drawCrowdLights(canvas, w, h);
  }

  void _drawMassCrowdRow(
    Canvas canvas,
    double w,
    double screenH,
    double baseY, {
    required double headSize,
    required Color color,
    required double bobAmp,
    required double beatFreq,
    required double phaseOffset,
  }) {
    final spacing = headSize * 1.38;
    final count = (w / spacing).ceil() + 2;
    final bottomY = screenH + 20.0;

    final path =
        Path()
          ..moveTo(-spacing, bottomY)
          ..lineTo(-spacing, baseY);

    for (int i = 0; i < count; i++) {
      final x = i * spacing - spacing * 0.3;
      final bob = sin(time * beatFreq * pi + i * 0.88 + phaseOffset) * bobAmp;
      final shoulderY = baseY - bob * 0.22;
      final headTopY = baseY - headSize - bob - headSize * 0.18;

      path.lineTo(x - spacing * 0.40, shoulderY);
      path.quadraticBezierTo(x, headTopY, x + spacing * 0.40, shoulderY);
    }

    path
      ..lineTo(w + spacing, baseY)
      ..lineTo(w + spacing, bottomY)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawCrowdLights(Canvas canvas, double w, double h) {
    final rng = Random(42);
    const count = 32;
    for (int i = 0; i < count; i++) {
      final lx = rng.nextDouble() * w;
      final ly = h * 0.875 + rng.nextDouble() * h * 0.11;
      final flicker =
          sin(time * (1.8 + rng.nextDouble() * 4.5) + i * 1.73) * 0.5 + 0.5;
      final alpha = (0.22 + flicker * 0.60).clamp(0.0, 1.0);
      final isPhone = i % 3 != 0;
      final lightColor =
          isPhone
              ? Color.fromRGBO(190, 212, 255, alpha)
              : Color.fromRGBO(255, 218, 85, alpha);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(lx, ly), width: 5.0, height: 3.5),
        Paint()
          ..color = lightColor
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  @override
  bool shouldRepaint(ConcertPainter old) => true;
}
