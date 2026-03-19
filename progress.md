Original prompt: integrate this tracks to the game

- Inspected `/Users/admin/Downloads/opera_collection_v2.html` and mapped the five opera entries into the Flutter `Track` model.
- Found the imported HTML only contains metadata and structure, not note/chord data, so the integration uses newly authored playable arrangements that match the listed titles and BPMs.
- Found the main menu hardcodes difficulty labels/colors for 22 acts; this needs to become data-driven before adding more tracks.
- Added five new playable tracks from the Gran Teatro collection with title, subtitle, BPM, theme, loop count, melody, chord, brass, and timpani data.
- Extended `Track` metadata with an optional `subtitle` and surfaced it in the act list.
- Replaced the fixed difficulty table with BPM-driven labels/colors and replaced the fixed 16-entry act label list with dynamic Roman numeral generation.
- Verification: `flutter analyze` passes.
