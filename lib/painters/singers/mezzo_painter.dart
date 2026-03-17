import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Act 1 — La Mezzo: empire-waist gown, Spanish peineta, arms spread wide.
class MezzoPainter {
  final double time;
  final Color actColor;
  final bool singerActive;

  const MezzoPainter({required this.time, required this.actColor, required this.singerActive});

  static const _skin = Color(0xFFD4956A);

  void draw(Canvas canvas, double w, double h) {
    final sx = w / 2;
    final sy = h * 0.57;
    final breath = sin(time * 2.5) * 2.5;
    final shimmer = sin(time * 2.8) * 0.5 + 0.5;

    _drawSpotlight(canvas, w, h, sx, actColor);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, h * 0.724), width: 110, height: 20),
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
        ..color = const Color(0xAA000000),
    );

    _drawGown(canvas, sx, sy, breath, shimmer);
    _drawArms(canvas, sx, sy, breath);

    canvas.drawRect(
      Rect.fromCenter(center: Offset(sx, sy - 28 + breath), width: 12, height: 18),
      Paint()..color = _skin,
    );

    _drawHead(canvas, sx, sy, breath);
    _drawPeineta(canvas, sx, sy, breath, shimmer);
    _drawJewelry(canvas, sx, sy, breath, shimmer);

    if (singerActive) _drawMusicNotes(canvas, sx, sy);
    if (singerActive) _drawHalo(canvas, sx, sy, breath);
  }

  void _drawSpotlight(Canvas canvas, double w, double h, double sx, Color color) {
    canvas.drawPath(
      Path()
        ..moveTo(sx - 6, 0)
        ..lineTo(sx + 6, 0)
        ..lineTo(sx + 100, h * 0.78)
        ..lineTo(sx - 100, h * 0.78)
        ..close(),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(sx, 0),
          Offset(sx, h * 0.78),
          [const Color(0x28FFE8D0), const Color(0x10FFE8D0), const Color(0x00FFE8D0)],
          [0.0, 0.5, 1.0],
        ),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, h * 0.724), width: 210, height: 48),
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 32)
        ..color = const Color(0x25FFD0A0),
    );
  }

  void _drawGown(Canvas canvas, double sx, double sy, double breath, double shimmer) {
    // Empire-waist bodice (fitted, ends at high waist sy+30)
    final bodice =
        Path()
          ..moveTo(sx - 20, sy - 18 + breath)
          ..quadraticBezierTo(sx - 24, sy + 14, sx - 19, sy + 38)
          ..lineTo(sx + 19, sy + 38)
          ..quadraticBezierTo(sx + 24, sy + 14, sx + 20, sy - 18 + breath)
          ..close();
    canvas.drawPath(
      bodice,
      Paint()
        ..shader = ui.Gradient.linear(Offset(sx, sy - 18), Offset(sx, sy + 38), [
          actColor,
          actColor.withValues(alpha: 0.75),
        ]),
    );

    // Empire band (horizontal accent at high waist)
    canvas.drawRect(
      Rect.fromCenter(center: Offset(sx, sy + 38), width: 42, height: 6),
      Paint()..color = Colors.white.withValues(alpha: 0.25 + shimmer * 0.10),
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(sx, sy + 38), width: 42, height: 6),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = actColor.withValues(alpha: 0.6),
    );

    // Skirt — A-line, not as extreme as soprano's bell
    final skirtOuter =
        Path()
          ..moveTo(sx - 22, sy + 36)
          ..quadraticBezierTo(sx - 72, sy + 110, sx - 88, sy + 215)
          ..lineTo(sx + 88, sy + 215)
          ..quadraticBezierTo(sx + 72, sy + 110, sx + 22, sy + 36)
          ..close();
    canvas.drawPath(skirtOuter, Paint()..color = actColor.withValues(alpha: 0.58));

    final skirtMain =
        Path()
          ..moveTo(sx - 20, sy + 36)
          ..quadraticBezierTo(sx - 65, sy + 108, sx - 82, sy + 212)
          ..lineTo(sx + 82, sy + 212)
          ..quadraticBezierTo(sx + 65, sy + 108, sx + 20, sy + 36)
          ..close();
    canvas.drawPath(skirtMain, Paint()..color = actColor);

    // Sheen
    canvas.drawPath(
      skirtMain,
      Paint()
        ..shader = ui.Gradient.linear(Offset(sx - 70, sy + 36), Offset(sx + 30, sy + 180), [
          Colors.white.withValues(alpha: 0.18 + shimmer * 0.10),
          Colors.transparent,
        ]),
    );

    // Two elegant floral lace panels down the skirt
    final lacePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = Colors.white.withValues(alpha: 0.18 + shimmer * 0.06);
    for (int panel = 0; panel < 2; panel++) {
      final px = sx + (panel == 0 ? -28.0 : 28.0);
      for (int i = 0; i < 4; i++) {
        canvas.drawOval(Rect.fromCenter(center: Offset(px, sy + 70 + i * 35.0), width: 14, height: 22), lacePaint);
      }
    }

    // Skirt outline
    canvas.drawPath(
      skirtMain,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = actColor.withValues(alpha: 0.45),
    );

    // Bodice seams
    final seamPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = actColor.withValues(alpha: 0.30);
    canvas.drawLine(Offset(sx, sy - 16 + breath), Offset(sx, sy + 37), seamPaint);
    canvas.drawLine(Offset(sx - 10, sy - 8 + breath), Offset(sx - 8, sy + 37), seamPaint);
    canvas.drawLine(Offset(sx + 10, sy - 8 + breath), Offset(sx + 8, sy + 37), seamPaint);

    // Décolleté neckline
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx, sy - 18 + breath), width: 38, height: 14),
      0.1,
      pi - 0.2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = _skin.withValues(alpha: 0.5),
    );
  }

  void _drawArms(Canvas canvas, double sx, double sy, double breath) {
    final skinPaint =
        Paint()
          ..color = _skin
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    if (singerActive) {
      // Both arms spread wide horizontally — dramatic mezzo gesture
      final lEnd = Offset(sx - 88, sy - 18 + breath * 0.6);
      final rEnd = Offset(sx + 88, sy - 18 + breath * 0.6);

      canvas.drawPath(
        Path()
          ..moveTo(sx - 20, sy - 14 + breath)
          ..quadraticBezierTo(sx - 55, sy - 22 + breath * 0.8, lEnd.dx, lEnd.dy),
        skinPaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx + 20, sy - 14 + breath)
          ..quadraticBezierTo(sx + 55, sy - 22 + breath * 0.8, rEnd.dx, rEnd.dy),
        skinPaint,
      );
      // Hands (palms open — slightly larger)
      canvas.drawCircle(lEnd, 6, Paint()..color = _skin);
      canvas.drawCircle(rEnd, 6, Paint()..color = _skin);
      // Finger suggestion lines
      for (final side in [-1, 1]) {
        final end = side < 0 ? lEnd : rEnd;
        for (int f = 0; f < 3; f++) {
          canvas.drawLine(
            Offset(end.dx + side * (3 + f * 3.5), end.dy - 3),
            Offset(end.dx + side * (3 + f * 3.5), end.dy + 5),
            Paint()
              ..color = _skin.withValues(alpha: 0.6)
              ..strokeWidth = 1.5
              ..strokeCap = StrokeCap.round,
          );
        }
      }
    } else {
      // Right arm at hip, left arm slightly forward
      canvas.drawPath(
        Path()
          ..moveTo(sx - 20, sy - 14 + breath)
          ..quadraticBezierTo(sx - 38, sy + 18, sx - 30, sy + 50 + breath * 0.3),
        skinPaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx + 20, sy - 14 + breath)
          ..quadraticBezierTo(sx + 32, sy + 10, sx + 24, sy + 30 + breath * 0.3),
        skinPaint,
      );
    }
  }

  void _drawHead(Canvas canvas, double sx, double sy, double breath) {
    final headCY = sy - 46 + breath;

    // Face — slightly warmer/deeper skin tone
    canvas.drawOval(Rect.fromCenter(center: Offset(sx, headCY), width: 35, height: 41), Paint()..color = _skin);

    // Stronger blush
    for (final side in [-1, 1]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sx + side * 11.0, headCY + 6), width: 14, height: 9),
        Paint()
          ..color = const Color(0x35D05040)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }

    // Dark hair — swept back with loose tendrils
    // Main mass
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, headCY - 10), width: 40, height: 28),
      Paint()..color = const Color(0xFF100603),
    );
    // Side sweeps
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx - 18, headCY + 2), width: 14, height: 34),
      Paint()..color = const Color(0xFF100603),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx + 18, headCY + 2), width: 14, height: 34),
      Paint()..color = const Color(0xFF100603),
    );
    // Tendril curls at sides
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx - 22, headCY + 10), width: 10, height: 20),
      -0.5,
      2.0,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF100603),
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx + 22, headCY + 10), width: 10, height: 20),
      pi - 1.5,
      2.0,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF100603),
    );
    // Low chignon at back/nape
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx, headCY + 18), width: 22, height: 14),
      Paint()..color = const Color(0xFF100603),
    );
    // Hair sheen
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx - 5, headCY - 14), width: 20, height: 14),
      -0.8,
      1.1,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = const Color(0x22553311),
    );

    // Bold arched eyebrows
    final browPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF1A0603);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx - 8, headCY - 10), width: 14, height: 7),
      pi + 0.1,
      pi - 0.2,
      false,
      browPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(sx + 8, headCY - 10), width: 14, height: 7),
      pi + 0.1,
      pi - 0.2,
      false,
      browPaint,
    );

    // Almond-shaped eyes (larger, more dramatic)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx - 8, headCY - 2), width: 8, height: 5.5),
      Paint()..color = const Color(0xFF1A0603),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sx + 8, headCY - 2), width: 8, height: 5.5),
      Paint()..color = const Color(0xFF1A0603),
    );
    canvas.drawCircle(Offset(sx - 7, headCY - 3), 1.2, Paint()..color = const Color(0x88FFFFFF));
    canvas.drawCircle(Offset(sx + 9, headCY - 3), 1.2, Paint()..color = const Color(0x88FFFFFF));
    // Eyeliner flick
    canvas.drawLine(
      Offset(sx - 12, headCY - 2),
      Offset(sx - 14, headCY - 5),
      Paint()
        ..color = const Color(0xFF100603)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(sx + 12, headCY - 2),
      Offset(sx + 14, headCY - 5),
      Paint()
        ..color = const Color(0xFF100603)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );

    // Mouth — rich red lips
    if (singerActive) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sx, headCY + 12), width: 13, height: 16),
        Paint()..color = const Color(0xFF5A0010),
      );
      canvas.drawRect(
        Rect.fromCenter(center: Offset(sx, headCY + 10), width: 10, height: 3.5),
        Paint()..color = const Color(0xFFF5F0E8),
      );
    } else {
      // Defined red lips, slight smile
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sx, headCY + 11), width: 14, height: 7),
        Paint()..color = const Color(0xFF7A0018),
      );
      canvas.drawPath(
        Path()
          ..moveTo(sx - 7, headCY + 9)
          ..quadraticBezierTo(sx, headCY + 14, sx + 7, headCY + 9),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF4A000C),
      );
    }
  }

  void _drawPeineta(Canvas canvas, double sx, double sy, double breath, double shimmer) {
    final headCY = sy - 46 + breath;
    final combBaseY = headCY - 22;
    // Comb base (wide tortoiseshell shape)
    final combPaint = Paint()..color = const Color(0xFF5C2800);
    canvas.drawRect(Rect.fromCenter(center: Offset(sx, combBaseY - 2), width: 34, height: 8), combPaint);
    // Comb teeth (spires pointing upward)
    for (int t = -3; t <= 3; t++) {
      canvas.drawLine(
        Offset(sx + t * 4.5, combBaseY - 6),
        Offset(sx + t * 4.5, combBaseY - 22),
        Paint()
          ..color = const Color(0xFF5C2800)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }
    // Gold decoration on comb
    canvas.drawRect(
      Rect.fromCenter(center: Offset(sx, combBaseY - 2), width: 34, height: 3),
      Paint()..color = const Color(0xFFEDD97A).withValues(alpha: 0.55 + shimmer * 0.35),
    );
  }

  void _drawJewelry(Canvas canvas, double sx, double sy, double breath, double shimmer) {
    final headCY = sy - 46 + breath;
    final neckY = headCY + 22;

    // Pearl necklace — multiple small pearls
    const pearls = 9;
    for (int p = 0; p < pearls; p++) {
      final angle = pi * 0.18 + (pi - 0.36) * p / (pearls - 1);
      final cx = sx + cos(pi - angle) * 14;
      final cy = neckY - sin(pi - angle) * 9;
      canvas.drawCircle(
        Offset(cx, cy),
        2.2,
        Paint()
          ..color = const Color(0xFFF0EEE8)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5 + shimmer),
      );
    }
  }

  void _drawMusicNotes(Canvas canvas, double sx, double sy) {
    const noteConfigs = [
      [60.0, 1.2, 28.0, 5.0],
      [-65.0, 1.0, 22.0, 25.0],
      [75.0, 0.8, 32.0, 12.0],
    ];
    for (int i = 0; i < noteConfigs.length; i++) {
      final baseX = sx + noteConfigs[i][0];
      final wobbleFreq = noteConfigs[i][1];
      final riseSpeed = noteConfigs[i][2];
      final phase = noteConfigs[i][3];
      final nx = baseX + sin(time * wobbleFreq + i * 1.3) * 9;
      final rawY = (time * riseSpeed + phase) % 75;
      final ny = sy - 30 - rawY;
      if (ny < sy - 110 || ny > sy - 20) continue;
      final alpha = ((sy - 20 - ny) / 90.0).clamp(0.0, 1.0) * 0.85;
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
    }
  }

  void _drawHalo(Canvas canvas, double sx, double sy, double breath) {
    final headCY = sy - 46 + breath;
    final haloAlpha = (sin(time * 5.5) * 0.28 + 0.52).clamp(0.0, 1.0);
    canvas.drawCircle(
      Offset(sx, headCY),
      32 + sin(time * 7) * 5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = actColor.withValues(alpha: haloAlpha * 0.70)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(
      Offset(sx, headCY),
      56 + sin(time * 4.5 + 1) * 9,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = actColor.withValues(alpha: haloAlpha * 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
  }
}
