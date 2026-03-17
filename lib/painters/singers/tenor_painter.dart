import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Act 2 — Il Tenore: black tailcoat tuxedo, heroic arm pose, short dark hair.
class TenorPainter {
  final double time;
  final Color actColor;
  final bool singerActive;

  const TenorPainter({
    required this.time,
    required this.actColor,
    required this.singerActive,
  });

  static const _skin = Color(0xFFE0B882);
  static const _jacketDark = Color(0xFF0A0808);
  static const _shirtWhite = Color(0xFFF5F0E8);

  void draw(Canvas canvas, double w, double h) {
    final sx = w / 2;
    final sy = h * 0.56; // slightly taller figure
    final breath = sin(time * 2.6) * 2;
    final shimmer = sin(time * 3.2) * 0.5 + 0.5;

    _drawSpotlight(canvas, w, h, sx, actColor);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, h * 0.724), width: 90, height: 16),
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..color = const Color(0x99000000),
    );

    _drawTuxedo(canvas, sx, sy, breath, shimmer);
    _drawArms(canvas, sx, sy, breath);

    // Neck (collar)
    canvas.drawRect(
      Rect.fromCenter(center: Offset(sx, sy - 38 + breath), width: 13, height: 16),
      Paint()..color = _skin,
    );
    // White shirt collar
    canvas.drawRect(
      Rect.fromCenter(center: Offset(sx - 6, sy - 40 + breath), width: 7, height: 12),
      Paint()..color = _shirtWhite,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(sx + 6, sy - 40 + breath), width: 7, height: 12),
      Paint()..color = _shirtWhite,
    );

    _drawHead(canvas, sx, sy, breath);
    _drawMusicNotes(canvas, sx, sy);
    _drawHalo(canvas, sx, sy, breath);
  }

  void _drawSpotlight(Canvas canvas, double w, double h, double sx, Color color) {
    canvas.drawPath(
      Path()
        ..moveTo(sx - 5, 0)
        ..lineTo(sx + 5, 0)
        ..lineTo(sx + 70, h * 0.78)
        ..lineTo(sx - 70, h * 0.78)
        ..close(),
      Paint()
        ..shader = ui.Gradient.linear(Offset(sx, 0), Offset(sx, h * 0.78), [
          const Color(0x28FFF8EE),
          const Color(0x0CFFF8EE),
          const Color(0x00FFF8EE),
        ], [0.0, 0.5, 1.0]),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, h * 0.724), width: 155, height: 36),
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 26)
        ..color = const Color(0x22FFE8C0),
    );
  }

  void _drawTuxedo(Canvas canvas, double sx, double sy, double breath, double shimmer) {
    // Trousers (behind jacket)
    for (final side in [-1, 1]) {
      final lx = sx + side * (side < 0 ? -28.0 : 4.0);
      canvas.drawRect(
        Rect.fromLTWH(lx, sy + 58, 24, 155),
        Paint()..color = const Color(0xFF0C0909),
      );
      // Satin trouser stripe
      canvas.drawLine(
        Offset(lx + (side < 0 ? 8.0 : 16.0), sy + 58),
        Offset(lx + (side < 0 ? 8.0 : 16.0), sy + 213),
        Paint()..color = const Color(0x38B0A080)..strokeWidth = 1.5,
      );
    }

    // Jacket tails (long back panels visible below waist)
    for (final side in [-1, 1]) {
      canvas.drawRect(
        Rect.fromLTWH(sx + side * (side < 0 ? -30.0 : 22.0), sy + 60, 8, 65),
        Paint()..color = _jacketDark.withValues(alpha: 0.85),
      );
    }

    // Main jacket body
    final lJacket = Path()
      ..moveTo(sx - 6, sy - 22 + breath)
      ..lineTo(sx - 34, sy - 14 + breath)
      ..lineTo(sx - 30, sy + 62)
      ..lineTo(sx - 8, sy + 62)
      ..close();
    canvas.drawPath(lJacket, Paint()..color = _jacketDark);

    final rJacket = Path()
      ..moveTo(sx + 6, sy - 22 + breath)
      ..lineTo(sx + 34, sy - 14 + breath)
      ..lineTo(sx + 30, sy + 62)
      ..lineTo(sx + 8, sy + 62)
      ..close();
    canvas.drawPath(rJacket, Paint()..color = _jacketDark);

    // Shoulder mass (broad — wider than female characters)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, sy - 12 + breath), width: 76, height: 22),
      Paint()..color = _jacketDark,
    );

    // Jacket sheen on shoulders
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx - 8, sy - 14 + breath), width: 30, height: 10),
      Paint()..color = Colors.white.withValues(alpha: 0.06 + shimmer * 0.04),
    );

    // White shirt front
    canvas.drawRect(
      Rect.fromLTWH(sx - 9, sy - 20 + breath, 18, 75),
      Paint()..color = _shirtWhite,
    );
    // Shirt pleating lines
    for (int p = 0; p < 3; p++) {
      canvas.drawLine(
        Offset(sx - 4 + p * 4.0, sy - 14 + breath),
        Offset(sx - 4 + p * 4.0, sy + 40 + breath),
        Paint()..color = const Color(0x18888888)..strokeWidth = 0.8,
      );
    }
    // Shirt studs
    for (int b = 0; b < 4; b++) {
      canvas.drawCircle(
        Offset(sx, sy - 10 + b * 10.0 + breath),
        1.5,
        Paint()..color = const Color(0xFF888888),
      );
    }

    // Lapels (silk-faced)
    final lLapel = Path()
      ..moveTo(sx - 8, sy - 20 + breath)
      ..lineTo(sx - 34, sy - 14 + breath)
      ..lineTo(sx - 20, sy + 12 + breath)
      ..lineTo(sx - 8, sy - 2 + breath)
      ..close();
    canvas.drawPath(lLapel,
        Paint()..color = const Color(0xFF151010));
    canvas.drawPath(lLapel,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = Colors.white.withValues(alpha: 0.08));

    final rLapel = Path()
      ..moveTo(sx + 8, sy - 20 + breath)
      ..lineTo(sx + 34, sy - 14 + breath)
      ..lineTo(sx + 20, sy + 12 + breath)
      ..lineTo(sx + 8, sy - 2 + breath)
      ..close();
    canvas.drawPath(rLapel, Paint()..color = const Color(0xFF151010));
    canvas.drawPath(rLapel,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = Colors.white.withValues(alpha: 0.08));

    // Bow tie — actColor accent
    final lBow = Path()
      ..moveTo(sx - 1, sy - 18 + breath)
      ..lineTo(sx - 10, sy - 24 + breath)
      ..lineTo(sx - 10, sy - 12 + breath)
      ..close();
    canvas.drawPath(lBow, Paint()..color = actColor.withValues(alpha: 0.92));
    final rBow = Path()
      ..moveTo(sx + 1, sy - 18 + breath)
      ..lineTo(sx + 10, sy - 24 + breath)
      ..lineTo(sx + 10, sy - 12 + breath)
      ..close();
    canvas.drawPath(rBow, Paint()..color = actColor.withValues(alpha: 0.92));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, sy - 18 + breath), width: 7, height: 5),
      Paint()..color = actColor,
    );

    // Pocket square (white)
    canvas.drawPath(
      Path()
        ..moveTo(sx + 22, sy - 10 + breath)
        ..lineTo(sx + 29, sy - 16 + breath)
        ..lineTo(sx + 32, sy - 8 + breath)
        ..lineTo(sx + 22, sy - 5 + breath)
        ..close(),
      Paint()..color = _shirtWhite.withValues(alpha: 0.75),
    );

    // Jacket edge highlight
    for (final side in [-1, 1]) {
      canvas.drawLine(
        Offset(sx + side * 30, sy - 14 + breath),
        Offset(sx + side * 30, sy + 62),
        Paint()..color = Colors.white.withValues(alpha: 0.06)..strokeWidth = 1.5,
      );
    }
  }

  void _drawArms(Canvas canvas, double sx, double sy, double breath) {
    final sleevePaint = Paint()
      ..color = _jacketDark
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cuffPaint = Paint()
      ..color = _shirtWhite
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (singerActive) {
      // Right arm thrust powerfully upward-forward (heroic tenor pose)
      final rEnd = Offset(sx + 68, sy - 88 + breath);
      canvas.drawPath(
        Path()
          ..moveTo(sx + 30, sy - 10 + breath)
          ..quadraticBezierTo(sx + 55, sy - 38 + breath * 0.6, rEnd.dx, rEnd.dy),
        sleevePaint,
      );
      // White cuff at end
      canvas.drawLine(
        Offset(rEnd.dx - 5, rEnd.dy + 2),
        Offset(rEnd.dx + 2, rEnd.dy - 3),
        cuffPaint,
      );
      // Hand at tip
      canvas.drawCircle(rEnd, 6, Paint()..color = _skin);

      // Left arm extended back and slightly down for counterbalance
      final lEnd = Offset(sx - 60, sy - 5 + breath * 0.4);
      canvas.drawPath(
        Path()
          ..moveTo(sx - 30, sy - 10 + breath)
          ..quadraticBezierTo(sx - 48, sy - 6 + breath * 0.7, lEnd.dx, lEnd.dy),
        sleevePaint,
      );
      canvas.drawLine(
        Offset(lEnd.dx + 4, lEnd.dy - 3),
        Offset(lEnd.dx - 2, lEnd.dy + 2),
        cuffPaint,
      );
      canvas.drawCircle(lEnd, 6, Paint()..color = _skin);
    } else {
      // Both arms hanging naturally at sides
      final lEnd = Offset(sx - 28, sy + 54 + breath * 0.2);
      final rEnd = Offset(sx + 28, sy + 54 + breath * 0.2);

      canvas.drawPath(
        Path()
          ..moveTo(sx - 30, sy - 10 + breath)
          ..quadraticBezierTo(sx - 36, sy + 22, lEnd.dx, lEnd.dy),
        sleevePaint,
      );
      canvas.drawLine(Offset(lEnd.dx + 3, lEnd.dy - 3), Offset(lEnd.dx - 3, lEnd.dy + 2), cuffPaint);
      canvas.drawCircle(lEnd, 5.5, Paint()..color = _skin);

      canvas.drawPath(
        Path()
          ..moveTo(sx + 30, sy - 10 + breath)
          ..quadraticBezierTo(sx + 36, sy + 22, rEnd.dx, rEnd.dy),
        sleevePaint,
      );
      canvas.drawLine(Offset(rEnd.dx - 3, rEnd.dy - 3), Offset(rEnd.dx + 3, rEnd.dy + 2), cuffPaint);
      canvas.drawCircle(rEnd, 5.5, Paint()..color = _skin);
    }
  }

  void _drawHead(Canvas canvas, double sx, double sy, double breath) {
    final headCY = sy - 56 + breath;

    // Face — slightly wider jaw
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, headCY + 2), width: 38, height: 44),
      Paint()..color = _skin,
    );
    // Stronger jaw line
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, headCY + 14), width: 34, height: 22),
      Paint()..color = _skin,
    );

    // 5 o'clock shadow hint on jaw
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, headCY + 14), width: 30, height: 16),
      Paint()..color = const Color(0x0A100608),
    );

    // Short dark hair — slightly wavy
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, headCY - 16), width: 40, height: 22),
      Paint()..color = const Color(0xFF12080A),
    );
    // Side parts
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx - 17, headCY - 8), width: 12, height: 26),
      Paint()..color = const Color(0xFF12080A),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx + 17, headCY - 8), width: 12, height: 26),
      Paint()..color = const Color(0xFF12080A),
    );
    // Hair part line
    canvas.drawLine(
      Offset(sx - 8, headCY - 22),
      Offset(sx - 6, headCY - 12),
      Paint()..color = const Color(0x30553322)..strokeWidth = 1.5,
    );
    // Hair shine
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx - 3, headCY - 18), width: 16, height: 10),
      -0.6, 0.9, false,
      Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0x20664433),
    );

    // Strong eyebrows
    final browPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF1A0A0A);
    canvas.drawArc(Rect.fromCenter(center: Offset(sx - 9, headCY - 10), width: 14, height: 7),
        pi + 0.1, pi - 0.2, false, browPaint);
    canvas.drawArc(Rect.fromCenter(center: Offset(sx + 9, headCY - 10), width: 14, height: 7),
        pi + 0.1, pi - 0.2, false, browPaint);

    // Eyes — slightly narrower, more intense
    canvas.drawOval(Rect.fromCenter(center: Offset(sx - 9, headCY - 2), width: 8, height: 5),
        Paint()..color = const Color(0xFF1A0A0A));
    canvas.drawOval(Rect.fromCenter(center: Offset(sx + 9, headCY - 2), width: 8, height: 5),
        Paint()..color = const Color(0xFF1A0A0A));
    canvas.drawCircle(Offset(sx - 8, headCY - 3), 1.0, Paint()..color = const Color(0x88FFFFFF));
    canvas.drawCircle(Offset(sx + 10, headCY - 3), 1.0, Paint()..color = const Color(0x88FFFFFF));

    // Mouth
    if (singerActive) {
      canvas.drawOval(Rect.fromCenter(center: Offset(sx, headCY + 12), width: 14, height: 17),
          Paint()..color = const Color(0xFF1A0000));
      canvas.drawRect(Rect.fromCenter(center: Offset(sx, headCY + 10), width: 10, height: 4),
          Paint()..color = const Color(0xFFF0EDE8));
    } else {
      // Confident slight smile
      canvas.drawPath(
        Path()
          ..moveTo(sx - 8, headCY + 10)
          ..quadraticBezierTo(sx, headCY + 15, sx + 8, headCY + 10),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF6A3020),
      );
    }
  }

  void _drawMusicNotes(Canvas canvas, double sx, double sy) {
    if (!singerActive) return;
    const noteConfigs = [
      [55.0, 1.4, 32.0, 0.0],
      [-60.0, 1.2, 26.0, 15.0],
      [70.0, 1.0, 38.0, 8.0],
    ];
    for (int i = 0; i < noteConfigs.length; i++) {
      final baseX = sx + noteConfigs[i][0];
      final wobbleFreq = noteConfigs[i][1];
      final riseSpeed = noteConfigs[i][2];
      final phase = noteConfigs[i][3];
      final nx = baseX + sin(time * wobbleFreq + i * 1.2) * 9;
      final rawY = (time * riseSpeed + phase) % 80;
      final ny = sy - 35 - rawY;
      if (ny < sy - 120 || ny > sy - 22) continue;
      final alpha = ((sy - 22 - ny) / 98.0).clamp(0.0, 1.0) * 0.85;
      canvas.drawOval(Rect.fromCenter(center: Offset(nx, ny), width: 8, height: 6),
          Paint()..color = actColor.withValues(alpha: alpha));
      canvas.drawLine(Offset(nx + 3.8, ny - 0.5), Offset(nx + 3.8, ny - 15),
          Paint()..color = actColor.withValues(alpha: alpha)..strokeWidth = 1.8);
      if (i.isEven) {
        canvas.drawPath(
          Path()..moveTo(nx + 3.8, ny - 15)..quadraticBezierTo(nx + 12, ny - 10, nx + 8, ny - 4),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 1.8..color = actColor.withValues(alpha: alpha),
        );
      }
    }
  }

  void _drawHalo(Canvas canvas, double sx, double sy, double breath) {
    if (!singerActive) return;
    final headCY = sy - 56 + breath;
    final haloAlpha = (sin(time * 6) * 0.28 + 0.52).clamp(0.0, 1.0);
    canvas.drawCircle(Offset(sx, headCY), 28 + sin(time * 8) * 4,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..color = actColor.withValues(alpha: haloAlpha * 0.70)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    canvas.drawCircle(Offset(sx, headCY), 48 + sin(time * 5 + 1) * 8,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = actColor.withValues(alpha: haloAlpha * 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
  }
}
