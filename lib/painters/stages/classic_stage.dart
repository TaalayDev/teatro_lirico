import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ClassicStage {
  final double time;
  final Color actColor;
  final int bpm;
  final double curtainOpenProgress;

  ClassicStage({
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

  // ── 1. Deep background ────────────────────────────────────────────────────

  void _drawBackground(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(w / 2, h * 0.2),
          h * 1.1,
          [const Color(0xFF1C0505), const Color(0xFF0A0202), Colors.black],
          [0.0, 0.5, 1.0],
        ),
    );
  }

  // ── 2. Back wall ──────────────────────────────────────────────────────────

  void _drawBackWall(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTWH(w * 0.05, h * 0.05, w * 0.9, h * 0.75),
      Paint()
        ..shader = ui.Gradient.linear(Offset(w / 2, h * 0.05), Offset(w / 2, h * 0.8), [
          const Color(0xFF1A0C08),
          const Color(0xFF0D0404),
        ]),
    );

    // Arch moulding
    final archPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFF3A1A0A);
    for (int i = 0; i < 3; i++) {
      final inset = i * 14.0;
      final rect = Rect.fromLTWH(w * 0.08 + inset, h * 0.06 + inset, w * 0.84 - inset * 2, h * 0.55);
      canvas.drawArc(rect, pi, pi, false, archPaint);
    }

    // Damask wallpaper pattern
    final damaskPaint = Paint()
      ..color = const Color(0x12B89947)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    const cellW = 28.0;
    const cellH = 28.0;
    for (double dx = w * 0.05; dx < w * 0.95; dx += cellW) {
      for (double dy = h * 0.05; dy < h * 0.8; dy += cellH) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset(dx + cellW / 2, dy + cellH / 2), width: cellW * 0.6, height: cellH * 0.6),
          damaskPaint,
        );
      }
    }

    // Gold cornice rail
    canvas.drawRect(
      Rect.fromLTWH(w * 0.05, h * 0.05, w * 0.9, 6),
      Paint()
        ..shader = ui.Gradient.linear(Offset(w * 0.05, h * 0.05), Offset(w * 0.05, h * 0.08), [
          const Color(0xFFB89947),
          const Color(0xFF5A3A00),
        ]),
    );
  }

  // ── 3. Spotlights ─────────────────────────────────────────────────────────

  void _drawSpotlights(Canvas canvas, double w, double h) {
    final sweep1 = sin(time * 0.7) * w * 0.18;
    final sweep2 = sin(time * 0.5 + 1.2) * w * 0.14;
    final sweep3 = cos(time * 0.6 + 2.4) * w * 0.10;

    _drawBeam(canvas, w, h, w / 2 + sweep1, const Color(0x28FDF5A9), 110);
    _drawBeam(canvas, w, h, w / 2 + sweep2 - w * 0.22, const Color(0x18FFD0A0), 80);
    _drawBeam(canvas, w, h, w / 2 + sweep3 + w * 0.22, const Color(0x18D0E8FF), 80);

    _drawFloorPool(canvas, h, w / 2 + sweep1, const Color(0x22FDF5A9), 90);
    _drawFloorPool(canvas, h, w / 2 + sweep2 - w * 0.22, const Color(0x14FFD0A0), 60);
    _drawFloorPool(canvas, h, w / 2 + sweep3 + w * 0.22, const Color(0x14D0E8FF), 60);
  }

  void _drawBeam(Canvas canvas, double w, double h, double cx, Color color, double halfW) {
    canvas.drawPath(
      Path()
        ..moveTo(cx - 6, 0)
        ..lineTo(cx + 6, 0)
        ..lineTo(cx + halfW, h * 0.78)
        ..lineTo(cx - halfW, h * 0.78)
        ..close(),
      Paint()
        ..shader = ui.Gradient.linear(Offset(cx, 0), Offset(cx, h * 0.78), [color, color.withValues(alpha: 0.0)]),
    );
  }

  void _drawFloorPool(Canvas canvas, double h, double cx, Color color, double rx) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, h * 0.76), width: rx * 2, height: rx * 0.35),
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
        ..color = color,
    );
  }

  // ── 4. Stage floor ────────────────────────────────────────────────────────

  void _drawStageFloor(Canvas canvas, double w, double h) {
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.72, w, h * 0.28),
      Paint()
        ..shader = ui.Gradient.linear(Offset(w / 2, h * 0.72), Offset(w / 2, h), [
          const Color(0xFF2A1208),
          const Color(0xFF0E0503),
        ]),
    );

    // Polished wood plank lines
    final plankPaint = Paint()..color = const Color(0x18B86A30)..strokeWidth = 1;
    for (double px = 0; px < w; px += 22) {
      canvas.drawLine(Offset(px, h * 0.72), Offset(px + 8, h), plankPaint);
    }

    // Stage edge highlight
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.72, w, 3),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.72),
          Offset(w, h * 0.72),
          [
            const Color(0x00B89947),
            const Color(0xAAB89947),
            const Color(0xFFEDD97A),
            const Color(0xAAB89947),
            const Color(0x00B89947),
          ],
          [0.0, 0.2, 0.5, 0.8, 1.0],
        ),
    );

    // Apron ellipse gloss
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h * 0.72), width: w * 0.8, height: h * 0.06),
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..color = const Color(0x22B89947),
    );
  }

  // ── 5. Proscenium arch frame ──────────────────────────────────────────────

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
                ? [const Color(0xFF3A1800), const Color(0xFF1C0A00)]
                : [const Color(0xFF1C0A00), const Color(0xFF3A1800)],
          ),
      );

      final flutePaint = Paint()..color = const Color(0x30B89947)..strokeWidth = 1;
      for (double fl = cx + 6; fl < cx + columnW - 2; fl += 5) {
        canvas.drawLine(Offset(fl, 0), Offset(fl, h), flutePaint);
      }

      canvas.drawRect(Rect.fromLTWH(isLeft ? cx + columnW - 2 : cx, 0, 2, h),
          Paint()..color = const Color(0x55B89947));
    }

    // Top valance
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.035),
      Paint()
        ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, h * 0.035), [
          const Color(0xFF2A1000),
          const Color(0xFF0A0300),
        ]),
    );

    // Gold cornice moulding
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.033, w, 4),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.033),
          Offset(w, h * 0.033),
          [
            const Color(0x00B89947),
            const Color(0xFFEDD97A),
            const Color(0xFFB89947),
            const Color(0xFFEDD97A),
            const Color(0x00B89947),
          ],
          [0.0, 0.15, 0.5, 0.85, 1.0],
        ),
    );
  }

  // ── 6. Curtains ───────────────────────────────────────────────────────────

  void _drawCurtains(Canvas canvas, double w, double h) {
    final t = curtainOpenProgress;
    final columnW = w * 0.045;
    final eased = t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2;
    final innerEdge = w * 0.48 + (columnW * 1.2 - w * 0.48) * eased;

    _drawCurtainSide(canvas, w, h, isLeft: true, innerEdge: innerEdge);
    _drawCurtainSide(canvas, w, h, isLeft: false, innerEdge: w - innerEdge);

    if (t < 0.3) {
      final shadowAlpha = (1 - t / 0.3).clamp(0.0, 1.0) * 0.55;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(w / 2, h / 2), width: 40, height: h),
        Paint()
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
          ..color = Colors.black.withValues(alpha: shadowAlpha),
      );
    }
  }

  void _drawCurtainSide(Canvas canvas, double w, double h, {required bool isLeft, required double innerEdge}) {
    final outerEdge = isLeft ? 0.0 : w;
    final columnW = w * 0.045;
    final foldWidth = (innerEdge - (isLeft ? columnW : w - columnW - columnW)).abs();
    const numFolds = 5;
    final foldStep = isLeft ? foldWidth / numFolds : -foldWidth / numFolds;
    final base = isLeft ? columnW : w - columnW;

    final curtainPath = Path()
      ..moveTo(outerEdge, 0)
      ..lineTo(innerEdge, 0);
    final foldDepth = foldWidth * 0.25;
    for (int i = 0; i <= numFolds; i++) {
      final fx = isLeft ? base + (foldStep * i) : base - (foldStep.abs() * i);
      final bulge = sin(i * pi / numFolds) * foldDepth;
      final bx = isLeft ? fx + bulge : fx - bulge;
      curtainPath.lineTo(bx, h);
    }
    curtainPath..lineTo(outerEdge, h)..close();

    canvas.drawPath(
      curtainPath,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(outerEdge, 0),
          Offset(innerEdge, 0),
          isLeft
              ? [const Color(0xFF5C0000), const Color(0xFF3A0000), const Color(0xFF8A1010), const Color(0xFF2A0000)]
              : [const Color(0xFF2A0000), const Color(0xFF8A1010), const Color(0xFF3A0000), const Color(0xFF5C0000)],
          [0.0, 0.3, 0.65, 1.0],
        ),
    );

    final foldShadow = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0x55000000);
    final foldHighlight = Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = const Color(0x22FF6060);
    for (int i = 1; i < numFolds; i++) {
      final fx = isLeft ? base + foldStep * i : base - foldStep.abs() * i;
      final bulge = sin(i * pi / numFolds) * foldDepth;
      final bx = isLeft ? fx + bulge : fx - bulge;
      canvas.drawLine(Offset(bx, 0), Offset(fx, h), foldShadow);
      canvas.drawLine(Offset(bx + (isLeft ? 2 : -2), 0), Offset(bx + (isLeft ? 2 : -2), h), foldHighlight);
    }

    _drawFringe(canvas, h, isLeft: isLeft, outerEdge: outerEdge, innerEdge: innerEdge);

    if (curtainOpenProgress > 0.35) {
      _drawTieback(canvas, h, isLeft: isLeft, innerEdge: innerEdge);
    }

    canvas.drawLine(Offset(innerEdge, 0), Offset(innerEdge, h),
        Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = const Color(0xAAB89947));
    canvas.drawLine(Offset(isLeft ? outerEdge + 6.0 : outerEdge - 6.0, 0),
        Offset(isLeft ? outerEdge + 6.0 : outerEdge - 6.0, h),
        Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = const Color(0x30FF8888));
  }

  void _drawFringe(Canvas canvas, double h, {required bool isLeft, required double outerEdge, required double innerEdge}) {
    final fringeY = h * 0.9;
    final fringePaint = Paint()
      ..color = const Color(0xFFB89947)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final step = isLeft ? 4.0 : -4.0;
    for (double x = outerEdge; isLeft ? x < innerEdge : x > innerEdge; x += step) {
      final droop = 12.0 + sin((x - outerEdge) * 0.3) * 5;
      canvas.drawLine(Offset(x, fringeY), Offset(x + sin(x * 0.5) * 2, fringeY + droop), fringePaint);
    }
    canvas.drawLine(Offset(outerEdge, fringeY), Offset(innerEdge, fringeY),
        Paint()..color = const Color(0xFFB89947)..strokeWidth = 2.5);
  }

  void _drawTieback(Canvas canvas, double h, {required bool isLeft, required double innerEdge}) {
    final tieY = h * 0.55;
    final tieX = isLeft ? innerEdge + 12 : innerEdge - 12;
    canvas.drawOval(Rect.fromCenter(center: Offset(tieX, tieY), width: 22, height: 14),
        Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = const Color(0xFFB89947));
    canvas.drawRect(Rect.fromCenter(center: Offset(tieX, tieY + 14), width: 8, height: 16),
        Paint()..color = const Color(0xFFB89947));
    final tp = Paint()..color = const Color(0xFF8A6E20)..strokeWidth = 1..strokeCap = StrokeCap.round;
    for (int i = -3; i <= 3; i++) {
      canvas.drawLine(Offset(tieX + i * 1.2, tieY + 22), Offset(tieX + i * 1.5, tieY + 32), tp);
    }
  }

  // ── 7. Footlights ─────────────────────────────────────────────────────────

  void _drawFootlights(Canvas canvas, double w, double h) {
    final footY = h * 0.72;
    final pulse = 0.85 + sin(time * (bpm / 60.0) * pi) * 0.15;

    final footColors = [
      const Color(0x40FFB080),
      const Color(0x30FFFFC0),
      const Color(0x28FFB080),
      const Color(0x30FFFFC0),
      const Color(0x40FFB080),
    ];

    for (int i = 0; i < footColors.length; i++) {
      final fx = w * (0.15 + i * 0.175);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(fx, footY - 10), width: 50 * pulse, height: 30 * pulse),
        Paint()
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22)
          ..color = footColors[i],
      );
    }
  }
}
