import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SteampunkStage {
  final double time;
  final Color actColor;
  final int bpm;
  final double curtainOpenProgress;

  SteampunkStage({
    required this.time,
    required this.actColor,
    required this.bpm,
    this.curtainOpenProgress = 1.0,
  });

  // ── BACKDROP (drawn BEFORE audience/singer) ─────────────────────────────

  void paintBackdrop(Canvas canvas, double w, double h) {
    _drawBackground(canvas, w, h);
    _drawBackWall(canvas, w, h);
    _drawSpotlights(canvas, w, h);
    _drawStageFloor(canvas, w, h);
  }

  // ── FOREGROUND (drawn AFTER audience/singer) ────────────────────────────

  void paintForeground(Canvas canvas, double w, double h) {
    _drawProscenium(canvas, w, h);
    _drawCurtains(canvas, w, h);
    _drawFootlights(canvas, w, h);
  }

  // ── 1. Background ─────────────────────────────────────────────────────────

  void _drawBackground(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(w / 2, h * 0.2),
          h * 1.1,
          [const Color(0xFF1A0E04), const Color(0xFF0D0702), Colors.black],
          [0.0, 0.45, 1.0],
        ),
    );
    _drawGearWatermark(canvas, w, h);
  }

  void _drawGearWatermark(Canvas canvas, double w, double h) {
    final cx = w / 2;
    final cy = h * 0.4;
    final r = h * 0.4;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(time * 0.05);

    final paint = Paint()
      ..color = const Color(0x06C07030)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset.zero, r, paint);
    canvas.drawCircle(Offset.zero, r * 0.6, paint);

    const numTeeth = 12;
    const toothW = 12.0;
    const toothH = 16.0;
    for (int t = 0; t < numTeeth; t++) {
      canvas.save();
      canvas.rotate(t * 2 * pi / numTeeth);
      canvas.drawRect(Rect.fromCenter(center: Offset(0, -(r + toothH / 2)), width: toothW, height: toothH), paint);
      canvas.restore();
    }

    for (int s = 0; s < 6; s++) {
      final a = s * pi / 3;
      canvas.drawLine(Offset(cos(a) * r * 0.6, sin(a) * r * 0.6), Offset(cos(a) * r * 0.2, sin(a) * r * 0.2), paint);
    }

    canvas.restore();
  }

  // ── 2. Back wall ──────────────────────────────────────────────────────────

  void _drawBackWall(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.04, w * 0.92, h * 0.74),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(w / 2, h * 0.04),
          Offset(w / 2, h * 0.78),
          [const Color(0xFF1C1008), const Color(0xFF0E0804)],
        ),
    );

    _drawRivetedPanels(canvas, w, h);
    _drawHorizontalPipes(canvas, w, h);
    _drawVerticalPipe(canvas, w, h, w * 0.15);
    _drawVerticalPipe(canvas, w, h, w * 0.85);
    _drawLargeGear(canvas, w, h);
    _drawPorthole(canvas, w, h, w * 0.25, h * 0.3);
    _drawPorthole(canvas, w, h, w * 0.75, h * 0.3);
  }

  void _drawRivetedPanels(Canvas canvas, double w, double h) {
    final panelW = w * 0.22;
    final panelH = h * 0.18;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 2.0..color = const Color(0xFF3A2010);
    final rivetPaint = Paint()..color = const Color(0xFF5C3818);

    for (double px = w * 0.04; px < w * 0.96; px += panelW) {
      for (double py = h * 0.04; py < h * 0.78; py += panelH) {
        canvas.drawRect(Rect.fromLTWH(px, py, panelW, panelH), borderPaint);
        for (final rx in [px + 5.0, px + panelW - 5.0]) {
          for (final ry in [py + 5.0, py + panelH - 5.0]) {
            canvas.drawCircle(Offset(rx, ry), 2.5, rivetPaint);
          }
        }
      }
    }
  }

  void _drawHorizontalPipes(Canvas canvas, double w, double h) {
    for (final py in [h * 0.20, h * 0.40, h * 0.60]) {
      canvas.drawLine(Offset(w * 0.04, py), Offset(w * 0.96, py),
          Paint()..color = const Color(0xFF8B5A2B)..strokeWidth = 8.0..strokeCap = StrokeCap.round);
      canvas.drawLine(Offset(w * 0.04, py - 2), Offset(w * 0.96, py - 2),
          Paint()..color = const Color(0xFFBB7A3B)..strokeWidth = 2.0);

      for (double fx = w * 0.04; fx <= w * 0.96; fx += w * 0.25) {
        canvas.drawRect(Rect.fromCenter(center: Offset(fx, py), width: 12, height: 14),
            Paint()..color = const Color(0xFF6A4020));
        for (final rv in [Offset(fx - 3, py - 3), Offset(fx + 3, py - 3), Offset(fx - 3, py + 3), Offset(fx + 3, py + 3)]) {
          canvas.drawCircle(rv, 1.5, Paint()..color = const Color(0xFF5C3818));
        }
      }
    }
  }

  void _drawVerticalPipe(Canvas canvas, double w, double h, double px) {
    canvas.drawLine(Offset(px, h * 0.04), Offset(px, h * 0.78),
        Paint()..color = const Color(0xFF7A4A1A)..strokeWidth = 6.0..strokeCap = StrokeCap.round);
    // Valve wheel
    final vy = h * 0.35;
    canvas.drawCircle(Offset(px, vy), 10, Paint()
        ..style = PaintingStyle.stroke..strokeWidth = 2.5..color = const Color(0xFF9A6A2A));
    canvas.drawLine(Offset(px - 10, vy), Offset(px + 10, vy),
        Paint()..color = const Color(0xFF9A6A2A)..strokeWidth = 2.0);
    canvas.drawLine(Offset(px, vy - 10), Offset(px, vy + 10),
        Paint()..color = const Color(0xFF9A6A2A)..strokeWidth = 2.0);
  }

  void _drawLargeGear(Canvas canvas, double w, double h) {
    final cx = w / 2;
    final cy = h * 0.35;
    final r = h * 0.14;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(time * 0.08);

    canvas.drawCircle(Offset.zero, r, Paint()..color = const Color(0x12C07030));
    canvas.drawCircle(Offset.zero, r, Paint()
        ..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0x40C07030));

    const numTeeth = 12;
    const toothW = 8.0;
    const toothH = 12.0;
    for (int t = 0; t < numTeeth; t++) {
      canvas.save();
      canvas.rotate(t * 2 * pi / numTeeth);
      canvas.drawRect(Rect.fromCenter(center: Offset(0, -(r + toothH / 2)), width: toothW, height: toothH),
          Paint()..color = const Color(0xFF5A3A10));
      canvas.drawRect(Rect.fromCenter(center: Offset(0, -(r + toothH / 2)), width: toothW, height: toothH),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0..color = const Color(0x40C07030));
      canvas.restore();
    }

    canvas.drawCircle(Offset.zero, r * 0.6, Paint()
        ..style = PaintingStyle.stroke..strokeWidth = 2.0..color = const Color(0xFF3A2008));

    for (int s = 0; s < 6; s++) {
      final a = s * pi / 3;
      canvas.drawLine(Offset(cos(a) * r * 0.6, sin(a) * r * 0.6), Offset(cos(a) * r * 0.15, sin(a) * r * 0.15),
          Paint()..color = const Color(0xFF4A2A0A)..strokeWidth = 2.5);
    }
    canvas.drawCircle(Offset.zero, r * 0.15, Paint()..color = const Color(0xFF2A1A08));

    canvas.restore();
  }

  void _drawPorthole(Canvas canvas, double w, double h, double px, double py) {
    final r = h * 0.07;
    canvas.drawCircle(Offset(px, py), r,
        Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)..color = const Color(0x18FFB060));
    canvas.drawCircle(Offset(px, py), r * 0.85, Paint()..color = const Color(0x14FFB060));
    canvas.drawCircle(Offset(px, py), r,
        Paint()..style = PaintingStyle.stroke..strokeWidth = 5.0..color = const Color(0xFF6A4018));
    for (final bp in [Offset(px, py - r), Offset(px, py + r), Offset(px - r, py), Offset(px + r, py)]) {
      canvas.drawCircle(bp, 4, Paint()..color = const Color(0xFF8A5828));
    }
  }

  // ── 3. Spotlights ─────────────────────────────────────────────────────────

  void _drawSpotlights(Canvas canvas, double w, double h) {
    final s1 = sin(time * 0.7) * w * 0.18;
    final s2 = sin(time * 0.5 + 1.2) * w * 0.14;
    final s3 = cos(time * 0.6 + 2.4) * w * 0.10;

    _beam(canvas, w, h, w / 2 + s1, const Color(0x2CFF9040), 110);
    _beam(canvas, w, h, w / 2 + s2 - w * 0.22, const Color(0x18FFB060), 80);
    _beam(canvas, w, h, w / 2 + s3 + w * 0.22, const Color(0x18FFB060), 80);
    _pool(canvas, h, w / 2 + s1, const Color(0x22FF8020), 90);
    _pool(canvas, h, w / 2 + s2 - w * 0.22, const Color(0x18FF8020), 60);
    _pool(canvas, h, w / 2 + s3 + w * 0.22, const Color(0x18FF8020), 60);
  }

  void _beam(Canvas canvas, double w, double h, double cx, Color color, double hw) {
    canvas.drawPath(
      Path()
        ..moveTo(cx - 6, 0)..lineTo(cx + 6, 0)
        ..lineTo(cx + hw, h * 0.78)..lineTo(cx - hw, h * 0.78)..close(),
      Paint()..shader = ui.Gradient.linear(Offset(cx, 0), Offset(cx, h * 0.78), [color, color.withValues(alpha: 0)]),
    );
  }

  void _pool(Canvas canvas, double h, double cx, Color color, double rx) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, h * 0.76), width: rx * 2, height: rx * 0.35),
      Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)..color = color,
    );
  }

  // ── 4. Stage floor ────────────────────────────────────────────────────────

  void _drawStageFloor(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.72, w, h * 0.28),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(w / 2, h * 0.72),
          Offset(w / 2, h),
          [const Color(0xFF1A1008), const Color(0xFF0A0804)],
        ),
    );

    // Diamond mesh — forward & backward diagonals
    final mesh = Paint()..color = const Color(0x22B87030)..strokeWidth = 0.7;
    for (double dx = -h * 0.28; dx < w + h * 0.28; dx += 16) {
      canvas.drawLine(Offset(dx, h * 0.72), Offset(dx + h * 0.28, h), mesh);
      canvas.drawLine(Offset(dx + h * 0.28, h * 0.72), Offset(dx, h), mesh);
    }

    // Floor bolt heads
    final bolt = Paint()..color = const Color(0xFF4A3018);
    for (double bx = 0; bx < w; bx += 16) {
      for (double by = h * 0.72; by < h; by += 16) {
        canvas.drawCircle(Offset(bx, by), 2.0, bolt);
      }
    }

    // Orange footlight reflection strip
    canvas.drawRect(Rect.fromLTWH(0, h * 0.72, w, 4),
        Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15)..color = const Color(0x20FF7010));
  }

  // ── 5. Proscenium (Industrial I-beam frame) ───────────────────────────────

  void _drawProscenium(Canvas canvas, double w, double h) {
    final columnW = w * 0.055;

    for (final isLeft in [true, false]) {
      final cx = isLeft ? 0.0 : w - columnW;
      canvas.drawRect(
        Rect.fromLTWH(cx, 0, columnW, h),
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(cx, 0), Offset(cx + columnW, 0),
            isLeft
                ? [const Color(0xFF2A1A08), const Color(0xFF150E04)]
                : [const Color(0xFF150E04), const Color(0xFF2A1A08)],
          ),
      );

      // Rivet dots
      for (double ry = 18; ry < h; ry += 18) {
        canvas.drawCircle(Offset(cx + columnW / 2, ry), 2.5, Paint()..color = const Color(0xFF5C3818));
      }

      // I-beam profile lines on inner edge
      final iX = isLeft ? cx + columnW - 6.0 : cx + 6.0;
      for (final offX in [-4.0, 4.0]) {
        canvas.drawLine(Offset(iX + offX, 0), Offset(iX + offX, h),
            Paint()..color = const Color(0xFF3A2010)..strokeWidth = 3.0);
      }

      // Copper trim
      canvas.drawRect(Rect.fromLTWH(isLeft ? cx + columnW - 3 : cx, 0, 3, h),
          Paint()..color = const Color(0xAA8B5A2B));

      // Gear ornament at column top
      _drawSmallGear(canvas, cx + columnW / 2, h * 0.06, 18, time * 0.15);
    }

    // Top valance
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.04), Paint()..color = const Color(0xFF1A0E04));

    // Decorative pipe + brass fittings
    canvas.drawRect(Rect.fromLTWH(0, h * 0.035 - 3, w, 6), Paint()..color = const Color(0xFF7A4A1A));
    for (double fx = 0; fx < w; fx += w * 0.1) {
      canvas.drawRect(Rect.fromCenter(center: Offset(fx, h * 0.035), width: 8, height: 10),
          Paint()..color = const Color(0xFF9B6A3B));
    }

    // Copper cornice bar
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.04, w, 4),
      Paint()
        ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(w, 0),
            [const Color(0x00C07030), const Color(0xFFC07030), const Color(0x00C07030)], [0.0, 0.5, 1.0]),
    );
  }

  void _drawSmallGear(Canvas canvas, double cx, double cy, double r, double rotation) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rotation);

    canvas.drawCircle(Offset.zero, r, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.0..color = const Color(0xFF8B5A2B));

    const numTeeth = 8;
    for (int t = 0; t < numTeeth; t++) {
      canvas.save();
      canvas.rotate(t * 2 * pi / numTeeth);
      canvas.drawRect(Rect.fromCenter(center: const Offset(0, -22), width: 4, height: 6),
          Paint()..color = const Color(0xFF8B5A2B));
      canvas.restore();
    }
    canvas.restore();
  }

  // ── 6. Curtains (Bronze/copper velvet) ────────────────────────────────────

  void _drawCurtains(Canvas canvas, double w, double h) {
    final t = curtainOpenProgress;
    final columnW = w * 0.055;
    final eased = t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2;
    final innerEdge = w * 0.48 + (columnW * 1.2 - w * 0.48) * eased;

    _curtainSide(canvas, w, h, isLeft: true, innerEdge: innerEdge);
    _curtainSide(canvas, w, h, isLeft: false, innerEdge: w - innerEdge);

    if (t < 0.3) {
      final a = (1 - t / 0.3).clamp(0.0, 1.0) * 0.55;
      canvas.drawRect(Rect.fromCenter(center: Offset(w / 2, h / 2), width: 40, height: h),
          Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)..color = Colors.black.withValues(alpha: a));
    }
  }

  void _curtainSide(Canvas canvas, double w, double h, {required bool isLeft, required double innerEdge}) {
    final outer = isLeft ? 0.0 : w;
    final colW = w * 0.055;
    final base = isLeft ? colW : w - colW;
    final foldW = (innerEdge - base).abs();
    const numFolds = 6;
    final foldStep = foldW / numFolds * (isLeft ? 1 : -1);
    final foldDepth = foldW * 0.25;

    final path = Path()..moveTo(outer, 0)..lineTo(innerEdge, 0);
    for (int i = 0; i <= numFolds; i++) {
      final fx = isLeft ? base + foldStep * i : base - foldStep.abs() * i;
      final bx = isLeft ? fx + sin(i * pi / numFolds) * foldDepth : fx - sin(i * pi / numFolds) * foldDepth;
      path.lineTo(bx, h);
    }
    path..lineTo(outer, h)..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(outer, 0),
          Offset(innerEdge, 0),
          isLeft
              ? [const Color(0xFF3A2008), const Color(0xFF261504), const Color(0xFF4A2A0A), const Color(0xFF1A0E04)]
              : [const Color(0xFF1A0E04), const Color(0xFF4A2A0A), const Color(0xFF261504), const Color(0xFF3A2008)],
          [0.0, 0.3, 0.65, 1.0],
        ),
    );

    for (int i = 1; i < numFolds; i++) {
      final fx = isLeft ? base + foldStep * i : base - foldStep.abs() * i;
      final bx = isLeft ? fx + sin(i * pi / numFolds) * foldDepth : fx - sin(i * pi / numFolds) * foldDepth;
      canvas.drawLine(Offset(bx, 0), Offset(fx, h),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0x55000000));
      canvas.drawLine(Offset(bx + (isLeft ? 2 : -2), 0), Offset(bx + (isLeft ? 2 : -2), h),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0..color = const Color(0x15FF9030));
    }

    // Spinning brass gear ornaments at inner edge
    for (int g = 1; g <= 3; g++) {
      final gearY = h * 0.25 * g;
      final gearX = isLeft ? innerEdge - 12.0 : innerEdge + 12.0;
      _drawBrassGear(canvas, gearX, gearY, 8, time * 0.2 + g * pi / 3);
    }

    // Brass chain fringe
    final fringeY = h * 0.90;
    canvas.drawLine(Offset(outer, fringeY), Offset(innerEdge, fringeY),
        Paint()..color = const Color(0xFF8B5A2B)..strokeWidth = 3.0);
    final step = isLeft ? 6.0 : -6.0;
    int li = 0;
    for (double x = outer; isLeft ? x < innerEdge : x > innerEdge; x += step) {
      canvas.drawOval(Rect.fromCenter(center: Offset(x, fringeY + 8 + (li % 2) * 4), width: 5, height: 7),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = const Color(0xFF9B6A3B));
      li++;
    }

    // Copper inner edge trim
    canvas.drawLine(Offset(innerEdge, 0), Offset(innerEdge, h),
        Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = const Color(0xAA8B5A2B));

    // Tieback
    if (curtainOpenProgress > 0.35) {
      final tieX = isLeft ? innerEdge + 12 : innerEdge - 12;
      canvas.drawOval(Rect.fromCenter(center: Offset(tieX, h * 0.55), width: 22, height: 14),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = const Color(0xFFB87030));
      canvas.drawRect(Rect.fromCenter(center: Offset(tieX, h * 0.55 + 14), width: 8, height: 16),
          Paint()..color = const Color(0xFF8B5A2B));
      for (int i = -3; i <= 3; i++) {
        canvas.drawLine(Offset(tieX + i * 1.2, h * 0.55 + 22), Offset(tieX + i * 1.5, h * 0.55 + 32),
            Paint()..color = const Color(0xFF7A4A1A)..strokeWidth = 1.0..strokeCap = StrokeCap.round);
      }
    }
  }

  void _drawBrassGear(Canvas canvas, double cx, double cy, double r, double rotation) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rotation);

    canvas.drawCircle(Offset.zero, r, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0xFFB87030));
    const numTeeth = 8;
    for (int t = 0; t < numTeeth; t++) {
      canvas.save();
      canvas.rotate(t * 2 * pi / numTeeth);
      canvas.drawRect(Rect.fromCenter(center: Offset(0, -(r + 2)), width: 3, height: 4),
          Paint()..color = const Color(0xFFB87030));
      canvas.restore();
    }
    canvas.restore();
  }

  // ── 7. Footlights (Gas lamp posts) ────────────────────────────────────────

  void _drawFootlights(Canvas canvas, double w, double h) {
    final pulse = 0.85 + sin(time * (bpm / 60.0) * pi) * 0.15;
    const pos = [0.12, 0.28, 0.5, 0.72, 0.88];

    for (int i = 0; i < pos.length; i++) {
      final fx = w * pos[i];
      final fy = h * 0.72;

      // Warm glow
      canvas.drawOval(Rect.fromCenter(center: Offset(fx, fy - 10), width: 70 * pulse, height: 35 * pulse),
          Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)..color = const Color(0x35FF8020));

      // Post
      canvas.drawRect(Rect.fromCenter(center: Offset(fx, fy - 9), width: 2, height: 18),
          Paint()..color = const Color(0xFF5A3A10));

      // Globe
      canvas.drawCircle(Offset(fx, fy - 18), 8, Paint()..color = const Color(0x60FFB060));
      canvas.drawCircle(Offset(fx, fy - 18), 8,
          Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0xFFB87030));

      // Steam puff cycling every 3 seconds
      final steamCycle = time % 3.0;
      final steamAlpha = ((1.0 - steamCycle / 3.0) * 0.12).clamp(0.0, 1.0);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(fx, fy - 26 - steamCycle * 8), width: 12, height: 8),
        Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)..color = Color.fromRGBO(255, 255, 255, steamAlpha),
      );
    }
  }
}
