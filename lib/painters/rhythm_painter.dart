import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/game_models.dart';

const laneColors = [
  Color(0xFFE8354A), // left  – crimson
  Color(0xFFF5D76E), // down  – gold
  Color(0xFF5DD67C), // up    – emerald
  Color(0xFF4B9EF5), // right – sapphire
];

// Darker saturated versions for tails / glow bases
const _laneDark = [Color(0xFF7A0D18), Color(0xFF8A7200), Color(0xFF1A6B35), Color(0xFF0A3D8A)];

const laneXFractions = [0.15, 0.40, 0.60, 0.85];

// ── Arrow geometry helpers ─────────────────────────────────────────────────

/// Builds the outer arrow path for a given lane.
Path _arrowPath(int lane, double cx, double cy, double s) {
  // Each arrow is a chevron-style shape with a notched back.
  // s = half-size (the "radius")
  final path = Path();
  switch (lane) {
    case 0: // ◄ Left
      path
        ..moveTo(cx + s * 0.5, cy - s) // top-right
        ..lineTo(cx - s, cy) // tip left
        ..lineTo(cx + s * 0.5, cy + s) // bottom-right
        ..lineTo(cx + s * 0.15, cy + s * 0.45) // inner-bottom notch
        ..lineTo(cx + s * 0.15, cy - s * 0.45) // inner-top notch
        ..close();
    case 1: // ▼ Down
      path
        ..moveTo(cx - s, cy - s * 0.5)
        ..lineTo(cx, cy + s)
        ..lineTo(cx + s, cy - s * 0.5)
        ..lineTo(cx + s * 0.45, cy - s * 0.15)
        ..lineTo(cx - s * 0.45, cy - s * 0.15)
        ..close();
    case 2: // ▲ Up
      path
        ..moveTo(cx - s, cy + s * 0.5)
        ..lineTo(cx, cy - s)
        ..lineTo(cx + s, cy + s * 0.5)
        ..lineTo(cx + s * 0.45, cy + s * 0.15)
        ..lineTo(cx - s * 0.45, cy + s * 0.15)
        ..close();
    case 3: // ► Right
      path
        ..moveTo(cx - s * 0.5, cy - s)
        ..lineTo(cx + s, cy)
        ..lineTo(cx - s * 0.5, cy + s)
        ..lineTo(cx - s * 0.15, cy + s * 0.45)
        ..lineTo(cx - s * 0.15, cy - s * 0.45)
        ..close();
  }
  return path;
}

/// Inner highlight slash on the arrow (gives a 3-D gem look).
Path _arrowHighlight(int lane, double cx, double cy, double s) {
  final path = Path();
  final hs = s * 0.38;
  switch (lane) {
    case 0:
      path
        ..moveTo(cx + s * 0.05, cy - hs)
        ..lineTo(cx + s * 0.5 - 4, cy - hs)
        ..lineTo(cx + s * 0.5 - 4, cy - hs * 0.3)
        ..lineTo(cx + s * 0.05, cy - hs * 0.3)
        ..close();
    case 1:
      path
        ..moveTo(cx - hs, cy - s * 0.4)
        ..lineTo(cx + hs, cy - s * 0.4)
        ..lineTo(cx + hs * 0.5, cy - s * 0.05)
        ..lineTo(cx - hs * 0.5, cy - s * 0.05)
        ..close();
    case 2:
      path
        ..moveTo(cx - hs, cy + s * 0.4)
        ..lineTo(cx + hs, cy + s * 0.4)
        ..lineTo(cx + hs * 0.5, cy + s * 0.05)
        ..lineTo(cx - hs * 0.5, cy + s * 0.05)
        ..close();
    case 3:
      path
        ..moveTo(cx - s * 0.5 + 4, cy - hs)
        ..lineTo(cx - s * 0.05, cy - hs)
        ..lineTo(cx - s * 0.05, cy - hs * 0.3)
        ..lineTo(cx - s * 0.5 + 4, cy - hs * 0.3)
        ..close();
  }
  return path;
}

