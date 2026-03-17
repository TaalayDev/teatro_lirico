import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GothicStage {
  final double time;
  final Color actColor;
  final int bpm;
  final double curtainOpenProgress;

  GothicStage({
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
          Offset(w / 2, h * 0.1),
          h * 1.1,
          [const Color(0xFF05000D), const Color(0xFF020008), Colors.black],
          [0.0, 0.45, 1.0],
        ),
    );

    // Subtle moving aurora glows at top
    final auroraData = [
      (w * 0.25, h * 0.06, w * 0.45, h * 0.07, const Color(0xFF6030A0)),
      (w * 0.60, h * 0.04, w * 0.55, h * 0.05, const Color(0xFF2040A0)),
      (w * 0.42, h * 0.09, w * 0.38, h * 0.06, const Color(0xFF5020B0)),
    ];
    for (int i = 0; i < auroraData.length; i++) {
      final (cx, cy, rw, rh, col) = auroraData[i];
      final shift = sin(time * 0.3 + i * 1.4) * h * 0.015;
      final alpha = (0.04 + (sin(time * 0.3 + i * 2.1) * 0.5 + 0.5) * 0.04).clamp(0.0, 1.0);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + shift), width: rw, height: rh),
        Paint()
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28)
          ..color = col.withValues(alpha: alpha),
      );
    }
  }

  // ── 2. Back wall ──────────────────────────────────────────────────────────

  void _drawBackWall(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTWH(w * 0.04, h * 0.04, w * 0.92, h * 0.74),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(w / 2, h * 0.04),
          Offset(w / 2, h * 0.78),
          [const Color(0xFF0D0B14), const Color(0xFF060409)],
        ),
    );

    // Stone block grid
    final gridPaint = Paint()
      ..color = const Color(0x14A0A0CC)
      ..strokeWidth = 0.4
      ..style = PaintingStyle.stroke;
    for (double gx = w * 0.04; gx <= w * 0.96; gx += 36) {
      canvas.drawLine(Offset(gx, h * 0.04), Offset(gx, h * 0.78), gridPaint);
    }
    for (double gy = h * 0.04; gy <= h * 0.78; gy += 28) {
      canvas.drawLine(Offset(w * 0.04, gy), Offset(w * 0.96, gy), gridPaint);
    }

    _drawRoseWindow(canvas, w, h);

    for (final cx in [w * 0.25, w * 0.5, w * 0.75]) {
      _drawGothicArch(canvas, h, cx);
    }

    _drawTorchSconce(canvas, w * 0.15, h * 0.35, 0);
    _drawTorchSconce(canvas, w * 0.85, h * 0.35, 1);
  }

  void _drawGothicArch(Canvas canvas, double h, double cx) {
    const halfW = 50.0;
    final archTop = h * 0.07;
    final archBottom = h * 0.68;
    final midH = archTop + (archBottom - archTop) * 0.45;

    final path = Path()
      ..moveTo(cx - halfW, archBottom)
      ..lineTo(cx - halfW, midH)
      ..quadraticBezierTo(cx - halfW * 0.15, archTop - h * 0.01, cx, archTop)
      ..quadraticBezierTo(cx + halfW * 0.15, archTop - h * 0.01, cx + halfW, midH)
      ..lineTo(cx + halfW, archBottom)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(cx, archTop),
          Offset(cx, archBottom),
          [const Color(0xFF030206), const Color(0xFF07050F)],
        ),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = const Color(0x44B0A0D0),
    );

    // Small rose outline inside each arch
    final roseY = archTop + (archBottom - archTop) * 0.28;
    canvas.drawCircle(Offset(cx, roseY), 18, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0x22C0A0FF));
  }

  void _drawRoseWindow(Canvas canvas, double w, double h) {
    final cx = w / 2;
    final cy = h * 0.22;
    final r = h * 0.12;

    canvas.drawCircle(Offset(cx, cy), r,
        Paint()..style = PaintingStyle.stroke..strokeWidth = 2.0..color = const Color(0x30A080D0));

    final spokePaint = Paint()..color = const Color(0x25C0A0FF)..strokeWidth = 1.0;
    for (int s = 0; s < 8; s++) {
      final a = s * pi / 4;
      canvas.drawLine(Offset(cx, cy), Offset(cx + cos(a) * r, cy + sin(a) * r), spokePaint);
    }

    final petalFills = [Paint()..color = const Color(0x12D0B0FF), Paint()..color = const Color(0x10A0C0FF)];
    for (int p = 0; p < 8; p++) {
      final startA = p * pi / 4 - pi / 8;
      final path = Path()
        ..moveTo(cx, cy)
        ..arcTo(Rect.fromCenter(center: Offset(cx, cy), width: r * 1.2, height: r * 1.2), startA, pi / 4, false)
        ..close();
      canvas.drawPath(path, petalFills[p % 2]);
    }

    canvas.drawCircle(Offset(cx, cy), r * 0.2, Paint()..color = const Color(0x20FFD0A0));
  }

  void _drawTorchSconce(Canvas canvas, double sx, double sy, int index) {
    final dx = index == 0 ? 10.0 : -10.0;
    final bracketPaint = Paint()
      ..color = const Color(0xFF706060)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(sx, sy), Offset(sx + dx, sy), bracketPaint);
    canvas.drawLine(Offset(sx + dx, sy), Offset(sx + dx, sy - 14), bracketPaint);

    final topX = sx + dx;
    final topY = sy - 14;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(topX, topY - 4), width: 36, height: 22),
      Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)..color = const Color(0x40FF6000),
    );

    final flicker = (0.75 + sin(time * 11.0 + index * 2.1) * 0.25).clamp(0.0, 1.0);
    canvas.drawOval(Rect.fromCenter(center: Offset(topX, topY - 5), width: 8, height: 12),
        Paint()..color = Color.fromRGBO(255, 140, 0, flicker));
    canvas.drawOval(Rect.fromCenter(center: Offset(topX, topY - 7), width: 4, height: 7),
        Paint()..color = Color.fromRGBO(255, 220, 80, flicker));
  }

  // ── 3. Spotlights ─────────────────────────────────────────────────────────

  void _drawSpotlights(Canvas canvas, double w, double h) {
    final s1 = sin(time * 0.7) * w * 0.18;
    final s2 = sin(time * 0.5 + 1.2) * w * 0.14;
    final s3 = cos(time * 0.6 + 2.4) * w * 0.10;

    _beam(canvas, w, h, w / 2 + s1, const Color(0x20D0E8FF), 110);
    _beam(canvas, w, h, w / 2 + s2 - w * 0.22, const Color(0x14B0C8FF), 80);
    _beam(canvas, w, h, w / 2 + s3 + w * 0.22, const Color(0x14B0C8FF), 80);
    _pool(canvas, h, w / 2 + s1, const Color(0x18D0E0FF), 90);
    _pool(canvas, h, w / 2 + s2 - w * 0.22, const Color(0x14D0E0FF), 60);
    _pool(canvas, h, w / 2 + s3 + w * 0.22, const Color(0x14D0E0FF), 60);
  }

  void _beam(Canvas canvas, double w, double h, double cx, Color color, double hw) {
    canvas.drawPath(
      Path()
        ..moveTo(cx - 6, 0)
        ..lineTo(cx + 6, 0)
        ..lineTo(cx + hw, h * 0.78)
        ..lineTo(cx - hw, h * 0.78)
        ..close(),
      Paint()
        ..shader = ui.Gradient.linear(
            Offset(cx, 0), Offset(cx, h * 0.78), [color, color.withValues(alpha: 0)]),
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
          [const Color(0xFF111018), const Color(0xFF060508)],
        ),
    );

    final flag = Paint()..color = const Color(0x20A0A0C0)..strokeWidth = 0.8;
    for (double gy = h * 0.72; gy < h; gy += h * 0.04) {
      canvas.drawLine(Offset(0, gy), Offset(w, gy), flag);
    }
    for (double gx = 0; gx < w; gx += w * 0.08) {
      canvas.drawLine(Offset(gx, h * 0.72), Offset(gx, h), flag);
    }

    // Worn diagonal scratches
    final scratch = Paint()..color = const Color(0x08A0A0C0)..strokeWidth = 0.5;
    for (double sx = 0; sx < w * 2; sx += 42) {
      canvas.drawLine(Offset(sx, h * 0.72), Offset(sx - h * 0.28, h), scratch);
    }

    // Moonlight reflection
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h * 0.75), width: w * 0.35, height: h * 0.04),
      Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)..color = const Color(0x14B0A0FF),
    );
  }

  // ── 5. Proscenium (Gothic pointed arch frame) ─────────────────────────────

  void _drawProscenium(Canvas canvas, double w, double h) {
    final columnW = w * 0.045;

    for (final isLeft in [true, false]) {
      final cx = isLeft ? 0.0 : w - columnW;
      canvas.drawRect(
        Rect.fromLTWH(cx, 0, columnW, h),
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(cx, 0),
            Offset(cx + columnW, 0),
            isLeft
                ? [const Color(0xFF1A1520), const Color(0xFF0D0A12)]
                : [const Color(0xFF0D0A12), const Color(0xFF1A1520)],
          ),
      );

      final tracery = Paint()..color = const Color(0x20C0B0E0)..strokeWidth = 0.7;
      for (double fl = cx + 4; fl < cx + columnW - 2; fl += 4) {
        canvas.drawLine(Offset(fl, 0), Offset(fl, h), tracery);
      }
      canvas.drawRect(
        Rect.fromLTWH(isLeft ? cx + columnW - 2 : cx, 0, 2, h),
        Paint()..color = const Color(0x44C0B0E0),
      );
    }

    // Pointed arch at top of frame
    final archH = h * 0.12;
    final archPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, archH * 0.85)
      ..quadraticBezierTo(w * 0.25, archH * 1.1, w / 2, archH * 1.15)
      ..quadraticBezierTo(w * 0.75, archH * 1.1, w, archH * 0.85)
      ..lineTo(w, 0)
      ..close();

    canvas.drawPath(archPath, Paint()..color = const Color(0xFF12101A));
    canvas.drawPath(archPath, Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 3.0..color = const Color(0x50C0B0E0));

    // Inner tracery arcs
    for (int t = 0; t < 2; t++) {
      final in1 = columnW * (t + 1);
      final ht = archH * (0.95 - t * 0.20);
      final innerPath = Path()
        ..moveTo(in1, 0)
        ..quadraticBezierTo(w * (0.3 + t * 0.05), ht, w / 2, ht + h * 0.005)
        ..quadraticBezierTo(w * (0.7 - t * 0.05), ht, w - in1, 0);
      canvas.drawPath(innerPath, Paint()
        ..style = PaintingStyle.stroke..strokeWidth = 1.0..color = const Color(0x25D0C0FF));
    }

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.04), Paint()..color = const Color(0xFF0E0C16));
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.04, w, 3),
      Paint()
        ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(w, 0), [
          const Color(0x00C0B0E0),
          const Color(0xFFC0B0E0),
          const Color(0x00C0B0E0),
        ], [0.0, 0.5, 1.0]),
    );
  }

  // ── 6. Curtains (Gothic purple velvet) ───────────────────────────────────

  void _drawCurtains(Canvas canvas, double w, double h) {
    final t = curtainOpenProgress;
    final columnW = w * 0.045;
    final eased = t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2;
    final innerEdge = w * 0.48 + (columnW * 1.2 - w * 0.48) * eased;

    _curtainSide(canvas, w, h, isLeft: true, innerEdge: innerEdge);
    _curtainSide(canvas, w, h, isLeft: false, innerEdge: w - innerEdge);

    if (t < 0.3) {
      final a = (1 - t / 0.3).clamp(0.0, 1.0) * 0.55;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(w / 2, h / 2), width: 40, height: h),
        Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)..color = Colors.black.withValues(alpha: a),
      );
    }
  }

  void _curtainSide(Canvas canvas, double w, double h, {required bool isLeft, required double innerEdge}) {
    final outer = isLeft ? 0.0 : w;
    final colW = w * 0.045;
    final base = isLeft ? colW : w - colW;
    final foldW = (innerEdge - base).abs();
    const numFolds = 5;
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
              ? [const Color(0xFF1E0040), const Color(0xFF140030), const Color(0xFF2E0060), const Color(0xFF0A0020)]
              : [const Color(0xFF0A0020), const Color(0xFF2E0060), const Color(0xFF140030), const Color(0xFF1E0040)],
          [0.0, 0.3, 0.65, 1.0],
        ),
    );

    for (int i = 1; i < numFolds; i++) {
      final fx = isLeft ? base + foldStep * i : base - foldStep.abs() * i;
      final bx = isLeft ? fx + sin(i * pi / numFolds) * foldDepth : fx - sin(i * pi / numFolds) * foldDepth;
      canvas.drawLine(Offset(bx, 0), Offset(fx, h),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0x55000000));
      canvas.drawLine(Offset(bx + (isLeft ? 2 : -2), 0), Offset(bx + (isLeft ? 2 : -2), h),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0..color = const Color(0x18A060FF));
    }

    // Silver chain fringe
    final fringeY = h * 0.90;
    canvas.drawLine(Offset(outer, fringeY), Offset(innerEdge, fringeY),
        Paint()..color = const Color(0xFF9090B8)..strokeWidth = 2.0);
    final step = isLeft ? 4.0 : -4.0;
    for (double x = outer; isLeft ? x < innerEdge : x > innerEdge; x += step) {
      canvas.drawCircle(Offset(x, fringeY + 10 + sin((x - outer) * 0.25) * 4), 1.5,
          Paint()..color = const Color(0xFF9090B8));
    }

    // Inner silver trim
    canvas.drawLine(Offset(innerEdge, 0), Offset(innerEdge, h),
        Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = const Color(0xAA9080C0));

    // Tieback
    if (curtainOpenProgress > 0.35) {
      final tieX = isLeft ? innerEdge + 12 : innerEdge - 12;
      canvas.drawOval(Rect.fromCenter(center: Offset(tieX, h * 0.55), width: 22, height: 14),
          Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = const Color(0xFFA090D0));
      canvas.drawRect(Rect.fromCenter(center: Offset(tieX, h * 0.55 + 14), width: 8, height: 16),
          Paint()..color = const Color(0xFFA090D0));
      for (int i = -3; i <= 3; i++) {
        canvas.drawLine(Offset(tieX + i * 1.2, h * 0.55 + 22), Offset(tieX + i * 1.5, h * 0.55 + 32),
            Paint()..color = const Color(0xFF8070B0)..strokeWidth = 1.0..strokeCap = StrokeCap.round);
      }
    }
  }

  // ── 7. Footlights (candelabra) ─────────────────────────────────────────────

  void _drawFootlights(Canvas canvas, double w, double h) {
    final pulse = 0.85 + sin(time * (bpm / 60.0) * pi) * 0.15;
    const pos = [0.15, 0.2875, 0.5, 0.7125, 0.85];

    for (int i = 0; i < pos.length; i++) {
      final fx = w * pos[i];
      final fy = h * 0.72;

      canvas.drawOval(Rect.fromCenter(center: Offset(fx, fy - 5), width: 56 * pulse, height: 28 * pulse),
          Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)..color = const Color(0x30FF8000));
      canvas.drawLine(Offset(fx, fy), Offset(fx, fy - 18),
          Paint()..color = const Color(0xFF706060)..strokeWidth = 1.5);
      canvas.drawRect(Rect.fromCenter(center: Offset(fx, fy - 22), width: 4, height: 8),
          Paint()..color = const Color(0xFFE8DDD0));

      final flicker = sin(time * 13.0 + i * 0.9);
      final fa = (0.8 + flicker * 0.2).clamp(0.0, 1.0);
      final shift = flicker * 1.5;
      canvas.drawOval(Rect.fromCenter(center: Offset(fx + shift * 0.3, fy - 30), width: 5, height: 8),
          Paint()..color = Color.fromRGBO(255, 144, 0, fa));
      canvas.drawOval(Rect.fromCenter(center: Offset(fx + shift * 0.2, fy - 33), width: 3, height: 5),
          Paint()..color = Color.fromRGBO(255, 204, 0, fa));
    }
  }
}
