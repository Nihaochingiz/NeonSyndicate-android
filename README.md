# Neon Syndicate

An offline tactical card-game prototype for Android. Lead the Crimson Dragon
Clan against an AI-controlled rival family in a bright, modern crime-noir world.

## Download for Android

**[Download Neon Syndicate APK](https://github.com/Nihaochingiz/NeonSyndicate-android/raw/refs/heads/main/Neon-Syndicate-Prototype.apk)**

Requires Android 7.0 or newer. After downloading, open the APK on the phone and
allow installation from the browser or file manager if Android asks for it.

Version 1.1 features a fully Russian interface, larger cards and fighter icons,
and a new light palette with violet, coral, and turquoise accents.

## Prototype rules

- Both bosses begin with 30 health.
- Influence increases by one each turn, up to 10.
- Fighters stay on the board and can attack from the following turn.
- Select a ready fighter, then select an enemy fighter or the rival boss.
- Strike, healing, and crew-buff command cards resolve immediately.
- Reduce the rival boss to zero health to win.

## Content

- 12 original card designs and a 24-card shuffled deck
- Fighters, direct damage, healing, and team buffs
- AI card selection, board combat, and boss attacks
- Rematch flow and responsive mobile interface
- Fully offline play with no permissions or account

## Build

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

The installable prototype is also available as `Neon-Syndicate-Prototype.apk`.
