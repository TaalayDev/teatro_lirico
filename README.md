# Teatro Lirico: Rhythm Opera (Flutter)

A symphonic rhythm game built with Flutter and **synthkit** for cross-platform audio synthesis.

## Prerequisites

- Flutter SDK ≥ 3.29.0
- Dart SDK ≥ 3.7.0

## Setup

```bash
cd teatro_lirico
flutter pub get
```

## Run

```bash
# Desktop (macOS / Windows)
flutter run -d macos
flutter run -d windows

# Web
flutter run -d chrome

# iOS Simulator
flutter run -d <simulator-id>
```

## Controls

| Key | Lane |
|-----|------|
| ← Arrow Left | Red (Lane 0) |
| ↓ Arrow Down | Gold (Lane 1) |
| ↑ Arrow Up | Green (Lane 2) |
| → Arrow Right | Blue (Lane 3) |

**Hold** long notes until they finish for bonus points.

## Architecture

```
lib/
├── main.dart                    # Entry point
├── audio/
│   ├── audio_engine.dart        # synthkit wrapper
│   └── music_utils.dart         # Musical time / note utilities
├── models/
│   ├── game_models.dart         # GameNote, Particle, FeedbackText, etc.
│   └── track_data.dart          # 3 acts with melody/chord/brass/timpani data
├── painters/
│   ├── concert_painter.dart     # Opera stage visuals (left panel)
│   └── rhythm_painter.dart      # Scrolling note lanes (right panel)
└── screens/
    └── game_screen.dart         # Main game loop, input, state management
```

## Notes

- **synthkit** handles synthesis on all platforms (Tone.js on web, native AVAudioEngine/AudioTrack on mobile/desktop).
- The game uses `CustomPainter` for all rendering — no game engine dependency needed.
- Background music (strings, brass, timpani) is scheduled via `SynthKitTransport`.
- Vocal notes are triggered live when the player hits correctly.
- Linux is not supported by synthkit at this time.
