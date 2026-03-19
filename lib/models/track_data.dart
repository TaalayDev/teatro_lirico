import 'dart:ui';
import 'game_models.dart';

// ─── Lane guide (noteName[0].codeUnit % 4) ────────────────────
//  Lane 0 → D  (68 % 4 == 0)
//  Lane 1 → A, E  (65 % 4 == 1, 69 % 4 == 1)
//  Lane 2 → B, F  (66 % 4 == 2, 70 % 4 == 2)
//  Lane 3 → C, G  (67 % 4 == 3, 71 % 4 == 3)

const tracks = <Track>[
  // ─── Act I · La Notte Tragica ── D minor, 70 BPM, EASY · CLASSIC ─
  // Slow mournful soprano aria.  Half + quarter notes, sparse rhythm.
  Track(
    name: 'La Notte Tragica',
    bpm: 70,
    loops: 4,
    color: Color(0xFFC1121F),
    theme: StageTheme.classic,
    melody: [
      MelodyEvent('0:0', 'D5', '2n'), // lane 0
      MelodyEvent('0:2', 'F5', '4n'), // lane 2
      MelodyEvent('0:3', 'A5', '4n'), // lane 1
      MelodyEvent('1:0', 'Bb5', '2n'), // lane 2
      MelodyEvent('1:2', 'A5', '2n'), // lane 1
      MelodyEvent('2:0', 'G5', '4n'), // lane 3
      MelodyEvent('2:1', 'F5', '4n'), // lane 2
      MelodyEvent('2:2', 'E5', '4n'), // lane 1
      MelodyEvent('2:3', 'D5', '4n'), // lane 0
      MelodyEvent('3:0', 'F5', '2n'), // lane 2
      MelodyEvent('3:2', 'D5', '2n'), // lane 0
    ],
    chords: [
      ChordEvent('0:0', ['D3', 'F3', 'A3', 'D4'], '1m'), // Dm
      ChordEvent('1:0', ['G2', 'D3', 'G3', 'Bb3'], '1m'), // Gm
      ChordEvent('2:0', ['A2', 'C#3', 'E3', 'G3'], '1m'), // A7
      ChordEvent('3:0', ['D3', 'F3', 'A3', 'D4'], '1m'), // Dm
    ],
    brass: [
      BrassEvent('0:0', ['D2', 'A2'], '2n'),
      BrassEvent('0:2', ['F2', 'C3'], '2n'),
      BrassEvent('1:0', ['G2', 'D3'], '1m'),
      BrassEvent('2:0', ['A1', 'E2', 'C#3'], '1m'),
      BrassEvent('3:0', ['D2', 'A2'], '1m'),
    ],
    timpani: ['0:0', '1:0', '2:0', '3:0'],
  ),

  // ─── Act II · Amore Eterno ── Eb major, 76 BPM, EASY-MED · CLASSIC
  // Lyrical love theme.  Ascending arpeggios, yearning leaps.
  Track(
    name: 'Amore Eterno',
    bpm: 76,
    loops: 4,
    color: Color(0xFFFDF5A9),
    theme: StageTheme.classic,
    melody: [
      MelodyEvent('0:0', 'Eb4', '4n'), // lane 1
      MelodyEvent('0:1', 'G4', '4n'), // lane 3
      MelodyEvent('0:2', 'Bb4', '4n'), // lane 2
      MelodyEvent('0:3', 'Eb5', '4n'), // lane 1
      MelodyEvent('1:0', 'F5', '2n'), // lane 2
      MelodyEvent('1:2', 'Eb5', '4n'), // lane 1
      MelodyEvent('1:3', 'Db5', '4n'), // lane 0
      MelodyEvent('2:0', 'C5', '4n'), // lane 3
      MelodyEvent('2:1', 'Bb4', '4n'), // lane 2
      MelodyEvent('2:2', 'Ab4', '2n'), // lane 1
      MelodyEvent('3:0', 'G4', '4n'), // lane 3
      MelodyEvent('3:1', 'Bb4', '4n'), // lane 2
      MelodyEvent('3:2', 'Eb5', '2n'), // lane 1
    ],
    chords: [
      ChordEvent('0:0', ['Eb3', 'G3', 'Bb3', 'Eb4'], '1m'), // Eb
      ChordEvent('1:0', ['Ab2', 'Eb3', 'Ab3', 'C4'], '1m'), // Ab
      ChordEvent('2:0', ['Bb2', 'F3', 'Ab3', 'Db4'], '1m'), // Bb7
      ChordEvent('3:0', ['Eb3', 'G3', 'Bb3', 'Eb4'], '1m'), // Eb
    ],
    brass: [
      BrassEvent('0:0', ['Eb2', 'Bb2', 'Eb3'], '1m'),
      BrassEvent('1:0', ['Ab1', 'Eb2', 'Ab2'], '1m'),
      BrassEvent('2:0', ['Bb1', 'F2', 'Bb2'], '1m'),
      BrassEvent('3:0', ['Eb2', 'Bb2', 'Eb3'], '1m'),
    ],
    timpani: ['0:0', '2:0'],
  ),

  // ─── La Serenata ── F major, 80 BPM, EASY-MED · CLASSIC ────────────────────
  // A graceful serenade bridging the two easy acts.  Flowing phrases with
  // lyrical leaps, a long half-note sigh in m1, and a gentle closing cascade.
  Track(
    name: 'La Serenata',
    bpm: 80,
    loops: 4,
    color: Color(0xFF4CC9A0), // soft teal — warmth of an evening garden
    theme: StageTheme.classic,
    melody: [
      MelodyEvent('0:0', 'F5', '4n'), // lane 2
      MelodyEvent('0:1', 'A5', '4n'), // lane 1
      MelodyEvent('0:2', 'C6', '4n'), // lane 3
      MelodyEvent('0:3', 'A5', '4n'), // lane 1
      MelodyEvent('1:0', 'G5', '4n'), // lane 3
      MelodyEvent('1:1', 'F5', '2n'), // lane 2  (held sigh — 2 beats)
      MelodyEvent('1:3', 'D5', '4n'), // lane 0
      MelodyEvent('2:0', 'E5', '4n'), // lane 1
      MelodyEvent('2:1', 'G5', '4n'), // lane 3
      MelodyEvent('2:2', 'Bb5', '4n'), // lane 2
      MelodyEvent('2:3', 'A5', '4n'), // lane 1
      MelodyEvent('3:0', 'C6', '4n'), // lane 3
      MelodyEvent('3:1', 'Bb5', '4n'), // lane 2
      MelodyEvent('3:2', 'A5', '4n'), // lane 1
      MelodyEvent('3:3', 'F5', '4n'), // lane 2
    ],
    chords: [
      ChordEvent('0:0', ['F3', 'A3', 'C4', 'F4'], '1m'), // F
      ChordEvent('1:0', ['D3', 'F3', 'A3', 'D4'], '1m'), // Dm
      ChordEvent('2:0', ['Bb2', 'D3', 'F3', 'Bb3'], '1m'), // Bb
      ChordEvent('3:0', ['C3', 'E3', 'G3', 'Bb3'], '1m'), // C7
    ],
    brass: [
      BrassEvent('0:0', ['F2', 'C3', 'F3'], '1m'),
      BrassEvent('1:0', ['D2', 'A2', 'D3'], '1m'),
      BrassEvent('2:0', ['Bb1', 'F2', 'Bb2'], '1m'),
      BrassEvent('3:0', ['C2', 'G2', 'C3'], '1m'),
    ],
    timpani: ['0:0', '2:0'],
  ),

  // ─── Act III · Sotto La Luna ── G minor, 84 BPM, MEDIUM · CLASSIC ──
  // A moonlit bridge act with smoother phrasing and wider melodic arcs.
  Track(
    name: 'Sotto La Luna',
    bpm: 84,
    loops: 4,
    color: Color(0xFF8D99AE),
    theme: StageTheme.classic,
    melody: [
      MelodyEvent('0:0', 'G4', '4n'),
      MelodyEvent('0:1', 'Bb4', '4n'),
      MelodyEvent('0:2', 'D5', '2n'),
      MelodyEvent('1:0', 'F5', '4n'),
      MelodyEvent('1:1', 'Eb5', '4n'),
      MelodyEvent('1:2', 'D5', '4n'),
      MelodyEvent('1:3', 'Bb4', '4n'),
      MelodyEvent('2:0', 'A4', '4n'),
      MelodyEvent('2:1', 'C5', '4n'),
      MelodyEvent('2:2', 'D5', '2n'),
      MelodyEvent('3:0', 'G5', '4n'),
      MelodyEvent('3:1', 'F5', '4n'),
      MelodyEvent('3:2', 'D5', '2n'),
    ],
    chords: [
      ChordEvent('0:0', ['G3', 'Bb3', 'D4', 'G4'], '1m'),
      ChordEvent('1:0', ['Eb3', 'G3', 'Bb3', 'Eb4'], '1m'),
      ChordEvent('2:0', ['C3', 'Eb3', 'G3', 'C4'], '1m'),
      ChordEvent('3:0', ['D3', 'F#3', 'A3', 'D4'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['G2', 'D3', 'G3'], '2n'),
      BrassEvent('0:2', ['Bb2', 'D3'], '2n'),
      BrassEvent('1:0', ['Eb2', 'Bb2', 'Eb3'], '1m'),
      BrassEvent('2:0', ['C2', 'G2', 'C3'], '1m'),
      BrassEvent('3:0', ['D2', 'A2', 'D3'], '1m'),
    ],
    timpani: ['0:0', '1:2', '3:0'],
  ),

  // ─── Act III · Il Giudizio ── G minor, 90 BPM, MEDIUM · GOTHIC ──
  // Judgment day.  Driving quarter notes across all 4 lanes.
  Track(
    name: 'Il Giudizio',
    bpm: 90,
    loops: 4,
    color: Color(0xFFE07A5F),
    theme: StageTheme.gothic,
    melody: [
      MelodyEvent('0:0', 'G5', '4n'), // lane 3
      MelodyEvent('0:1', 'Bb5', '4n'), // lane 2
      MelodyEvent('0:2', 'D6', '4n'), // lane 0
      MelodyEvent('0:3', 'Eb6', '4n'), // lane 1
      MelodyEvent('1:0', 'D6', '4n'), // lane 0
      MelodyEvent('1:1', 'C6', '4n'), // lane 3
      MelodyEvent('1:2', 'Bb5', '4n'), // lane 2
      MelodyEvent('1:3', 'A5', '4n'), // lane 1
      MelodyEvent('2:0', 'Bb5', '4n'), // lane 2
      MelodyEvent('2:1', 'G5', '4n'), // lane 3
      MelodyEvent('2:2', 'F5', '4n'), // lane 2
      MelodyEvent('2:3', 'Eb5', '4n'), // lane 1
      MelodyEvent('3:0', 'D5', '2n'), // lane 0
      MelodyEvent('3:2', 'G5', '2n'), // lane 3
    ],
    chords: [
      ChordEvent('0:0', ['G3', 'Bb3', 'D4', 'G4'], '1m'), // Gm
      ChordEvent('1:0', ['C3', 'Eb3', 'G3', 'C4'], '1m'), // Cm
      ChordEvent('2:0', ['Eb3', 'G3', 'Bb3', 'Eb4'], '1m'), // Eb
      ChordEvent('3:0', ['D3', 'F#3', 'A3', 'D4'], '1m'), // D (V)
    ],
    brass: [
      BrassEvent('0:0', ['G1', 'D2', 'G2'], '4n'),
      BrassEvent('0:2', ['G1', 'Bb1', 'D2'], '4n'),
      BrassEvent('1:0', ['C2', 'G2', 'C3'], '2n'),
      BrassEvent('1:2', ['C2', 'Eb2', 'G2'], '2n'),
      BrassEvent('2:0', ['Eb2', 'Bb2'], '2n'),
      BrassEvent('2:2', ['Eb2', 'G2'], '2n'),
      BrassEvent('3:0', ['D2', 'A2', 'D3'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '1:2', '2:0', '3:0'],
  ),

  // ─── Act IV · La Vendetta ── A minor, 104 BPM, MED-HARD · GOTHIC ─
  // Revenge aria.  All quarter notes, rapid lane changes, dense.
  Track(
    name: 'La Vendetta',
    bpm: 104,
    loops: 5,
    color: Color(0xFF7C3AED),
    theme: StageTheme.gothic,
    melody: [
      MelodyEvent('0:0', 'A4', '4n'), // lane 1
      MelodyEvent('0:1', 'C5', '4n'), // lane 3
      MelodyEvent('0:2', 'E5', '4n'), // lane 1
      MelodyEvent('0:3', 'A5', '4n'), // lane 1
      MelodyEvent('1:0', 'B5', '4n'), // lane 2
      MelodyEvent('1:1', 'A5', '4n'), // lane 1
      MelodyEvent('1:2', 'G5', '4n'), // lane 3
      MelodyEvent('1:3', 'F5', '4n'), // lane 2
      MelodyEvent('2:0', 'E5', '4n'), // lane 1
      MelodyEvent('2:1', 'D5', '4n'), // lane 0
      MelodyEvent('2:2', 'C5', '4n'), // lane 3
      MelodyEvent('2:3', 'B4', '4n'), // lane 2
      MelodyEvent('3:0', 'A4', '4n'), // lane 1
      MelodyEvent('3:1', 'E5', '4n'), // lane 1
      MelodyEvent('3:2', 'G5', '4n'), // lane 3
      MelodyEvent('3:3', 'A5', '4n'), // lane 1
    ],
    chords: [
      ChordEvent('0:0', ['A2', 'E3', 'A3', 'C4'], '1m'), // Am
      ChordEvent('1:0', ['F2', 'A2', 'C3', 'F3'], '1m'), // F
      ChordEvent('2:0', ['C2', 'E3', 'G3', 'C4'], '1m'), // C
      ChordEvent('3:0', ['E2', 'B2', 'E3', 'G#3'], '1m'), // E (V)
    ],
    brass: [
      BrassEvent('0:0', ['A1', 'E2', 'A2'], '4n'),
      BrassEvent('0:2', ['A1', 'C2', 'E2'], '4n'),
      BrassEvent('1:0', ['F1', 'C2', 'F2'], '2n'),
      BrassEvent('1:2', ['F1', 'A1', 'C2'], '2n'),
      BrassEvent('2:0', ['C2', 'G2', 'C3'], '2n'),
      BrassEvent('2:2', ['C2', 'E2', 'G2'], '2n'),
      BrassEvent('3:0', ['E1', 'B1', 'E2', 'G#2'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '1:2', '2:0', '2:2', '3:0', '3:2'],
  ),

  // ─── La Tempesta ── E minor, 107 BPM, MED-HARD · GOTHIC ────────────────────
  // A squalling storm aria.  Relentless quarter-note drive, wide lane leaps,
  // and an Em→C→G→Am descent that builds intensity toward the hard acts.
  Track(
    name: 'La Tempesta',
    bpm: 107,
    loops: 5,
    color: Color(0xFF3D56B2), // thundercloud blue
    theme: StageTheme.gothic,
    melody: [
      MelodyEvent('0:0', 'G5', '4n'), // lane 3
      MelodyEvent('0:1', 'E5', '4n'), // lane 1
      MelodyEvent('0:2', 'D5', '4n'), // lane 0
      MelodyEvent('0:3', 'G5', '4n'), // lane 3
      MelodyEvent('1:0', 'B5', '4n'), // lane 2
      MelodyEvent('1:1', 'A5', '4n'), // lane 1
      MelodyEvent('1:2', 'G5', '4n'), // lane 3
      MelodyEvent('1:3', 'F#5', '4n'), // lane 2
      MelodyEvent('2:0', 'E5', '4n'), // lane 1
      MelodyEvent('2:1', 'G5', '4n'), // lane 3
      MelodyEvent('2:2', 'A5', '4n'), // lane 1
      MelodyEvent('2:3', 'B5', '4n'), // lane 2
      MelodyEvent('3:0', 'C6', '4n'), // lane 3
      MelodyEvent('3:1', 'B5', '4n'), // lane 2
      MelodyEvent('3:2', 'A5', '4n'), // lane 1
      MelodyEvent('3:3', 'E5', '4n'), // lane 1
    ],
    chords: [
      ChordEvent('0:0', ['E3', 'G3', 'B3', 'E4'], '1m'), // Em
      ChordEvent('1:0', ['C3', 'E3', 'G3', 'C4'], '1m'), // C
      ChordEvent('2:0', ['G3', 'B3', 'D4', 'G4'], '1m'), // G
      ChordEvent('3:0', ['A2', 'E3', 'A3', 'C4'], '1m'), // Am
    ],
    brass: [
      BrassEvent('0:0', ['E2', 'B2', 'E3'], '2n'),
      BrassEvent('0:2', ['G2', 'D3'], '2n'),
      BrassEvent('1:0', ['C2', 'G2', 'C3'], '2n'),
      BrassEvent('1:2', ['C2', 'E2', 'G2'], '2n'),
      BrassEvent('2:0', ['G2', 'D3', 'G3'], '2n'),
      BrassEvent('2:2', ['G2', 'B2', 'D3'], '2n'),
      BrassEvent('3:0', ['A2', 'E3', 'A3'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '1:2', '2:0', '2:2', '3:0', '3:2'],
  ),

  // ─── Act VI · Ballo delle Maschere ── C minor, 110 BPM, HARD · GOTHIC ──
  // A tense masked dance with alternating leaps and response phrases.
  Track(
    name: 'Ballo delle Maschere',
    bpm: 110,
    loops: 4,
    color: Color(0xFFC084FC),
    theme: StageTheme.gothic,
    melody: [
      MelodyEvent('0:0', 'C5', '4n'),
      MelodyEvent('0:1', 'Eb5', '4n'),
      MelodyEvent('0:2', 'G5', '4n'),
      MelodyEvent('0:3', 'Bb5', '4n'),
      MelodyEvent('1:0', 'Ab5', '4n'),
      MelodyEvent('1:1', 'G5', '4n'),
      MelodyEvent('1:2', 'F5', '4n'),
      MelodyEvent('1:3', 'Eb5', '4n'),
      MelodyEvent('2:0', 'D5', '4n'),
      MelodyEvent('2:1', 'F5', '4n'),
      MelodyEvent('2:2', 'G5', '4n'),
      MelodyEvent('2:3', 'Ab5', '4n'),
      MelodyEvent('3:0', 'G5', '4n'),
      MelodyEvent('3:1', 'F5', '4n'),
      MelodyEvent('3:2', 'Eb5', '4n'),
      MelodyEvent('3:3', 'C5', '4n'),
    ],
    chords: [
      ChordEvent('0:0', ['C3', 'Eb3', 'G3', 'C4'], '1m'),
      ChordEvent('1:0', ['Ab2', 'C3', 'Eb3', 'Ab3'], '1m'),
      ChordEvent('2:0', ['F2', 'Ab2', 'C3', 'F3'], '1m'),
      ChordEvent('3:0', ['G2', 'B2', 'D3', 'F3'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['C2', 'G2', 'C3'], '2n'),
      BrassEvent('0:2', ['Eb2', 'G2'], '2n'),
      BrassEvent('1:0', ['Ab1', 'Eb2', 'Ab2'], '2n'),
      BrassEvent('2:0', ['F1', 'C2', 'F2'], '2n'),
      BrassEvent('3:0', ['G1', 'D2', 'G2'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '2:0', '3:0'],
  ),

  // ─── Act V · Il Trionfo ── D major, 116 BPM, HARD · STEAMPUNK ───
  // Triumphant finale.  Fast scale runs, syncopated rhythms.
  Track(
    name: 'Il Trionfo',
    bpm: 116,
    loops: 5,
    color: Color(0xFFF59E0B),
    theme: StageTheme.steampunk,
    melody: [
      MelodyEvent('0:0', 'D5', '4n'), // lane 0
      MelodyEvent('0:1', 'F#5', '4n'), // lane 2 (F→2)
      MelodyEvent('0:2', 'A5', '4n'), // lane 1
      MelodyEvent('0:3', 'D6', '4n'), // lane 0
      MelodyEvent('1:0', 'E6', '4n'), // lane 1
      MelodyEvent('1:1', 'D6', '4n'), // lane 0
      MelodyEvent('1:2', 'B5', '4n'), // lane 2
      MelodyEvent('1:3', 'G5', '4n'), // lane 3
      MelodyEvent('2:0', 'F#5', '4n'), // lane 2
      MelodyEvent('2:1', 'E5', '4n'), // lane 1
      MelodyEvent('2:2', 'D5', '4n'), // lane 0
      MelodyEvent('2:3', 'C#5', '4n'), // lane 3 (C→3)
      MelodyEvent('3:0', 'B4', '4n'), // lane 2
      MelodyEvent('3:1', 'G4', '4n'), // lane 3
      MelodyEvent('3:2', 'A4', '4n'), // lane 1
      MelodyEvent('3:3', 'D5', '4n'), // lane 0
    ],
    chords: [
      ChordEvent('0:0', ['D3', 'F#3', 'A3', 'D4'], '1m'), // D
      ChordEvent('1:0', ['A2', 'E3', 'A3', 'C#4'], '1m'), // A
      ChordEvent('2:0', ['B2', 'D3', 'F#3', 'B3'], '1m'), // Bm
      ChordEvent('3:0', ['G2', 'D3', 'G3', 'B3'], '1m'), // G
    ],
    brass: [
      BrassEvent('0:0', ['D2', 'A2', 'D3'], '2n'),
      BrassEvent('0:2', ['D2', 'F#2', 'A2'], '2n'),
      BrassEvent('1:0', ['A1', 'E2', 'A2', 'C#3'], '2n'),
      BrassEvent('1:2', ['A1', 'C#2', 'E2'], '2n'),
      BrassEvent('2:0', ['B1', 'F#2', 'B2', 'D3'], '2n'),
      BrassEvent('2:2', ['B1', 'D2', 'F#2'], '2n'),
      BrassEvent('3:0', ['G1', 'D2', 'G2', 'B2'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '1:2', '2:0', '2:2', '3:0', '3:2'],
  ),

  // ─── L'Alba di Ferro ── F# minor, 122 BPM, HARD+ · STEAMPUNK ───────────────
  // Iron dawn — an industrial ascent.  Ascending/descending F# minor runs
  // with 10 timpani hits and punchy brass every half-measure.  Bridges the
  // hard acts into the relentless very-hard territory.
  Track(
    name: "L'Alba di Ferro",
    bpm: 122,
    loops: 5,
    color: Color(0xFFD4773A), // hammered copper
    theme: StageTheme.steampunk,
    melody: [
      MelodyEvent('0:0', 'F#5', '4n'), // lane 2
      MelodyEvent('0:1', 'A5', '4n'), // lane 1
      MelodyEvent('0:2', 'C#6', '4n'), // lane 3
      MelodyEvent('0:3', 'E6', '4n'), // lane 1
      MelodyEvent('1:0', 'D6', '4n'), // lane 0
      MelodyEvent('1:1', 'C#6', '4n'), // lane 3
      MelodyEvent('1:2', 'B5', '4n'), // lane 2
      MelodyEvent('1:3', 'A5', '4n'), // lane 1
      MelodyEvent('2:0', 'G#5', '4n'), // lane 3
      MelodyEvent('2:1', 'B5', '4n'), // lane 2
      MelodyEvent('2:2', 'D6', '4n'), // lane 0
      MelodyEvent('2:3', 'A5', '4n'), // lane 1
      MelodyEvent('3:0', 'E6', '4n'), // lane 1
      MelodyEvent('3:1', 'C#6', '4n'), // lane 3
      MelodyEvent('3:2', 'A5', '4n'), // lane 1
      MelodyEvent('3:3', 'F#5', '4n'), // lane 2
    ],
    chords: [
      ChordEvent('0:0', ['F#3', 'A3', 'C#4', 'F#4'], '1m'), // F#m
      ChordEvent('1:0', ['D3', 'F#3', 'A3', 'D4'], '1m'), // D
      ChordEvent('2:0', ['A2', 'E3', 'A3', 'C#4'], '1m'), // A
      ChordEvent('3:0', ['E3', 'G#3', 'B3', 'E4'], '1m'), // E
    ],
    brass: [
      BrassEvent('0:0', ['F#2', 'C#3', 'F#3'], '2n'),
      BrassEvent('0:2', ['A2', 'E3'], '2n'),
      BrassEvent('1:0', ['D2', 'A2', 'D3'], '2n'),
      BrassEvent('1:2', ['D2', 'F#2', 'A2'], '2n'),
      BrassEvent('2:0', ['A1', 'E2', 'A2'], '2n'),
      BrassEvent('2:2', ['A1', 'C#2', 'E2'], '2n'),
      BrassEvent('3:0', ['E2', 'B2', 'E3', 'G#3'], '1m'),
    ],
    timpani: [
      '0:0',
      '0:1',
      '0:2',
      '1:0',
      '1:2',
      '2:0',
      '2:1',
      '2:2',
      '3:0',
      '3:2',
    ],
  ),

  // ─── Act VI · La Caduta degli Dei ── B minor, 130 BPM, VERY HARD · STEAMPUNK
  // Maximum difficulty: relentless scale ascent + descent, dense chords,
  // percussion on every beat.  Requires rapid accurate lane switching.
  Track(
    name: 'La Caduta degli Dei',
    bpm: 130,
    loops: 6,
    color: Color(0xFF1E3A5F),
    theme: StageTheme.steampunk,
    melody: [
      // Ascending B-minor scale — measure 0
      MelodyEvent('0:0', 'B4', '4n'), // lane 2
      MelodyEvent('0:1', 'C#5', '4n'), // lane 3
      MelodyEvent('0:2', 'D5', '4n'), // lane 0
      MelodyEvent('0:3', 'E5', '4n'), // lane 1
      // Continuing ascent + counterpoint — measure 1
      MelodyEvent('1:0', 'F#5', '4n'), // lane 2
      MelodyEvent('1:1', 'G5', '4n'), // lane 3
      MelodyEvent('1:2', 'A5', '4n'), // lane 1
      MelodyEvent('1:3', 'B5', '4n'), // lane 2
      // Descending — measure 2
      MelodyEvent('2:0', 'C#6', '4n'), // lane 3
      MelodyEvent('2:1', 'B5', '4n'), // lane 2
      MelodyEvent('2:2', 'A5', '4n'), // lane 1
      MelodyEvent('2:3', 'G5', '4n'), // lane 3
      // Final drive — measure 3
      MelodyEvent('3:0', 'F#5', '4n'), // lane 2
      MelodyEvent('3:1', 'E5', '4n'), // lane 1
      MelodyEvent('3:2', 'D5', '4n'), // lane 0
      MelodyEvent('3:3', 'B4', '4n'), // lane 2
    ],
    chords: [
      ChordEvent('0:0', ['B2', 'D3', 'F#3', 'B3'], '2n'), // Bm
      ChordEvent('0:2', ['B2', 'D3', 'F#3', 'A3'], '2n'), // Bm7
      ChordEvent('1:0', ['G2', 'D3', 'G3', 'B3'], '2n'), // G
      ChordEvent('1:2', ['D2', 'F#2', 'A2', 'D3'], '2n'), // D
      ChordEvent('2:0', ['A2', 'E3', 'A3', 'C#4'], '2n'), // A
      ChordEvent('2:2', ['F#2', 'C#3', 'F#3', 'A3'], '2n'), // F#m
      ChordEvent('3:0', ['G2', 'D3', 'G3', 'B3'], '2n'), // G
      ChordEvent('3:2', ['F#2', 'C#3', 'F#3', 'A#3'], '2n'), // F#7
    ],
    brass: [
      BrassEvent('0:0', ['B1', 'F#2', 'B2'], '4n'),
      BrassEvent('0:1', ['B1', 'D2', 'F#2'], '4n'),
      BrassEvent('0:2', ['B1', 'F#2', 'A2'], '4n'),
      BrassEvent('0:3', ['B1', 'D2', 'F#2'], '4n'),
      BrassEvent('1:0', ['G1', 'D2', 'G2'], '4n'),
      BrassEvent('1:1', ['G1', 'B1', 'D2'], '4n'),
      BrassEvent('1:2', ['D1', 'A1', 'D2'], '4n'),
      BrassEvent('1:3', ['D1', 'F#1', 'A1'], '4n'),
      BrassEvent('2:0', ['A1', 'E2', 'A2'], '4n'),
      BrassEvent('2:2', ['F#1', 'C#2', 'F#2'], '4n'),
      BrassEvent('3:0', ['G1', 'D2', 'G2'], '4n'),
      BrassEvent('3:2', ['F#1', 'C#2', 'F#2', 'A#2'], '4n'),
    ],
    timpani: [
      '0:0',
      '0:1',
      '0:2',
      '0:3',
      '1:0',
      '1:1',
      '1:2',
      '1:3',
      '2:0',
      '2:2',
      '3:0',
      '3:2',
    ],
  ),

  // ─── Act IX · Marcia degli Astri ── E minor, 134 BPM, VERY HARD · CLASSIC ──
  // A rising march that bridges the late-game acts with cleaner heroic motion.
  Track(
    name: 'Marcia degli Astri',
    bpm: 134,
    loops: 4,
    color: Color(0xFF67E8F9),
    theme: StageTheme.classic,
    melody: [
      MelodyEvent('0:0', 'E5', '4n'),
      MelodyEvent('0:1', 'B5', '4n'),
      MelodyEvent('0:2', 'G5', '4n'),
      MelodyEvent('0:3', 'E6', '4n'),
      MelodyEvent('1:0', 'D6', '4n'),
      MelodyEvent('1:1', 'B5', '4n'),
      MelodyEvent('1:2', 'A5', '4n'),
      MelodyEvent('1:3', 'G5', '4n'),
      MelodyEvent('2:0', 'F#5', '4n'),
      MelodyEvent('2:1', 'A5', '4n'),
      MelodyEvent('2:2', 'B5', '4n'),
      MelodyEvent('2:3', 'D6', '4n'),
      MelodyEvent('3:0', 'E6', '4n'),
      MelodyEvent('3:1', 'D6', '4n'),
      MelodyEvent('3:2', 'B5', '4n'),
      MelodyEvent('3:3', 'E5', '4n'),
    ],
    chords: [
      ChordEvent('0:0', ['E3', 'G3', 'B3', 'E4'], '1m'),
      ChordEvent('1:0', ['D3', 'F#3', 'A3', 'D4'], '1m'),
      ChordEvent('2:0', ['G3', 'B3', 'D4', 'G4'], '1m'),
      ChordEvent('3:0', ['B2', 'D#3', 'F#3', 'A3'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['E2', 'B2', 'E3'], '2n'),
      BrassEvent('0:2', ['G2', 'B2'], '2n'),
      BrassEvent('1:0', ['D2', 'A2', 'D3'], '2n'),
      BrassEvent('2:0', ['G2', 'D3', 'G3'], '2n'),
      BrassEvent('3:0', ['B1', 'F#2', 'B2'], '1m'),
    ],
    timpani: ['0:0', '1:0', '2:0', '3:0'],
  ),

  // ─── Act VII · La Resurrezione ── E minor, 138 BPM, EXTREME · CLASSIC ─────
  // Resurrection.  Heroic ascending runs, syncopated offbeats, all 4 lanes.
  Track(
    name: 'La Resurrezione',
    bpm: 138,
    loops: 6,
    color: Color(0xFFDC2626),
    theme: StageTheme.classic,
    melody: [
      MelodyEvent('0:0', 'E5', '4n'), // lane 1
      MelodyEvent('0:1', 'G5', '4n'), // lane 3
      MelodyEvent('0:2', 'B5', '4n'), // lane 2
      MelodyEvent('0:3', 'D6', '4n'), // lane 0
      MelodyEvent('1:0', 'C6', '4n'), // lane 3
      MelodyEvent('1:1', 'B5', '4n'), // lane 2
      MelodyEvent('1:2', 'A5', '4n'), // lane 1
      MelodyEvent('1:3', 'G5', '4n'), // lane 3
      MelodyEvent('2:0', 'F#5', '4n'), // lane 2
      MelodyEvent('2:1', 'G5', '4n'), // lane 3
      MelodyEvent('2:2', 'A5', '4n'), // lane 1
      MelodyEvent('2:3', 'B5', '4n'), // lane 2
      MelodyEvent('3:0', 'C6', '4n'), // lane 3
      MelodyEvent('3:1', 'D6', '4n'), // lane 0
      MelodyEvent('3:2', 'E6', '4n'), // lane 1
      MelodyEvent('3:3', 'B5', '4n'), // lane 2
    ],
    chords: [
      ChordEvent('0:0', ['E3', 'G3', 'B3', 'E4'], '1m'), // Em
      ChordEvent('1:0', ['A2', 'E3', 'A3', 'C4'], '1m'), // Am
      ChordEvent('2:0', ['C3', 'E3', 'G3', 'C4'], '1m'), // C
      ChordEvent('3:0', ['B2', 'D#3', 'F#3', 'A3'], '1m'), // B7
    ],
    brass: [
      BrassEvent('0:0', ['B2', 'E3', 'G3'], '4n'),
      BrassEvent('0:2', ['G2', 'D3', 'G3'], '4n'),
      BrassEvent('1:0', ['A2', 'E3', 'A3'], '2n'),
      BrassEvent('1:2', ['A2', 'C3', 'E3'], '2n'),
      BrassEvent('2:0', ['C3', 'G3', 'C4'], '2n'),
      BrassEvent('2:2', ['C3', 'E3', 'G3'], '2n'),
      BrassEvent('3:0', ['B2', 'F#3', 'B3', 'D#4'], '1m'),
    ],
    timpani: [
      '0:0',
      '0:1',
      '0:2',
      '0:3',
      '1:0',
      '1:2',
      '2:0',
      '2:2',
      '3:0',
      '3:1',
      '3:2',
      '3:3',
    ],
  ),

  // ─── Act VIII · Il Crepuscolo ── C# minor, 146 BPM, NIGHTMARE · GOTHIC ────
  // Twilight of the gods.  Relentless chromatic descent across all lanes.
  Track(
    name: 'Il Crepuscolo',
    bpm: 146,
    loops: 6,
    color: Color(0xFF7C2D8E),
    theme: StageTheme.gothic,
    melody: [
      MelodyEvent('0:0', 'C#6', '4n'), // lane 3
      MelodyEvent('0:1', 'B5', '4n'), // lane 2
      MelodyEvent('0:2', 'A5', '4n'), // lane 1
      MelodyEvent('0:3', 'G#5', '4n'), // lane 3
      MelodyEvent('1:0', 'F#5', '4n'), // lane 2
      MelodyEvent('1:1', 'E5', '4n'), // lane 1
      MelodyEvent('1:2', 'D#5', '4n'), // lane 0
      MelodyEvent('1:3', 'C#5', '4n'), // lane 3
      MelodyEvent('2:0', 'D#5', '4n'), // lane 0
      MelodyEvent('2:1', 'F#5', '4n'), // lane 2
      MelodyEvent('2:2', 'G#5', '4n'), // lane 3
      MelodyEvent('2:3', 'A5', '4n'), // lane 1
      MelodyEvent('3:0', 'B5', '4n'), // lane 2
      MelodyEvent('3:1', 'C#6', '4n'), // lane 3
      MelodyEvent('3:2', 'B5', '4n'), // lane 2
      MelodyEvent('3:3', 'G#5', '4n'), // lane 3
    ],
    chords: [
      ChordEvent('0:0', ['C#3', 'E3', 'G#3', 'C#4'], '1m'), // C#m
      ChordEvent('1:0', ['A2', 'E3', 'A3', 'C#4'], '1m'), // A
      ChordEvent('2:0', ['E3', 'G#3', 'B3', 'E4'], '1m'), // E
      ChordEvent('3:0', ['B2', 'D#3', 'F#3', 'B3'], '1m'), // B
    ],
    brass: [
      BrassEvent('0:0', ['C#2', 'G#2', 'C#3'], '4n'),
      BrassEvent('0:2', ['C#2', 'E2', 'G#2'], '4n'),
      BrassEvent('1:0', ['A1', 'E2', 'A2'], '2n'),
      BrassEvent('1:2', ['A1', 'C#2', 'E2'], '2n'),
      BrassEvent('2:0', ['E2', 'B2', 'E3'], '2n'),
      BrassEvent('2:2', ['E2', 'G#2', 'B2'], '2n'),
      BrassEvent('3:0', ['B1', 'F#2', 'B2', 'D#3'], '1m'),
    ],
    timpani: [
      '0:0',
      '0:1',
      '0:2',
      '0:3',
      '1:0',
      '1:1',
      '1:2',
      '1:3',
      '2:0',
      '2:1',
      '2:2',
      '2:3',
      '3:0',
      '3:1',
      '3:2',
      '3:3',
    ],
  ),

  // ─── Act XII · Cuore di Bronzo ── D minor, 150 BPM, NIGHTMARE · STEAMPUNK ──
  // A forged-metal sprint with direct phrases and aggressive cadence pushes.
  Track(
    name: 'Cuore di Bronzo',
    bpm: 150,
    loops: 4,
    color: Color(0xFFB45309),
    theme: StageTheme.steampunk,
    melody: [
      MelodyEvent('0:0', 'D5', '4n'),
      MelodyEvent('0:1', 'F5', '4n'),
      MelodyEvent('0:2', 'A5', '4n'),
      MelodyEvent('0:3', 'C6', '4n'),
      MelodyEvent('1:0', 'Bb5', '4n'),
      MelodyEvent('1:1', 'A5', '4n'),
      MelodyEvent('1:2', 'F5', '4n'),
      MelodyEvent('1:3', 'D5', '4n'),
      MelodyEvent('2:0', 'G5', '4n'),
      MelodyEvent('2:1', 'A5', '4n'),
      MelodyEvent('2:2', 'Bb5', '4n'),
      MelodyEvent('2:3', 'D6', '4n'),
      MelodyEvent('3:0', 'C6', '4n'),
      MelodyEvent('3:1', 'A5', '4n'),
      MelodyEvent('3:2', 'F5', '4n'),
      MelodyEvent('3:3', 'D5', '4n'),
    ],
    chords: [
      ChordEvent('0:0', ['D3', 'F3', 'A3', 'D4'], '1m'),
      ChordEvent('1:0', ['Bb2', 'D3', 'F3', 'Bb3'], '1m'),
      ChordEvent('2:0', ['G2', 'Bb2', 'D3', 'G3'], '1m'),
      ChordEvent('3:0', ['A2', 'C#3', 'E3', 'A3'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['D2', 'A2', 'D3'], '4n'),
      BrassEvent('0:2', ['F2', 'A2'], '4n'),
      BrassEvent('1:0', ['Bb1', 'F2', 'Bb2'], '2n'),
      BrassEvent('2:0', ['G1', 'D2', 'G2'], '2n'),
      BrassEvent('3:0', ['A1', 'E2', 'A2'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '2:0', '3:0'],
  ),

  // ─── Caffè Notturno ── C minor, 88 BPM, MEDIUM · CLASSIC ───────────────────
  // A smoky jazz lounge.  The vocal lead plays a swinging blue-note phrase
  // (Cm7 → Fm7 → Ab → G7).  Half-note holds on the peak note give a relaxed
  // "after the first set" phrasing; the two strings voices swell like a quartet.
  Track(
    name: 'Caffè Notturno',
    bpm: 88,
    loops: 5,
    color: Color(0xFF2D1B69),
    theme: StageTheme.classic,
    melody: [
      // m0 · Cm7 — ascending blue-note phrase, held C6 on top
      MelodyEvent('0:0', 'G5', '4n'), // lane 3  · 5th of Cm
      MelodyEvent('0:1', 'Bb5', '4n'), // lane 2  · minor-7th blue note
      MelodyEvent('0:2', 'C6', '2n'), // lane 3  · root, held 2 beats
      // m1 · Fm7 — blue-note (Ab) descent
      MelodyEvent('1:0', 'Ab5', '4n'), // lane 1  · blue note, 3rd of Fm
      MelodyEvent('1:1', 'G5', '4n'), // lane 3  · chromatic passing tone
      MelodyEvent('1:2', 'F5', '4n'), // lane 2  · root of Fm
      MelodyEvent('1:3', 'Eb5', '4n'), // lane 1  · 7th of Fm (minor)
      // m2 · Ab — landing on root, held
      MelodyEvent('2:0', 'C5', '4n'), // lane 3  · 3rd of Ab
      MelodyEvent('2:1', 'Eb5', '4n'), // lane 1  · 5th of Ab
      MelodyEvent('2:2', 'Ab5', '2n'), // lane 1  · root, held 2 beats
      // m3 · G7 — jazzy resolution phrase, held D5
      MelodyEvent('3:0', 'G5', '4n'), // lane 3  · root of G7
      MelodyEvent('3:1', 'F5', '4n'), // lane 2  · dominant 7th
      MelodyEvent('3:2', 'D5', '2n'), // lane 0  · 5th of G, held
    ],
    chords: [
      ChordEvent('0:0', ['C3', 'Eb3', 'G3', 'Bb3'], '1m'), // Cm7
      ChordEvent('1:0', ['F3', 'Ab3', 'C4', 'Eb4'], '1m'), // Fm7 (mid voicing)
      ChordEvent('2:0', [
        'Ab3',
        'C4',
        'Eb4',
        'Ab4',
      ], '1m'), // Ab (bright voicing)
      ChordEvent('3:0', ['G2', 'B2', 'D3', 'F3'], '1m'), // G7
    ],
    brass: [
      // Jazz horn punches — half notes that breathe with the melody
      BrassEvent('0:0', ['C2', 'G2', 'Bb2'], '2n'), // Cm7 voicing
      BrassEvent('0:2', ['C2', 'Eb2', 'G2'], '2n'), // Cm7 alt
      BrassEvent('1:0', ['F2', 'C3', 'Eb3'], '2n'), // Fm7
      BrassEvent('1:2', ['F2', 'Ab2', 'C3'], '2n'), // Fm7 alt
      BrassEvent('2:0', ['Ab1', 'Eb2', 'Ab2'], '1m'), // Ab sustained
      BrassEvent('3:0', ['G1', 'B1', 'D2'], '2n'), // G
      BrassEvent('3:2', ['G1', 'B1', 'F2'], '2n'), // G7
    ],
    timpani: ['0:0', '1:0', '2:0', '3:0'], // one hit per chord, jazz restraint
  ),

  // ─── Reel delle Fate ── G major, 96 BPM, MEDIUM+ · CLASSIC ─────────────────
  // A fairy reel from the enchanted forest.  All quarter notes keep the feet
  // moving; the Em–Cmaj7–D arc gives richness without slowing the dance.
  Track(
    name: 'Reel delle Fate',
    bpm: 96,
    loops: 5,
    color: Color(0xFF16A34A),
    theme: StageTheme.classic,
    melody: [
      // m0 · G — ascending G-major arpeggio with wide leap to D6
      MelodyEvent('0:0', 'G5', '4n'), // lane 3  · root
      MelodyEvent('0:1', 'A5', '4n'), // lane 1  · 9th (passing)
      MelodyEvent('0:2', 'B5', '4n'), // lane 2  · 3rd
      MelodyEvent('0:3', 'D6', '4n'), // lane 0  · 5th, high leap
      // m1 · Em — descending run from E6
      MelodyEvent('1:0', 'E6', '4n'), // lane 1  · root
      MelodyEvent('1:1', 'D6', '4n'), // lane 0  · 7th (Em7 colour)
      MelodyEvent('1:2', 'B5', '4n'), // lane 2  · 5th
      MelodyEvent('1:3', 'A5', '4n'), // lane 1  · 4th (passing)
      // m2 · C — Cmaj7 shimmer: G, B, C, E form the maj-7 chord
      MelodyEvent('2:0', 'G5', '4n'), // lane 3  · 5th of C
      MelodyEvent('2:1', 'B5', '4n'), // lane 2  · maj 7th of C (Cmaj7)
      MelodyEvent('2:2', 'C6', '4n'), // lane 3  · root
      MelodyEvent('2:3', 'E6', '4n'), // lane 1  · 3rd, bright top note
      // m3 · D — clear D-major descent, root on bottom
      MelodyEvent('3:0', 'D6', '4n'), // lane 0  · root
      MelodyEvent('3:1', 'B5', '4n'), // lane 2  · 6th (Dadd6)
      MelodyEvent('3:2', 'A5', '4n'), // lane 1  · 5th
      MelodyEvent('3:3', 'D5', '4n'), // lane 0  · root, an octave lower
    ],
    chords: [
      ChordEvent('0:0', ['G3', 'B3', 'D4', 'G4'], '1m'), // G
      ChordEvent('1:0', ['E3', 'G3', 'B3', 'E4'], '1m'), // Em
      ChordEvent('2:0', ['C3', 'E3', 'G3', 'B3'], '1m'), // Cmaj7 (richer!)
      ChordEvent('3:0', ['D3', 'F#3', 'A3', 'D4'], '1m'), // D
    ],
    brass: [
      // Simple drone-like brass, one per measure — evokes uilleann pipes
      BrassEvent('0:0', ['G2', 'D3', 'G3'], '1m'),
      BrassEvent('1:0', ['E2', 'B2', 'E3'], '1m'),
      BrassEvent('2:0', ['C2', 'G2', 'B2'], '1m'), // Cmaj7 colour
      BrassEvent('3:0', ['D2', 'A2', 'D3'], '1m'),
    ],
    timpani: ['0:0', '2:0'], // bodhran: strong beats only
  ),

  // ─── Duende Andaluz ── A Phrygian, 108 BPM, HARD · GOTHIC ──────────────────
  // The dark spirit of Andalusia.  Phrygian descents (A–G–F) end on a half-note
  // sigh; rising responses build tension before the stabbing E Phrygian cadence.
  // Quarter-note brass punches evoke the flamenco golpe (knuckle rap on guitar).
  Track(
    name: 'Duende Andaluz',
    bpm: 108,
    loops: 5,
    color: Color(0xFFEA580C),
    theme: StageTheme.gothic,
    melody: [
      // m0 · Am — classic Phrygian descent A→G, hold F (3rd of Am below)
      MelodyEvent('0:0', 'A5', '4n'), // lane 1  · root
      MelodyEvent('0:1', 'G5', '4n'), // lane 3  · step down (Phrygian b7)
      MelodyEvent('0:2', 'F5', '2n'), // lane 2  · step down, held (3rd below)
      // m1 · G — deeper Phrygian descent G→F, hold E (leading to cadence)
      MelodyEvent('1:0', 'G5', '4n'), // lane 3  · root of G
      MelodyEvent('1:1', 'F5', '4n'), // lane 2  · passing tone
      MelodyEvent('1:2', 'E5', '2n'), // lane 1  · leading tone, held
      // m2 · F — ascending response, all four lanes covered
      MelodyEvent('2:0', 'E5', '4n'), // lane 1
      MelodyEvent('2:1', 'F5', '4n'), // lane 2  · root of F
      MelodyEvent('2:2', 'G5', '4n'), // lane 3
      MelodyEvent('2:3', 'A5', '4n'), // lane 1  · building back to peak
      // m3 · E (Phrygian cadence) — Bb is the characteristic b2 clash then resolve
      MelodyEvent(
        '3:0',
        'Bb5',
        '4n',
      ), // lane 2  · Phrygian b2 over E (tension!)
      MelodyEvent('3:1', 'A5', '4n'), // lane 1  · release
      MelodyEvent('3:2', 'G5', '4n'), // lane 3
      MelodyEvent('3:3', 'E5', '4n'), // lane 1  · root of E cadence
    ],
    chords: [
      ChordEvent('0:0', ['A2', 'C3', 'E3', 'A3'], '1m'), // Am
      ChordEvent('1:0', ['G2', 'B2', 'D3', 'G3'], '1m'), // G
      ChordEvent('2:0', ['F2', 'A2', 'C3', 'F3'], '1m'), // F
      ChordEvent('3:0', [
        'E2',
        'B2',
        'E3',
        'G#3',
      ], '1m'), // E (Phrygian cadence)
    ],
    brass: [
      // Staccato quarter-note punches — the flamenco golpe rhythm
      BrassEvent('0:0', ['A1', 'E2', 'A2'], '4n'),
      BrassEvent('0:2', ['A1', 'C2', 'E2'], '4n'),
      BrassEvent('1:0', ['G1', 'D2', 'G2'], '4n'),
      BrassEvent('1:2', ['G1', 'B1', 'D2'], '4n'),
      BrassEvent('2:0', ['F1', 'C2', 'F2'], '4n'),
      BrassEvent('2:2', ['F1', 'A1', 'C2'], '4n'),
      // E Phrygian cadence held — both halves sustain the final chord
      BrassEvent('3:0', ['E1', 'B1', 'E2', 'G#2'], '2n'),
      BrassEvent('3:2', ['E1', 'G#1', 'B1', 'E2'], '2n'),
    ],
    timpani: ['0:0', '0:2', '1:0', '1:2', '2:0', '2:2', '3:0'],
  ),

  // ─── Tango di Sangue ── A minor, 118 BPM, HARD+ · GOTHIC ───────────────────
  // A violent Argentine tango.  The habanera feel comes from the 2n held first
  // beat of m0 and m1 followed by two quick stabs — classic "hold then release".
  // Am → E7 → Dm → E7 is the authentic milonga progression.
  Track(
    name: 'Tango di Sangue',
    bpm: 118,
    loops: 5,
    color: Color(0xFF7F1D1D),
    theme: StageTheme.gothic,
    melody: [
      // m0 · Am — habanera long note then two stabs
      MelodyEvent(
        '0:0',
        'A5',
        '2n',
      ), // lane 1  · root, held (habanera downbeat)
      MelodyEvent('0:2', 'B5', '4n'), // lane 2  · add9, quick stab
      MelodyEvent('0:3', 'E6', '4n'), // lane 1  · 5th, high stab
      // m1 · E7 — same habanera silhouette, descending
      MelodyEvent('1:0', 'E5', '2n'), // lane 1  · root of E7, held
      MelodyEvent('1:2', 'D5', '4n'), // lane 0  · dominant 7th
      MelodyEvent('1:3', 'B4', '4n'), // lane 2  · 5th of E
      // m2 · Dm — full four-note Dm arpeggio, passionate ascent
      MelodyEvent('2:0', 'D5', '4n'), // lane 0  · root
      MelodyEvent('2:1', 'F5', '4n'), // lane 2  · 3rd (minor)
      MelodyEvent('2:2', 'A5', '4n'), // lane 1  · 5th
      MelodyEvent('2:3', 'D6', '4n'), // lane 0  · root high
      // m3 · E7 — stabbing E7 resolve
      MelodyEvent('3:0', 'B5', '2n'), // lane 2  · 5th of E7, held
      MelodyEvent('3:2', 'G#5', '4n'), // lane 3  · 3rd of E7 (leading tone)
      MelodyEvent('3:3', 'E5', '4n'), // lane 1  · root
    ],
    chords: [
      ChordEvent('0:0', ['A2', 'E3', 'A3', 'C4'], '1m'), // Am
      ChordEvent('1:0', ['E2', 'G#2', 'B2', 'D3'], '1m'), // E7
      ChordEvent('2:0', ['D3', 'F3', 'A3', 'D4'], '1m'), // Dm
      ChordEvent('3:0', ['E2', 'G#2', 'B2', 'D3'], '1m'), // E7
    ],
    brass: [
      // Tango brass: syncs with habanera rhythm in m0/m1, full hold in m2/m3
      BrassEvent('0:0', ['A1', 'E2', 'A2'], '2n'), // habanera long
      BrassEvent('0:2', ['A1', 'C2', 'E2'], '2n'), // habanera short pair
      BrassEvent('1:0', ['E1', 'B1', 'E2', 'G#2'], '2n'), // E7 long
      BrassEvent('1:2', ['E1', 'G#1', 'D2'], '2n'), // E7 short pair
      BrassEvent('2:0', ['D2', 'A2', 'D3'], '1m'), // Dm full
      BrassEvent('3:0', ['E1', 'B1', 'E2', 'G#2'], '1m'), // E7 full hold
    ],
    timpani: ['0:0', '0:2', '1:0', '1:2', '2:0', '3:0', '3:2'],
  ),

  // ─── Via della Seta ── D Hijaz, 132 BPM, VERY HARD · STEAMPUNK ─────────────
  // The Silk Road through a steam-powered empire.  The D–Hijaz scale
  // (D–Eb–F#–G–A–Bb–C) exposes the exotic augmented 2nd (Eb→F#) in the
  // opening and closing phrases; the Gm and Bb chords give it a minor-key
  // richness before the A-major resolution.
  Track(
    name: 'Via della Seta',
    bpm: 132,
    loops: 6,
    color: Color(0xFF065F46),
    theme: StageTheme.steampunk,
    melody: [
      // m0 · D major — expose the aug 2nd: D → Eb → F# (the exotic leap)
      MelodyEvent('0:0', 'D5', '4n'), // lane 0  · root
      MelodyEvent('0:1', 'Eb5', '4n'), // lane 1  · Hijaz lowered 2nd (exotic!)
      MelodyEvent('0:2', 'F#5', '2n'), // lane 2  · aug-2nd leap, held
      // m1 · Gm — ascending through the Hijaz scale
      MelodyEvent('1:0', 'G5', '4n'), // lane 3  · root of Gm
      MelodyEvent('1:1', 'A5', '4n'), // lane 1  · 9th (passing)
      MelodyEvent('1:2', 'Bb5', '4n'), // lane 2  · 3rd of Gm
      MelodyEvent('1:3', 'D6', '4n'), // lane 0  · 5th, peak note
      // m2 · Bb — descending zigzag: Bb–F lanes alternate like a zipper
      MelodyEvent('2:0', 'C6', '4n'), // lane 3  · 9th of Bb (colour)
      MelodyEvent('2:1', 'Bb5', '4n'), // lane 2  · root
      MelodyEvent('2:2', 'G5', '4n'), // lane 3  · 6th of Bb (Bb6 chord)
      MelodyEvent('2:3', 'F5', '4n'), // lane 2  · 5th of Bb
      // m3 · A — re-expose aug 2nd in reverse, settle on the 5th
      MelodyEvent('3:0', 'F#5', '4n'), // lane 2  · exotic 6th over A
      MelodyEvent('3:1', 'A5', '4n'), // lane 1  · root of A
      MelodyEvent('3:2', 'E5', '2n'), // lane 1  · 5th, held (clean resolution)
    ],
    chords: [
      ChordEvent('0:0', ['D3', 'F#3', 'A3', 'D4'], '1m'), // D (Hijaz tonic)
      ChordEvent('1:0', ['G2', 'Bb2', 'D3', 'G3'], '1m'), // Gm
      ChordEvent('2:0', ['Bb2', 'D3', 'F3', 'Bb3'], '1m'), // Bb
      ChordEvent('3:0', [
        'A2',
        'C#3',
        'E3',
        'A3',
      ], '1m'), // A (authentic cadence)
    ],
    brass: [
      // Half-note brass hits on each chord half — steampunk piston rhythm
      BrassEvent('0:0', ['D2', 'A2', 'D3'], '2n'),
      BrassEvent('0:2', ['D2', 'F#2', 'A2'], '2n'),
      BrassEvent('1:0', ['G2', 'D3', 'G3'], '2n'),
      BrassEvent('1:2', ['G2', 'Bb2', 'D3'], '2n'),
      BrassEvent('2:0', ['Bb1', 'F2', 'Bb2'], '2n'),
      BrassEvent('2:2', ['Bb1', 'D2', 'F2'], '2n'),
      BrassEvent('3:0', [
        'A1',
        'E2',
        'A2',
        'C#3',
      ], '1m'), // full hold on cadence
    ],
    timpani: ['0:0', '0:1', '0:2', '1:0', '1:2', '2:0', '2:2', '3:0', '3:2'],
  ),

  // ─── Marcia dell'Acciaio ── D major, 144 BPM, EXTREME · STEAMPUNK ───────────
  // The steel march of the great engine.  A 2n held opening note gives each
  // phrase a "down-beat stomp" feel; the G-section descending run and the
  // A-section power-climb then collapse back to D with full-beat brass hammers.
  Track(
    name: "Marcia dell'Acciaio",
    bpm: 144,
    loops: 6,
    color: Color(0xFF64748B),
    theme: StageTheme.steampunk,
    melody: [
      // m0 · D — stomp on D5 (2n), then leap up to close
      MelodyEvent('0:0', 'D5', '2n'), // lane 0  · root, march downbeat (held)
      MelodyEvent('0:2', 'A5', '4n'), // lane 1  · 5th, quick
      MelodyEvent('0:3', 'D6', '4n'), // lane 0  · root high, close
      // m1 · G — crisp descending run through all lanes
      MelodyEvent('1:0', 'E6', '4n'), // lane 1  · 6th of G (colour)
      MelodyEvent('1:1', 'D6', '4n'), // lane 0  · 5th of G
      MelodyEvent('1:2', 'B5', '4n'), // lane 2  · 3rd of G
      MelodyEvent('1:3', 'G5', '4n'), // lane 3  · root of G
      // m2 · A — stomp on A5 (2n), then fill with F#-E
      MelodyEvent('2:0', 'A5', '2n'), // lane 1  · root of A, held
      MelodyEvent('2:2', 'F#5', '4n'), // lane 2  · 6th of A (march colour)
      MelodyEvent('2:3', 'E5', '4n'), // lane 1  · 5th of A
      // m3 · D — march cadence: sus4 builds tension, resolves to root D6
      MelodyEvent('3:0', 'G5', '4n'), // lane 3  · 4th of D (sus4, tension)
      MelodyEvent('3:1', 'A5', '4n'), // lane 1  · 5th of D
      MelodyEvent('3:2', 'D6', '2n'), // lane 0  · root, triumphant arrival
    ],
    chords: [
      ChordEvent('0:0', ['D3', 'F#3', 'A3', 'D4'], '1m'), // D
      ChordEvent('1:0', ['G2', 'B2', 'D3', 'G3'], '1m'), // G
      ChordEvent('2:0', ['A2', 'C#3', 'E3', 'A3'], '1m'), // A
      ChordEvent('3:0', ['D3', 'F#3', 'A3', 'D4'], '1m'), // D
    ],
    brass: [
      // m0: every quarter beat — the forge hammer never rests
      BrassEvent('0:0', ['D2', 'A2', 'D3'], '4n'),
      BrassEvent('0:1', ['D2', 'F#2', 'A2'], '4n'),
      BrassEvent('0:2', ['D2', 'A2', 'D3'], '4n'),
      BrassEvent('0:3', ['D2', 'F#2', 'A2'], '4n'),
      // m1: half-note pairs — broader march feel
      BrassEvent('1:0', ['G2', 'D3', 'G3'], '2n'),
      BrassEvent('1:2', ['G2', 'B2', 'D3'], '2n'),
      // m2: half-note pairs
      BrassEvent('2:0', ['A2', 'E3', 'A3'], '2n'),
      BrassEvent('2:2', ['A2', 'C#3', 'E3'], '2n'),
      // m3: every quarter beat again — triumphant return
      BrassEvent('3:0', ['D2', 'A2', 'D3'], '4n'),
      BrassEvent('3:1', ['D2', 'F#2', 'A2'], '4n'),
      BrassEvent('3:2', ['D2', 'A2', 'D3'], '4n'),
      BrassEvent('3:3', ['D2', 'F#2', 'A2'], '4n'),
    ],
    timpani: [
      '0:0',
      '0:1',
      '0:2',
      '0:3',
      '1:0',
      '1:2',
      '2:0',
      '2:2',
      '3:0',
      '3:1',
      '3:2',
      '3:3',
    ],
  ),

  // ─── Act IX · L'Ultima Battaglia ── A minor, 158 BPM, MAXIMUM · STEAMPUNK ──
  // The last battle.  Maximum BPM, all 4 lanes every beat, relentless fire.
  Track(
    name: "L'Ultima Battaglia",
    bpm: 158,
    loops: 7,
    color: Color(0xFFF97316),
    theme: StageTheme.steampunk,
    melody: [
      MelodyEvent('0:0', 'A5', '4n'), // lane 1
      MelodyEvent('0:1', 'D6', '4n'), // lane 0
      MelodyEvent('0:2', 'F5', '4n'), // lane 2
      MelodyEvent('0:3', 'G5', '4n'), // lane 3
      MelodyEvent('1:0', 'E6', '4n'), // lane 1
      MelodyEvent('1:1', 'C6', '4n'), // lane 3
      MelodyEvent('1:2', 'D6', '4n'), // lane 0
      MelodyEvent('1:3', 'B5', '4n'), // lane 2
      MelodyEvent('2:0', 'A5', '4n'), // lane 1
      MelodyEvent('2:1', 'G5', '4n'), // lane 3
      MelodyEvent('2:2', 'F5', '4n'), // lane 2
      MelodyEvent('2:3', 'D5', '4n'), // lane 0
      MelodyEvent('3:0', 'C5', '4n'), // lane 3
      MelodyEvent('3:1', 'E5', '4n'), // lane 1
      MelodyEvent('3:2', 'F5', '4n'), // lane 2
      MelodyEvent('3:3', 'A5', '4n'), // lane 1
    ],
    chords: [
      ChordEvent('0:0', ['A2', 'E3', 'A3', 'C4'], '2n'), // Am
      ChordEvent('0:2', ['A2', 'C3', 'E3', 'G3'], '2n'), // Am7
      ChordEvent('1:0', ['F2', 'A2', 'C3', 'F3'], '2n'), // F
      ChordEvent('1:2', ['F2', 'C3', 'F3', 'A3'], '2n'), // F
      ChordEvent('2:0', ['C3', 'E3', 'G3', 'C4'], '2n'), // C
      ChordEvent('2:2', ['C3', 'G3', 'C4', 'E4'], '2n'), // C
      ChordEvent('3:0', ['E2', 'B2', 'E3', 'G#3'], '2n'), // E
      ChordEvent('3:2', ['E2', 'G#2', 'B2', 'E3'], '2n'), // E
    ],
    brass: [
      BrassEvent('0:0', ['A1', 'E2', 'A2'], '4n'),
      BrassEvent('0:1', ['A1', 'C2', 'E2'], '4n'),
      BrassEvent('0:2', ['A1', 'E2', 'G2'], '4n'),
      BrassEvent('0:3', ['A1', 'C2', 'E2'], '4n'),
      BrassEvent('1:0', ['F1', 'C2', 'F2'], '4n'),
      BrassEvent('1:1', ['F1', 'A1', 'C2'], '4n'),
      BrassEvent('1:2', ['F1', 'C2', 'F2'], '4n'),
      BrassEvent('1:3', ['F1', 'A1', 'C2'], '4n'),
      BrassEvent('2:0', ['C2', 'G2', 'C3'], '4n'),
      BrassEvent('2:2', ['C2', 'E2', 'G2'], '4n'),
      BrassEvent('3:0', ['E2', 'B2', 'E3', 'G#3'], '4n'),
      BrassEvent('3:2', ['E2', 'G#2', 'B2', 'E3'], '4n'),
    ],
    timpani: [
      '0:0',
      '0:1',
      '0:2',
      '0:3',
      '1:0',
      '1:1',
      '1:2',
      '1:3',
      '2:0',
      '2:1',
      '2:2',
      '2:3',
      '3:0',
      '3:1',
      '3:2',
      '3:3',
    ],
  ),

  // ─── Gran Teatro Collection V2 ──────────────────────────────────────────────
  Track(
    name: "La Tempesta d'Amore",
    subtitle: 'C minor · overture · soprano aria · duet · tragic finale',
    bpm: 60,
    loops: 5,
    color: Color(0xFFC8843A),
    theme: StageTheme.gothic,
    melody: [
      MelodyEvent('0:0', 'C5', '2n'),
      MelodyEvent('0:2', 'Eb5', '4n'),
      MelodyEvent('0:3', 'G5', '4n'),
      MelodyEvent('1:0', 'Ab5', '2n'),
      MelodyEvent('1:2', 'G5', '4n'),
      MelodyEvent('1:3', 'F5', '4n'),
      MelodyEvent('2:0', 'Eb5', '2n'),
      MelodyEvent('2:2', 'D5', '4n'),
      MelodyEvent('2:3', 'C5', '4n'),
      MelodyEvent('3:0', 'G5', '4n'),
      MelodyEvent('3:1', 'Ab5', '4n'),
      MelodyEvent('3:2', 'G5', '2n'),
    ],
    chords: [
      ChordEvent('0:0', ['C3', 'Eb3', 'G3', 'C4'], '1m'),
      ChordEvent('1:0', ['Ab2', 'C3', 'Eb3', 'Ab3'], '1m'),
      ChordEvent('2:0', ['F2', 'Ab2', 'C3', 'F3'], '1m'),
      ChordEvent('3:0', ['G2', 'B2', 'D3', 'F3'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['C2', 'G2', 'C3'], '2n'),
      BrassEvent('0:2', ['Eb2', 'G2'], '2n'),
      BrassEvent('1:0', ['Ab1', 'Eb2', 'Ab2'], '2n'),
      BrassEvent('1:2', ['Ab1', 'C2', 'Eb2'], '2n'),
      BrassEvent('2:0', ['F1', 'C2', 'F2'], '2n'),
      BrassEvent('3:0', ['G1', 'D2', 'G2'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '2:0', '3:0'],
  ),

  Track(
    name: 'Il Pianto di Orfeo',
    subtitle: 'G minor · Baroque · lament · chaconne · apotheosis',
    bpm: 52,
    loops: 4,
    color: Color(0xFF8A6A40),
    theme: StageTheme.classic,
    melody: [
      MelodyEvent('0:0', 'G4', '2n'),
      MelodyEvent('0:2', 'Bb4', '4n'),
      MelodyEvent('0:3', 'D5', '4n'),
      MelodyEvent('1:0', 'F5', '2n.'),
      MelodyEvent('1:3', 'Eb5', '4n'),
      MelodyEvent('2:0', 'D5', '2n'),
      MelodyEvent('2:2', 'C5', '4n'),
      MelodyEvent('2:3', 'Bb4', '4n'),
      MelodyEvent('3:0', 'A4', '4n'),
      MelodyEvent('3:1', 'C5', '4n'),
      MelodyEvent('3:2', 'D5', '2n'),
    ],
    chords: [
      ChordEvent('0:0', ['G3', 'Bb3', 'D4', 'G4'], '1m'),
      ChordEvent('1:0', ['Eb3', 'G3', 'Bb3', 'Eb4'], '1m'),
      ChordEvent('2:0', ['C3', 'Eb3', 'G3', 'C4'], '1m'),
      ChordEvent('3:0', ['D3', 'F#3', 'A3', 'D4'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['G2', 'D3', 'G3'], '2n'),
      BrassEvent('0:2', ['Bb2', 'D3'], '2n'),
      BrassEvent('1:0', ['Eb2', 'Bb2', 'Eb3'], '1m'),
      BrassEvent('2:0', ['C2', 'G2', 'C3'], '1m'),
      BrassEvent('3:0', ['D2', 'A2', 'D3'], '1m'),
    ],
    timpani: ['0:0', '1:2', '3:0'],
  ),

  Track(
    name: 'La Vendetta della Regina',
    subtitle: 'D minor · fury aria · conspirators · duel · death scene',
    bpm: 76,
    loops: 6,
    color: Color(0xFFA61E1E),
    theme: StageTheme.gothic,
    melody: [
      MelodyEvent('0:0', 'D5', '4n'),
      MelodyEvent('0:1', 'F5', '4n'),
      MelodyEvent('0:2', 'A5', '4n'),
      MelodyEvent('0:3', 'C6', '4n'),
      MelodyEvent('1:0', 'Bb5', '4n'),
      MelodyEvent('1:1', 'A5', '4n'),
      MelodyEvent('1:2', 'G5', '4n'),
      MelodyEvent('1:3', 'F5', '4n'),
      MelodyEvent('2:0', 'E5', '4n'),
      MelodyEvent('2:1', 'F5', '4n'),
      MelodyEvent('2:2', 'G5', '4n'),
      MelodyEvent('2:3', 'A5', '4n'),
      MelodyEvent('3:0', 'C6', '2n'),
      MelodyEvent('3:2', 'D6', '2n'),
    ],
    chords: [
      ChordEvent('0:0', ['D3', 'F3', 'A3', 'D4'], '1m'),
      ChordEvent('1:0', ['Bb2', 'D3', 'F3', 'Bb3'], '1m'),
      ChordEvent('2:0', ['G2', 'Bb2', 'D3', 'G3'], '1m'),
      ChordEvent('3:0', ['A2', 'C#3', 'E3', 'G3'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['D2', 'A2', 'D3'], '4n'),
      BrassEvent('0:2', ['D2', 'F2', 'A2'], '4n'),
      BrassEvent('1:0', ['Bb1', 'F2', 'Bb2'], '2n'),
      BrassEvent('1:2', ['Bb1', 'D2', 'F2'], '2n'),
      BrassEvent('2:0', ['G1', 'D2', 'G2'], '2n'),
      BrassEvent('2:2', ['G1', 'Bb1', 'D2'], '2n'),
      BrassEvent('3:0', ['A1', 'E2', 'A2', 'C#3'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '1:2', '2:0', '2:2', '3:0'],
  ),

  Track(
    name: 'Il Sogno di Desdemona',
    subtitle: 'A-flat major-minor · moonlight · nocturne · prayer · betrayal',
    bpm: 46,
    loops: 4,
    color: Color(0xFF7084A8),
    theme: StageTheme.classic,
    melody: [
      MelodyEvent('0:0', 'Ab4', '2n.'),
      MelodyEvent('0:3', 'C5', '4n'),
      MelodyEvent('1:0', 'Eb5', '2n'),
      MelodyEvent('1:2', 'Db5', '4n'),
      MelodyEvent('1:3', 'C5', '4n'),
      MelodyEvent('2:0', 'Bb4', '2n'),
      MelodyEvent('2:2', 'Ab4', '4n'),
      MelodyEvent('2:3', 'F4', '4n'),
      MelodyEvent('3:0', 'Gb4', '4n'),
      MelodyEvent('3:1', 'Ab4', '4n'),
      MelodyEvent('3:2', 'C5', '2n'),
    ],
    chords: [
      ChordEvent('0:0', ['Ab3', 'C4', 'Eb4', 'Ab4'], '1m'),
      ChordEvent('1:0', ['Db3', 'F3', 'Ab3', 'Db4'], '1m'),
      ChordEvent('2:0', ['F3', 'Ab3', 'C4', 'F4'], '1m'),
      ChordEvent('3:0', ['Eb3', 'G3', 'Bb3', 'Db4'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['Ab2', 'Eb3', 'Ab3'], '1m'),
      BrassEvent('1:0', ['Db2', 'Ab2', 'Db3'], '1m'),
      BrassEvent('2:0', ['F2', 'C3', 'F3'], '1m'),
      BrassEvent('3:0', ['Eb2', 'Bb2', 'Eb3'], '1m'),
    ],
    timpani: ['0:0', '2:0'],
  ),

  Track(
    name: "Il Trionfo dell'Aurora",
    subtitle: 'E major · sunrise · grand chorus · jubilate · triumph',
    bpm: 68,
    loops: 5,
    color: Color(0xFFE6B84C),
    theme: StageTheme.steampunk,
    melody: [
      MelodyEvent('0:0', 'E5', '4n'),
      MelodyEvent('0:1', 'G#5', '4n'),
      MelodyEvent('0:2', 'B5', '4n'),
      MelodyEvent('0:3', 'E6', '4n'),
      MelodyEvent('1:0', 'F#6', '4n'),
      MelodyEvent('1:1', 'E6', '4n'),
      MelodyEvent('1:2', 'C#6', '4n'),
      MelodyEvent('1:3', 'B5', '4n'),
      MelodyEvent('2:0', 'A5', '4n'),
      MelodyEvent('2:1', 'B5', '4n'),
      MelodyEvent('2:2', 'C#6', '2n'),
      MelodyEvent('3:0', 'G#5', '4n'),
      MelodyEvent('3:1', 'B5', '4n'),
      MelodyEvent('3:2', 'E6', '2n'),
    ],
    chords: [
      ChordEvent('0:0', ['E3', 'G#3', 'B3', 'E4'], '1m'),
      ChordEvent('1:0', ['C#3', 'E3', 'G#3', 'C#4'], '1m'),
      ChordEvent('2:0', ['A2', 'C#3', 'E3', 'A3'], '1m'),
      ChordEvent('3:0', ['B2', 'D#3', 'F#3', 'A3'], '1m'),
    ],
    brass: [
      BrassEvent('0:0', ['E2', 'B2', 'E3'], '2n'),
      BrassEvent('0:2', ['E2', 'G#2', 'B2'], '2n'),
      BrassEvent('1:0', ['C#2', 'G#2', 'C#3'], '2n'),
      BrassEvent('1:2', ['C#2', 'E2', 'G#2'], '2n'),
      BrassEvent('2:0', ['A1', 'E2', 'A2'], '2n'),
      BrassEvent('2:2', ['A1', 'C#2', 'E2'], '2n'),
      BrassEvent('3:0', ['B1', 'F#2', 'B2', 'D#3'], '1m'),
    ],
    timpani: ['0:0', '0:2', '1:0', '2:0', '2:2', '3:0'],
  ),
];
