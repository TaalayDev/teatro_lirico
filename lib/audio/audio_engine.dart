import 'package:audioplayers/audioplayers.dart';
import 'package:synthkit/synthkit.dart';
import '../models/game_models.dart';
import 'music_utils.dart';

class ScheduleActResult {
  final List<GameNote> notes;
  final double trackEndTime;

  ScheduleActResult(this.notes, this.trackEndTime);
}

/// Wraps [SynthKitEngine] and exposes game-oriented helpers.
class AudioEngine {
  final SynthKitEngine _engine = SynthKitEngine();
  final AudioPlayer _applausePlayer = AudioPlayer();

  SynthKitSynth? _vocalLead;
  SynthKitSynth? _strings;
  SynthKitSynth? _stringsHigh; // second strings voice for fuller chords
  SynthKitSynth? _brass;
  SynthKitSynth? _bass;
  SynthKitSynth? _timpani;
  SynthKitSynth? _missSound;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Call once (from a user gesture on web).
  Future<void> initialize() async {
    if (_initialized) return;
    await _engine.initialize(bpm: 120, masterVolume: 0.75);

    // ── Vocal lead: warm sawtooth with voice-like filter ──────────
    _vocalLead = await _engine.createSynth(
      const SynthKitSynthOptions(
        waveform: SynthKitWaveform.sawtooth,
        envelope: SynthKitEnvelope(
          attack: Duration(milliseconds: 60),
          decay: Duration(milliseconds: 250),
          sustain: 0.82,
          release: Duration(milliseconds: 900),
        ),
        filter: SynthKitFilter.lowPass(cutoffHz: 1400),
        volume: 0.13,
      ),
    );

    // ── Strings lower register: triangle, slow attack for legato ──
    _strings = await _engine.createSynth(
      const SynthKitSynthOptions(
        waveform: SynthKitWaveform.triangle,
        envelope: SynthKitEnvelope(
          attack: Duration(milliseconds: 320),
          decay: Duration(milliseconds: 200),
          sustain: 0.75,
          release: Duration(milliseconds: 900),
        ),
        filter: SynthKitFilter.lowPass(cutoffHz: 1800),
        volume: 0.18,
      ),
    );

    // ── Strings upper register: slightly brighter for sparkle ─────
    _stringsHigh = await _engine.createSynth(
      const SynthKitSynthOptions(
        waveform: SynthKitWaveform.triangle,
        envelope: SynthKitEnvelope(
          attack: Duration(milliseconds: 450),
          decay: Duration(milliseconds: 300),
          sustain: 0.65,
          release: Duration(milliseconds: 1100),
        ),
        filter: SynthKitFilter.lowPass(cutoffHz: 2800),
        volume: 0.12,
      ),
    );

    // ── Brass section: sawtooth with low-pass for warmth ──────────
    _brass = await _engine.createSynth(
      const SynthKitSynthOptions(
        waveform: SynthKitWaveform.sawtooth,
        envelope: SynthKitEnvelope(
          attack: Duration(milliseconds: 120),
          decay: Duration(milliseconds: 180),
          sustain: 0.55,
          release: Duration(milliseconds: 600),
        ),
        filter: SynthKitFilter.lowPass(cutoffHz: 900),
        volume: 0.22,
      ),
    );

    // ── Bass: sine for deep sub-bass punch ────────────────────────
    _bass = await _engine.createSynth(
      const SynthKitSynthOptions(
        waveform: SynthKitWaveform.sine,
        envelope: SynthKitEnvelope(
          attack: Duration(milliseconds: 10),
          decay: Duration(milliseconds: 400),
          sustain: 0.35,
          release: Duration(milliseconds: 600),
        ),
        volume: 0.55,
      ),
    );

    // ── Timpani: sine with sharp decay ────────────────────────────
    _timpani = await _engine.createSynth(
      const SynthKitSynthOptions(
        waveform: SynthKitWaveform.sine,
        envelope: SynthKitEnvelope(
          attack: Duration(milliseconds: 2),
          decay: Duration(milliseconds: 550),
          sustain: 0.08,
          release: Duration(milliseconds: 700),
        ),
        volume: 0.65,
      ),
    );

    // ── Miss buzz: harsh short sawtooth ───────────────────────────
    _missSound = await _engine.createSynth(
      const SynthKitSynthOptions(
        waveform: SynthKitWaveform.sawtooth,
        envelope: SynthKitEnvelope(
          attack: Duration(milliseconds: 5),
          decay: Duration(milliseconds: 120),
          sustain: 0.0,
          release: Duration(milliseconds: 80),
        ),
        volume: 0.22,
      ),
    );

    _initialized = true;
  }

  /// Stop current transport and clear parts.
  Future<void> resetTransport() async {
    await _engine.transport.stop(clearSequence: true);
  }

