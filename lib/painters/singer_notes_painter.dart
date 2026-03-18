import 'dart:math';
import 'package:flutter/material.dart';

/// Draws animated musical notes that rise from behind the singer's head.
///
/// This painter must be inserted BELOW the singer sprite in the Z-order so
/// the notes appear to emerge from behind the head and rise above it.
class SingerNotesPainter extends CustomPainter {
  final double time;
  final Color actColor;
  final bool singerActive;

  const SingerNotesPainter({required this.time, required this.actColor, required this.singerActive});

  // Each stream: [phaseOffset, driftSign, riseSpeed (px/s), noteType]
  //   phaseOffset : staggers the streams so they don't all spawn at once
  //   driftSign   : negative = fans left, positive = fans right
  //   riseSpeed   : pixels per second the note travels upward
  //   noteType    : 0 = quarter, 1 = eighth + flag, 2 = beamed pair
  static const _streams = <List<double>>[
    [0.00, -1.1, 26.0, 0],
    [0.17, 1.4, 21.0, 1],
    [0.34, -0.6, 30.0, 2],
    [0.50, 1.0, 19.0, 0],
    [0.67, -1.7, 17.0, 1],
    [0.83, 0.7, 27.0, 2],
  ];

  // Seconds for one full spawn-and-fade cycle per stream.
  static const _period = 3.2;

  @override
  void paint(Canvas canvas, Size size) {
    if (!singerActive) return;

    final w = size.width;
    final h = size.height;

    // Estimate the crown of the singer's head in canvas space.
    // Singer image: bottom edge at h×0.82, width = w×0.24.
    // Typical singer aspect ratio ≈ 1.38  (tall portrait figure).
    // Head crown is ~82 % of image height up from the image bottom.
    final imgH = (h * 0.24 * 1.38).clamp(0.0, h * 0.65);
    final spawnX = w / 2;
    final spawnY = h * 0.72 - imgH * 0.72; // crown of head

    for (int i = 0; i < _streams.length; i++) {
      final phase = _streams[i][0];
      final driftSign = _streams[i][1];
      final speed = _streams[i][2];
      final noteType = _streams[i][3].toInt();

      // Cycle progress [0, 1)
      final t = ((time / _period) + phase) % 1.0;

      // Rise amount in pixels
      final rise = t * speed * _period;

      // Horizontal drift fans out proportionally to rise
      final drift = driftSign * rise * 0.40 + sin(time * 1.4 + i * 1.05) * 3.5;

      final nx = spawnX + drift;
      final ny = spawnY - rise;

      // Alpha: fade in during the first 15 % of the cycle,
      //        fade out over the remaining 85 % — zero at both ends so no pop.
      final double alpha;
      if (t < 0.15) {
        alpha = (t / 0.15) * 0.82;
      } else {
        alpha = ((1.0 - t) / 0.85).clamp(0.0, 1.0) * 0.82;
      }

      if (alpha < 0.02) continue;

      _drawNote(canvas, nx, ny, noteType, actColor.withValues(alpha: alpha));
    }
  }

  void _drawNote(Canvas canvas, double x, double y, int type, Color color) {
    final fill = Paint()..color = color;
    final line =
        Paint()
          ..color = color
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    switch (type) {
      // ── Quarter note ─────────────────────────────────────────
      case 0:
        canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: 8.0, height: 6.0), fill);
        canvas.drawLine(Offset(x + 3.6, y - 0.5), Offset(x + 3.6, y - 16.0), line);

      // ── Eighth note with flag ─────────────────────────────────
      case 1:
        canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: 8.0, height: 6.0), fill);
        canvas.drawLine(Offset(x + 3.6, y - 0.5), Offset(x + 3.6, y - 16.0), line);
        // Curved flag
        canvas.drawPath(
          Path()
            ..moveTo(x + 3.6, y - 16.0)
            ..quadraticBezierTo(x + 12.0, y - 11.0, x + 9.0, y - 4.5),
          line,
        );

      // ── Beamed eighth-note pair ───────────────────────────────
      default:
        const lx = -5.5;
        const rx = 5.5;
        // Left note
        canvas.drawOval(Rect.fromCenter(center: Offset(x + lx, y), width: 8.0, height: 6.0), fill);
        canvas.drawLine(Offset(x + lx + 3.6, y - 0.5), Offset(x + lx + 3.6, y - 15.0), line);
        // Right note (slightly higher for a natural slur look)
        canvas.drawOval(Rect.fromCenter(center: Offset(x + rx, y - 2.0), width: 8.0, height: 6.0), fill);
        canvas.drawLine(Offset(x + rx + 3.6, y - 2.5), Offset(x + rx + 3.6, y - 17.0), line);
        // Beam
        canvas.drawLine(
          Offset(x + lx + 3.6, y - 15.0),
          Offset(x + rx + 3.6, y - 17.0),
          Paint()
            ..color = color
            ..strokeWidth = 2.8
            ..strokeCap = StrokeCap.square
            ..style = PaintingStyle.stroke,
        );
    }
  }

  @override
  bool shouldRepaint(SingerNotesPainter old) =>
      singerActive != old.singerActive || time != old.time || actColor != old.actColor;
}