// ── Receptor (static target at hit zone) ──────────────────────────────────

Path _receptorPath(int lane, double cx, double cy, double s) {
  // Same shape as the arrow but slightly larger — an "outline" target.
  return _arrowPath(lane, cx, cy, s);
}

// ══════════════════════════════════════════════════════════════════════════════
//  RhythmPainter
// ══════════════════════════════════════════════════════════════════════════════

class RhythmPainter extends CustomPainter {
  final double time;
  final double hitZoneY;
  final double scrollSpeed;
  final List<GameNote> notes;
  final List<Particle> particles;
  final List<FeedbackText> feedbacks;
  final Set<int> pressedLanes;

  RhythmPainter({
    required this.time,
    required this.hitZoneY,
    required this.scrollSpeed,
    required this.notes,
    required this.particles,
    required this.feedbacks,
    required this.pressedLanes,
  });

  static const _noteSize = 24.0;
  static const _receptorSize = 26.0;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawBackground(canvas, w, h);
    _drawLanes(canvas, w, h);
    _drawHitZone(canvas, w, h);
    _drawReceptors(canvas, w);
    _drawNotes(canvas, w, h);
    _drawParticles(canvas);
    _drawFeedbacks(canvas);
  }

  // ── 1. Background ──────────────────────────────────────────────────────────

  void _drawBackground(Canvas canvas, double w, double h) {
    // Deep velvet-black with a subtle warm vignette from the top
    final bgPaint =
        Paint()
          ..shader = ui.Gradient.linear(Offset(w / 2, 0), Offset(w / 2, h), [
            const Color(0xFF1A0A08),
            const Color(0xFF0C0505),
          ]);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // Faint vertical "marble" streaks
    final streakPaint =
        Paint()
          ..strokeWidth = 1
          ..color = const Color(0x0AFDF5A9);
    for (double x = 5; x < w; x += 18) {
      canvas.drawLine(Offset(x, 0), Offset(x + 6, h), streakPaint);
    }
  }

  // ── 2. Lanes ───────────────────────────────────────────────────────────────

  void _drawLanes(Canvas canvas, double w, double h) {
    // Subtle lane column shading (alternating faint bands)
    final bandPaint = Paint()..color = const Color(0x08B89947);
    final fracs = laneXFractions;
    final laneW = w * 0.22;
    for (int i = 0; i < fracs.length; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromLTWH(fracs[i] * w - laneW / 2, 0, laneW, h), bandPaint);
      }
    }

    // Ornate lane separators: thin gold hairline + faint outer glow
    for (int i = 0; i < fracs.length; i++) {
      final x = fracs[i] * w;
      final color = laneColors[i];

      // Soft column glow
      final glowPaint =
          Paint()
            ..shader = ui.Gradient.linear(
              Offset(x - 12, 0),
              Offset(x + 12, 0),
              [color.withValues(alpha: 0.0), color.withValues(alpha: 0.06), color.withValues(alpha: 0.0)],
              [0.0, 0.5, 1.0],
            );
      canvas.drawRect(Rect.fromLTWH(x - 12, 0, 24, h), glowPaint);
    }

    // Gold left-edge ornament bar with gradient
    final edgePaint =
        Paint()
          ..shader = ui.Gradient.linear(Offset.zero, const Offset(10, 0), [
            const Color(0xFFB89947),
            const Color(0x00B89947),
          ]);
    canvas.drawRect(Rect.fromLTWH(0, 0, 10, h), edgePaint);

    // Thin divider lines between lanes
    final divPaint =
        Paint()
          ..color = const Color(0x44B89947)
          ..strokeWidth = 0.5;
    // Draw halfway between consecutive lane centres
    final edgeXs = [0.0, 0.275, 0.50, 0.725, 1.0];
    for (final ex in edgeXs) {
      canvas.drawLine(Offset(ex * w, 0), Offset(ex * w, h), divPaint);
    }
  }

  // ── 3. Hit zone ────────────────────────────────────────────────────────────

  void _drawHitZone(Canvas canvas, double w, double h) {
    final hy = hitZoneY;

    // Wide soft glow band
    final glowPaint =
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(0, hy - 40),
            Offset(0, hy + 40),
            [
              const Color(0x00B89947),
              const Color(0x22B89947),
              const Color(0x44B89947),
              const Color(0x22B89947),
              const Color(0x00B89947),
            ],
            [0.0, 0.3, 0.5, 0.7, 1.0],
          );
    canvas.drawRect(Rect.fromLTWH(0, hy - 40, w, 80), glowPaint);

    // Core gold line
    canvas.drawLine(
      Offset(0, hy),
      Offset(w, hy),
      Paint()
        ..color = const Color(0xFFB89947)
        ..strokeWidth = 2,
    );

    // Bright centre flash on top of the line
    final flashPaint =
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(w * 0.2, hy),
            Offset(w * 0.8, hy),
            [const Color(0x00FDF5A9), const Color(0xCCFDF5A9), const Color(0x00FDF5A9)],
            [0.0, 0.5, 1.0],
          )
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.2, hy), Offset(w * 0.8, hy), flashPaint);

    // Below-zone vignette to fade out passed notes
    final fadeGrad =
        Paint()
          ..shader = ui.Gradient.linear(Offset(0, hy + 30), Offset(0, h), [
            const Color(0x00000000),
            const Color(0xDD0C0505),
          ]);
    canvas.drawRect(Rect.fromLTWH(0, hy + 30, w, h - hy - 30), fadeGrad);
  }

  // ── 4. Receptors (static targets) ─────────────────────────────────────────

  void _drawReceptors(Canvas canvas, double w) {
    for (int i = 0; i < 4; i++) {
      final cx = laneXFractions[i] * w;
      final cy = hitZoneY;
      final color = laneColors[i];
      final isPressed = pressedLanes.contains(i);

      // Outer pressed glow
      if (isPressed) {
        canvas.drawCircle(
          Offset(cx, cy),
          _receptorSize * 2.2,
          Paint()
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
            ..color = color.withValues(alpha: 0.55),
        );
      }

      // Receptor outline arrow
      final recPath = _receptorPath(i, cx, cy, _receptorSize);

      // Outer glow
      canvas.drawPath(
        recPath,
        Paint()
          ..maskFilter = MaskFilter.blur(BlurStyle.outer, isPressed ? 14 : 6)
          ..color = color.withValues(alpha: isPressed ? 0.9 : 0.35),
      );

      // Dark fill
      canvas.drawPath(recPath, Paint()..color = const Color(0xFF140808));

      // Stroke outline
      canvas.drawPath(
        recPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isPressed ? 2.5 : 1.5
          ..color = color.withValues(alpha: isPressed ? 1.0 : 0.55),
      );

      // Inner pressed flash fill
      if (isPressed) {
        canvas.drawPath(recPath, Paint()..color = color.withValues(alpha: 0.35));
      }
    }
  }

  // ── 5. Notes ───────────────────────────────────────────────────────────────

  void _drawNotes(Canvas canvas, double w, double h) {
    for (final note in notes) {
      final timeDiff = note.time - time;
      note.y = hitZoneY - (timeDiff * scrollSpeed);
      final durationPx = note.duration * scrollSpeed;
      final tailTopY = note.y - durationPx;

      if (note.y < -60 || tailTopY > h + 60) continue;

      final nx = laneXFractions[note.lane] * w;
      final isDead = note.missed || note.releasedEarly;
      final baseColor = isDead ? const Color(0xFF444444) : laneColors[note.lane];
      final darkColor = isDead ? const Color(0xFF222222) : _laneDark[note.lane];

      // ── Long-note tail ──────────────────────────────────────────────────
      if (note.duration >= 0.3) {
        var tailBottom = note.y;
        final isHeld = note.hit && !note.releasedEarly && time >= note.time;
        if (isHeld) tailBottom = hitZoneY;

        if (tailBottom > tailTopY) {
          final tailAlpha = isHeld ? 0.9 : 0.5;
          final tailW = _noteSize * 0.55;

          // Core tail rectangle with gradient
          canvas.drawRect(
            Rect.fromLTRB(nx - tailW, tailTopY, nx + tailW, tailBottom),
            Paint()
              ..shader = ui.Gradient.linear(
                Offset(nx - tailW, 0),
                Offset(nx + tailW, 0),
                [
                  darkColor.withValues(alpha: tailAlpha * 0.6),
                  baseColor.withValues(alpha: tailAlpha),
                  darkColor.withValues(alpha: tailAlpha * 0.6),
                ],
                [0.0, 0.5, 1.0],
              ),
          );

          // Bright spine down the centre of the tail
          canvas.drawRect(
            Rect.fromLTRB(nx - 2, tailTopY, nx + 2, tailBottom),
            Paint()..color = baseColor.withValues(alpha: tailAlpha * 0.8),
          );

          // Tail glow
          if (!isDead) {
            canvas.drawRect(
              Rect.fromLTRB(nx - tailW - 4, tailTopY, nx + tailW + 4, tailBottom),
              Paint()
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
                ..color = baseColor.withValues(alpha: 0.25),
            );
          }
        }
      }

      // Hide head while note is held
      if (note.hit && time >= note.time && !note.releasedEarly) continue;

      // ── Note head ──────────────────────────────────────────────────────
      final arrowPath = _arrowPath(note.lane, nx, note.y, _noteSize);

      if (!isDead) {
        // Outer halo glow
        canvas.drawPath(
          arrowPath,
          Paint()
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
            ..color = baseColor.withValues(alpha: 0.55),
        );
      }

      // Fill with radial-ish gradient (fake 3-D)
      canvas.drawPath(
        arrowPath,
        Paint()
          ..shader = ui.Gradient.radial(Offset(nx - _noteSize * 0.2, note.y - _noteSize * 0.2), _noteSize * 1.6, [
            isDead ? const Color(0xFF666666) : baseColor,
            darkColor,
          ]),
      );

      // Outline stroke
      canvas.drawPath(
        arrowPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..color = isDead ? const Color(0xFF555555) : baseColor.withValues(alpha: 0.9),
      );

      // Inner highlight slash (gem facet)
      if (!isDead) {
        final hlPath = _arrowHighlight(note.lane, nx, note.y, _noteSize);
        canvas.drawPath(hlPath, Paint()..color = Colors.white.withValues(alpha: 0.45));
      }
    }
  }

  // ── 6. Particles ───────────────────────────────────────────────────────────

  void _drawParticles(Canvas canvas) {
    for (final p in particles) {
      if (p.life <= 0) continue;
      final r = max(0.0, p.size * p.life);
      // Core particle
      canvas.drawCircle(Offset(p.x, p.y), r, Paint()..color = p.color.withValues(alpha: p.life.clamp(0.0, 1.0)));
      // Tiny glow
      if (p.life > 0.4) {
        canvas.drawCircle(
          Offset(p.x, p.y),
          r * 2,
          Paint()
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
            ..color = p.color.withValues(alpha: p.life * 0.3),
        );
      }
    }
  }

  // ── 7. Feedback texts ──────────────────────────────────────────────────────

  void _drawFeedbacks(Canvas canvas) {
    for (final f in feedbacks) {
      if (f.life <= 0) continue;
      final alpha = f.life.clamp(0.0, 1.0);

      // Shadow
      final shadow = TextPainter(
        text: TextSpan(
          text: f.text,
          style: TextStyle(
            color: Colors.black.withValues(alpha: alpha * 0.8),
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      shadow.paint(canvas, Offset(f.x - shadow.width / 2 + 2, f.y + 2));

      // Main text
      final tp = TextPainter(
        text: TextSpan(
          text: f.text,
          style: TextStyle(
            color: f.color.withValues(alpha: alpha),
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(f.x - tp.width / 2, f.y));
    }
  }

  @override
  bool shouldRepaint(RhythmPainter old) => true;
}
