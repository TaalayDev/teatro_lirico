import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Act 0 — La Soprano: grand ballgown, elaborate updo, gold jewelry.
class SopranoPainter {
  final double time;
  final Color actColor;
  final bool singerActive;

  const SopranoPainter({required this.time, required this.actColor, required this.singerActive});

  void draw(Canvas canvas, double w, double h) {
    final sx = w / 2;
    final sy = h * 0.58;
    final breath = sin(time * 2.8) * 3;
    final shimmer = sin(time * 3.5) * 0.5 + 0.5;

    _drawSpotlight(canvas, w, h, sx);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, h * 0.724), width: 120, height: 22),
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
        ..color = const Color(0xBB000000),
    );

    _drawDress(canvas, sx, sy, breath, shimmer);
    _drawArms(canvas, sx, sy, breath);

    canvas.drawRect(
      Rect.fromCenter(center: Offset(sx, sy - 30 + breath), width: 11, height: 17),
      Paint()..color = const Color(0xFFE8C49A),
    );

    _drawHead(canvas, sx, sy, breath);
    _drawJewelry(canvas, sx, sy, breath, shimmer);

    if (singerActive) _drawMusicNotes(canvas, sx, sy);

    if (singerActive) {
      final haloAlpha = (sin(time * 6) * 0.30 + 0.55).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(sx, sy - 47 + breath),
        30 + sin(time * 8) * 5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = actColor.withValues(alpha: haloAlpha * 0.75)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
      canvas.drawCircle(
        Offset(sx, sy - 47 + breath),
        52 + sin(time * 5 + 1.5) * 9,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = actColor.withValues(alpha: haloAlpha * 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
      );
    }
  }

  void _drawSpotlight(Canvas canvas, double w, double h, double sx) {
    canvas.drawPath(
      Path()
        ..moveTo(sx - 6, 0)
        ..lineTo(sx + 6, 0)
        ..lineTo(sx + 88, h * 0.78)
        ..lineTo(sx - 88, h * 0.78)
        ..close(),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(sx, 0),
          Offset(sx, h * 0.78),
          [const Color(0x32FFF0CC), const Color(0x12FFF0CC), const Color(0x00FFF0CC)],
          [0.0, 0.55, 1.0],
        ),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, h * 0.724), width: 190, height: 44),
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30)
        ..color = const Color(0x2BFFE8A0),
    );
  }

  void _drawDress(Canvas canvas, double sx, double sy, double breath, double shimmer) {
    final outerSkirt =
        Path()
          ..moveTo(sx - 18, sy - 20 + breath)
          ..quadraticBezierTo(sx - 92, sy + 72, sx - 108, sy + 214)
          ..lineTo(sx + 108, sy + 214)
          ..quadraticBezierTo(sx + 92, sy + 72, sx + 18, sy - 20 + breath)
          ..close();
    canvas.drawPath(outerSkirt, Paint()..color = actColor.withValues(alpha: 0.62));

    final mainSkirt =
        Path()
          ..moveTo(sx - 16, sy - 20 + breath)
          ..quadraticBezierTo(sx - 78, sy + 82, sx - 98, sy + 210)
          ..lineTo(sx + 98, sy + 210)
          ..quadraticBezierTo(sx + 78, sy + 82, sx + 16, sy - 20 + breath)
          ..close();
    canvas.drawPath(mainSkirt, Paint()..color = actColor);

    canvas.drawPath(
      mainSkirt,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(sx - 88, sy),
          Offset(sx + 48, sy + 185),
          [
            Colors.white.withValues(alpha: 0.21 + shimmer * 0.11),
            Colors.white.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          [0.0, 0.42, 1.0],
        ),
    );

    for (int r = 0; r < 3; r++) {
      final ry = sy + 152.0 + r * 20.0;
      final spread = 96.0 - r * 5.0;
      final ruffPath = Path()..moveTo(sx - spread, ry);
      const segs = 6;
      for (int s = 0; s < segs; s++) {
        final x1 = sx - spread + spread * 2 * (s + 0.5) / segs;
        final x2 = sx - spread + spread * 2 * (s + 1) / segs;
        final peakY = ry - 10 + (s.isEven ? -4.0 : 4.0) + sin(time * 1.4 + s + r) * 2;
        ruffPath.quadraticBezierTo(x1, peakY, x2, ry);
      }
      ruffPath
        ..lineTo(sx + spread, sy + 212)
        ..lineTo(sx - spread, sy + 212)
        ..close();
      canvas.drawPath(ruffPath, Paint()..color = Colors.white.withValues(alpha: (0.10 - r * 0.025) + shimmer * 0.05));
    }

    canvas.drawPath(
      mainSkirt,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = actColor.withValues(alpha: 0.52),
    );

    final bodPath =
        Path()
          ..moveTo(sx - 16, sy - 20 + breath)
          ..quadraticBezierTo(sx - 27, sy + 28, sx - 21, sy + 54)
          ..lineTo(sx + 21, sy + 54)
          ..quadraticBezierTo(sx + 27, sy + 28, sx + 16, sy - 20 + breath)
          ..close();
    canvas.drawPath(
      bodPath,
      Paint()
        ..shader = ui.Gradient.linear(Offset(sx - 16, sy - 20), Offset(sx + 16, sy + 54), [
          actColor,
          actColor.withValues(alpha: 0.52),
        ]),
    );

    final seamPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = actColor.withValues(alpha: 0.36);
    canvas.drawLine(Offset(sx, sy - 18 + breath), Offset(sx, sy + 53), seamPaint);
    canvas.drawLine(Offset(sx - 9, sy - 10 + breath), Offset(sx - 7, sy + 53), seamPaint);
    canvas.drawLine(Offset(sx + 9, sy - 10 + breath), Offset(sx + 7, sy + 53), seamPaint);
  }

  void _drawArms(Canvas canvas, double sx, double sy, double breath) {
    final skinPaint =
        Paint()
          ..color = const Color(0xFFE8C49A)
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final glovePaint =
        Paint()
          ..color = actColor.withValues(alpha: 0.80)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    if (singerActive) {
      final lEnd = Offset(sx - 74, sy - 94 + breath);
      final rEnd = Offset(sx + 74, sy - 94 + breath);

      canvas.drawPath(
        Path()
          ..moveTo(sx - 18, sy - 12 + breath)
          ..quadraticBezierTo(sx - 58, sy - 50 + breath * 0.5, lEnd.dx, lEnd.dy),
        skinPaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx + 18, sy - 12 + breath)
          ..quadraticBezierTo(sx + 58, sy - 50 + breath * 0.5, rEnd.dx, rEnd.dy),
        skinPaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx - 48, sy - 40 + breath * 0.7)
          ..quadraticBezierTo(sx - 62, sy - 65 + breath * 0.3, lEnd.dx, lEnd.dy),
        glovePaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx + 48, sy - 40 + breath * 0.7)
          ..quadraticBezierTo(sx + 62, sy - 65 + breath * 0.3, rEnd.dx, rEnd.dy),
        glovePaint,
      );
      final handPaint = Paint()..color = const Color(0xFFE8C49A);
      canvas.drawCircle(lEnd, 5.5, handPaint);
      canvas.drawCircle(rEnd, 5.5, handPaint);
    } else {
      final lEnd = Offset(sx - 32, sy + 54 + breath * 0.3);
      final rEnd = Offset(sx + 32, sy + 54 + breath * 0.3);

      canvas.drawPath(
        Path()
          ..moveTo(sx - 18, sy - 12 + breath)
          ..quadraticBezierTo(sx - 40, sy + 20, lEnd.dx, lEnd.dy),
        skinPaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx + 18, sy - 12 + breath)
          ..quadraticBezierTo(sx + 40, sy + 20, rEnd.dx, rEnd.dy),
        skinPaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx - 38, sy + 26)
          ..quadraticBezierTo(sx - 40, sy + 42, lEnd.dx, lEnd.dy),
        glovePaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx + 38, sy + 26)
          ..quadraticBezierTo(sx + 40, sy + 42, rEnd.dx, rEnd.dy),
        glovePaint,
      );
    }
  }

  void _drawHead(Canvas canvas, double sx, double sy, double breath) {
    final headCY = sy - 47 + breath;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, headCY), width: 36, height: 42),
      Paint()..color = const Color(0xFFF0C58A),
    );

    for (final side in [-1, 1]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sx + side * 12.0, headCY + 5), width: 13, height: 8),
        Paint()
          ..color = const Color(0x28E87070)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }

    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, headCY - 14), width: 38, height: 20),
      Paint()..color = const Color(0xFF1A0805),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx - 16, headCY - 2), width: 12, height: 30),
      Paint()..color = const Color(0xFF1A0805),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx + 16, headCY - 2), width: 12, height: 30),
      Paint()..color = const Color(0xFF1A0805),
    );
    canvas.drawCircle(Offset(sx, headCY - 28), 9, Paint()..color = const Color(0xFF1A0805));
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx - 4, headCY - 16), width: 18, height: 12),
      -0.7,
      1.0,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = const Color(0x28884422),
    );
    canvas.drawCircle(
      Offset(sx + 5, headCY - 33),
      4.0,
      Paint()
        ..color = const Color(0xFFEDD97A)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(
      Offset(sx - 4, headCY - 36),
      2.5,
      Paint()
        ..color = const Color(0xFFFFFFCC)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    final browPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF2A0808);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx - 8, headCY - 9), width: 12, height: 6),
      pi + 0.2,
      pi - 0.4,
      false,
      browPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx + 8, headCY - 9), width: 12, height: 6),
      pi + 0.2,
      pi - 0.4,
      false,
      browPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx - 8, headCY - 2), width: 7, height: 5),
      Paint()..color = const Color(0xFF1A0805),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx + 8, headCY - 2), width: 7, height: 5),
      Paint()..color = const Color(0xFF1A0805),
    );
    canvas.drawCircle(Offset(sx - 7, headCY - 3), 1.0, Paint()..color = const Color(0x88FFFFFF));
    canvas.drawCircle(Offset(sx + 9, headCY - 3), 1.0, Paint()..color = const Color(0x88FFFFFF));

    if (singerActive) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sx, headCY + 11), width: 11, height: 15),
        Paint()..color = const Color(0xFF220000),
      );
      canvas.drawRect(
        Rect.fromCenter(center: Offset(sx, headCY + 9), width: 8, height: 3),
        Paint()..color = const Color(0xFFF5F0E8),
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sx, headCY + 7), width: 9, height: 4),
        Paint()..color = const Color(0x2AFF6060),
      );
    } else {
      canvas.drawPath(
        Path()
          ..moveTo(sx - 7, headCY + 9)
          ..quadraticBezierTo(sx, headCY + 14, sx + 7, headCY + 9),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF8B3A3A),
      );
    }
  }

  void _drawJewelry(Canvas canvas, double sx, double sy, double breath, double shimmer) {
    final headCY = sy - 47 + breath;
    final neckY = headCY + 21;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx, neckY - 1), width: 24, height: 16),
      0.15,
      pi - 0.30,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..color = const Color(0xFFEDD97A).withValues(alpha: 0.72 + shimmer * 0.28),
    );
    canvas.drawCircle(
      Offset(sx, neckY + 7),
      3.5,
      Paint()
        ..color = const Color(0xFFEDD97A)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 + shimmer * 2.0),
    );

    for (final side in [-1, 1]) {
      final ex = sx + side * 18.0;
      canvas.drawCircle(
        Offset(ex, headCY + 6),
        3.5,
        Paint()
          ..color = const Color(0xFFEDD97A)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.0 + shimmer * 2.0),
      );
      canvas.drawLine(
        Offset(ex, headCY + 9.5),
        Offset(ex, headCY + 17),
        Paint()
          ..color = const Color(0xFFB89947).withValues(alpha: 0.75)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawMusicNotes(Canvas canvas, double sx, double sy) {
    const noteConfigs = [
      [52.0, 1.3, 30.0, 0.0],
      [-58.0, 1.1, 25.0, 20.0],
      [65.0, 0.9, 35.0, 10.0],
    ];
    for (int i = 0; i < noteConfigs.length; i++) {
      final baseX = sx + noteConfigs[i][0];
      final wobbleFreq = noteConfigs[i][1];
      final riseSpeed = noteConfigs[i][2];
      final phase = noteConfigs[i][3];
      final nx = baseX + sin(time * wobbleFreq + i * 1.1) * 8;
      final rawY = (time * riseSpeed + phase) % 80;
      final ny = sy - 28 - rawY;
      if (ny < sy - 115 || ny > sy - 18) continue;
      final alpha = ((sy - 18 - ny) / 97.0).clamp(0.0, 1.0) * 0.90;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(nx, ny), width: 7, height: 5.5),
        Paint()..color = actColor.withValues(alpha: alpha),
      );
      canvas.drawLine(
        Offset(nx + 3.2, ny - 0.5),
        Offset(nx + 3.2, ny - 13),
        Paint()
          ..color = actColor.withValues(alpha: alpha)
          ..strokeWidth = 1.5,
      );
      if (i.isEven) {
        canvas.drawPath(
          Path()
            ..moveTo(nx + 3.2, ny - 13)
            ..quadraticBezierTo(nx + 10, ny - 9, nx + 7, ny - 4),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = actColor.withValues(alpha: alpha),
        );
      }
    }
  }
}
