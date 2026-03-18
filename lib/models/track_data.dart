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
      MelodyEvent('0:1', 'A5', '4n'),  // lane 1
      MelodyEvent('0:2', 'C#6', '4n'), // lane 3
      MelodyEvent('0:3', 'E6', '4n'),  // lane 1
      MelodyEvent('1:0', 'D6', '4n'),  // lane 0
      MelodyEvent('1:1', 'C#6', '4n'), // lane 3
      MelodyEvent('1:2', 'B5', '4n'),  // lane 2
      MelodyEvent('1:3', 'A5', '4n'),  // lane 1
      MelodyEvent('2:0', 'G#5', '4n'), // lane 3
      MelodyEvent('2:1', 'B5', '4n'),  // lane 2
      MelodyEvent('2:2', 'D6', '4n'),  // lane 0
      MelodyEvent('2:3', 'A5', '4n'),  // lane 1
      MelodyEvent('3:0', 'E6', '4n'),  // lane 1
      MelodyEvent('3:1', 'C#6', '4n'), // lane 3
      MelodyEvent('3:2', 'A5', '4n'),  // lane 1
      MelodyEvent('3:3', 'F#5', '4n'), // lane 2
    ],
    chords: [
      ChordEvent('0:0', ['F#3', 'A3', 'C#4', 'F#4'], '1m'), // F#m
      ChordEvent('1:0', ['D3', 'F#3', 'A3', 'D4'], '1m'),   // D
      ChordEvent('2:0', ['A2', 'E3', 'A3', 'C#4'], '1m'),   // A
      ChordEvent('3:0', ['E3', 'G#3', 'B3', 'E4'], '1m'),   // E
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
    timpani: ['0:0', '0:1', '0:2', '1:0', '1:2', '2:0', '2:1', '2:2', '3:0', '3:2'],
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
];