  /// Schedule the background music and the vocal melody for an act.
  Future<ScheduleActResult> scheduleAct(Track track) async {
    if (!_initialized) return ScheduleActResult([], 0);

    await resetTransport();

    final bpm = track.bpm.toDouble();
    await _engine.transport.setBpm(bpm);

    final notes = <GameNote>[];
    final loops = track.loops;

    for (int rep = 0; rep < loops; rep++) {
      final measureOffset = rep * 4;
      final isIntro = rep == 0;
      final isClimax =
          rep >= loops - 3 && rep < loops - 1; // last two reps before finale
      final isEnd = rep == loops - 1;

      // ── Game notes (vocal melody) ─────────────────────────────
      if (!isIntro) {
        for (final ev in track.melody) {
          // Sparse finale — only beat-0 notes on each measure
          if (isEnd) {
            final parts = ev.time.split(':');
            if (parts.length > 1 && int.parse(parts[1]) > 0) continue;
          }

          var noteName = ev.note;
          if (isClimax) noteName = transposeNote(noteName, 12);

          final parts = ev.time.split(':');
          final newMeasure = int.parse(parts[0]) + measureOffset;
          final nextTime = '$newMeasure:${parts.sublist(1).join(':')}';

          final timeSec = musicalTimeToSeconds(nextTime, bpm);
          final durSec = durationToSeconds(ev.dur, bpm);
          final lane = noteName.codeUnitAt(0) % 4;

          notes.add(
            GameNote(
              time: timeSec,
              endTime: timeSec + durSec,
              duration: durSec,
              lane: lane,
              noteName: noteName,
            ),
          );
        }
      }

      // ── Strings: play ALL chord notes for full harmony ────────
      for (final chord in track.chords) {
        if (isEnd) {
          final m = int.parse(chord.time.split(':')[0]);
          if (m > 1) continue;
        }

        final parts = chord.time.split(':');
        final newMeasure = int.parse(parts[0]) + measureOffset;
        final nextTime = '$newMeasure:${parts.sublist(1).join(':')}';
        final baseBeat = musicalTimeToBeats(nextTime);
        final durBeats = durationToBeats(chord.dur);

        // Lower notes → _strings, upper notes → _stringsHigh
        final mid = chord.notes.length ~/ 2;
        for (int ni = 0; ni < chord.notes.length; ni++) {
          final synth = ni < mid ? _strings : _stringsHigh;
          if (synth == null) continue;
          await _engine.transport.schedule(
            synth: synth,
            note: SynthKitNote.parse(chord.notes[ni]),
            beat: baseBeat,
            durationBeats: durBeats,
          );
        }
      }

      // ── Brass: all reps except intro; all notes in each event ─
      if (!isIntro) {
        for (final b in track.brass) {
          final parts = b.time.split(':');
          final newMeasure = int.parse(parts[0]) + measureOffset;
          final nextTime = '$newMeasure:${parts.sublist(1).join(':')}';
          final baseBeat = musicalTimeToBeats(nextTime);
          final durBeats = durationToBeats(b.dur);

          // Volume scales up at climax
          for (final bNote in b.notes) {
            var noteStr = bNote;
            if (isClimax) noteStr = transposeNote(noteStr, 12);
            if (_brass != null) {
              await _engine.transport.schedule(
                synth: _brass!,
                note: SynthKitNote.parse(noteStr),
                beat: baseBeat,
                durationBeats: durBeats,
              );
            }
          }
        }
      }

      // ── Bass: root note of each chord, every rep ──────────────
      for (final chord in track.chords) {
        if (isEnd && int.parse(chord.time.split(':')[0]) > 1) continue;

        final parts = chord.time.split(':');
        final newMeasure = int.parse(parts[0]) + measureOffset;
        final nextTime = '$newMeasure:${parts.sublist(1).join(':')}';
        final baseBeat = musicalTimeToBeats(nextTime);
        final durBeats = durationToBeats(chord.dur) * 0.8;

        // Root is always the first chord note; drop it one octave for sub-bass
        final rootName = chord.notes.first;
        final bassNote = transposeNote(rootName, -12);
        if (_bass != null) {
          await _engine.transport.schedule(
            synth: _bass!,
            note: SynthKitNote.parse(bassNote),
            beat: baseBeat,
            durationBeats: durBeats,
          );
        }
      }

      // ── Timpani: all reps except intro ────────────────────────
      if (!isIntro) {
        for (final t in track.timpani) {
          final parts = t.split(':');
          final newMeasure = int.parse(parts[0]) + measureOffset;
          final nextTime = '$newMeasure:${parts.sublist(1).join(':')}';
          final baseBeat = musicalTimeToBeats(nextTime);

          // Alternate between G1 (deep) and D2 (medium) for variety
          final isOdd = baseBeat.round() % 2 == 1;
          final timpNote = isOdd ? 'D2' : 'G1';

          if (_timpani != null) {
            await _engine.transport.schedule(
              synth: _timpani!,
              note: SynthKitNote.parse(timpNote),
              beat: baseBeat,
              durationBeats: 0.5,
            );
          }
        }
      }
    }

    notes.sort((a, b) => a.time.compareTo(b.time));

    // Total beats = loops × 4 measures × 4 beats
    final totalBeats = loops * 16.0;
    final totalSeconds = totalBeats * (60.0 / bpm);
    return ScheduleActResult(notes, totalSeconds);
  }

  /// Start transport playback.
  Future<void> startPlayback() async {
    await _engine.transport.start();
  }

  /// Stop transport playback.
  Future<void> pausePlayback() async {
    await _engine.transport.stop(clearSequence: false);
  }

  Future<void> playClapping() async {
    await _applausePlayer.stop();
    await _applausePlayer.setReleaseMode(ReleaseMode.stop);
    await _applausePlayer.play(AssetSource('clapping.mp3'));
  }

  Future<void> stopClapping() async {
    await _applausePlayer.stop();
  }

  Future<void> triggerVocal(String noteName, Duration duration) async {
    if (_vocalLead == null) return;
    await _vocalLead!.triggerAttackRelease(
      SynthKitNote.parse(noteName.toUpperCase()),
      duration,
    );
  }

  /// Play the miss / wrong-key buzz.
  Future<void> playMiss() async {
    if (_missSound == null) return;
    await _missSound!.triggerAttackRelease(
      SynthKitNote.parse('C2'),
      const Duration(milliseconds: 120),
    );
  }

  Future<void> dispose() async {
    await _applausePlayer.dispose();
    _engine.dispose();
  }
}
