import 'dart:math';

/// Convert a musical time string "measure:beat" or "measure:beat:sixteenth"
/// into seconds at the given BPM (assumes 4/4 time).
double musicalTimeToSeconds(String timeStr, double bpm) {
  final parts = timeStr.split(':').map(int.parse).toList();
  final measure = parts[0];
  final beat = parts.length > 1 ? parts[1] : 0;
  final sixteenth = parts.length > 2 ? parts[2] : 0;

  final secondsPerBeat = 60.0 / bpm;
  final totalBeats = (measure * 4) + beat + (sixteenth / 4.0);
  return totalBeats * secondsPerBeat;
}

/// Convert a duration notation string to seconds at the given BPM.
///   "1m"  = 1 whole measure (4 beats)
///   "2n"  = half note (2 beats)
///   "2n." = dotted half note (3 beats)
///   "4n"  = quarter note (1 beat)
///   "8n"  = eighth note (0.5 beats)
double durationToSeconds(String dur, double bpm) {
  final secondsPerBeat = 60.0 / bpm;
  final dotted = dur.endsWith('.');
  final clean = dur.replaceAll('.', '');

  double beats;
  if (clean == '1m') {
    beats = 4;
  } else if (clean.endsWith('n')) {
    final n = int.tryParse(clean.replaceAll('n', '')) ?? 4;
    beats = 4.0 / n;
  } else {
    beats = 1;
  }

  if (dotted) beats *= 1.5;
  return beats * secondsPerBeat;
}

/// Convert a duration string to beats.
double durationToBeats(String dur) {
  final dotted = dur.endsWith('.');
  final clean = dur.replaceAll('.', '');

  double beats;
  if (clean == '1m') {
    beats = 4;
  } else if (clean.endsWith('n')) {
    final n = int.tryParse(clean.replaceAll('n', '')) ?? 4;
    beats = 4.0 / n;
  } else {
    beats = 1;
  }

  if (dotted) beats *= 1.5;
  return beats;
}

/// Convert "measure:beat" to total beats from start.
double musicalTimeToBeats(String timeStr) {
  final parts = timeStr.split(':').map(int.parse).toList();
  final measure = parts[0];
  final beat = parts.length > 1 ? parts[1] : 0;
  final sixteenth = parts.length > 2 ? parts[2] : 0;
  return (measure * 4.0) + beat + (sixteenth / 4.0);
}

// ─── Note name utilities ──────────────────────────────────────
final _noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
final _flatToSharp = {'Db': 'C#', 'Eb': 'D#', 'Fb': 'E', 'Gb': 'F#', 'Ab': 'G#', 'Bb': 'A#', 'Cb': 'B'};

/// Parse note name to MIDI number.
int noteNameToMidi(String name) {
  // Handle flats
  String note;
  int octave;

  if (name.length >= 3 && name[1] == 'b') {
    final flat = name.substring(0, 2);
    note = _flatToSharp[flat] ?? flat;
    octave = int.parse(name.substring(2));
  } else if (name.length >= 3 && name[1] == '#') {
    note = name.substring(0, 2);
    octave = int.parse(name.substring(2));
  } else {
    note = name.substring(0, 1);
    octave = int.parse(name.substring(1));
  }

  final semitone = _noteNames.indexOf(note);
  if (semitone == -1) return 60; // fallback to C4
  return (octave + 1) * 12 + semitone;
}

/// Transpose a note name by the given number of semitones.
String transposeNote(String name, int semitones) {
  final midi = noteNameToMidi(name) + semitones;
  final octave = (midi ~/ 12) - 1;
  final noteIndex = midi % 12;
  return '${_noteNames[noteIndex]}$octave';
}

/// Get frequency from note name.
double noteFrequency(String name) {
  final midi = noteNameToMidi(name);
  return 440.0 * pow(2, (midi - 69) / 12.0);
}
