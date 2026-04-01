# tricking_bees_flutter

A trick-taking card game with unique role mechanics, built in Flutter. Currently being migrated to use the shared `flutter_game_framework`.

## Package Structure (Melos monorepo)

- **`packages/tb_core/`** - Game logic (dart-only)
  - `TBGame` extends `Game` from flutter_game_framework_core
  - 10 roles with distinct mechanics (Passer, Choose Trump, Double Mover, etc.)
  - Card system: 5 colors + special, Queen cards tied to roles
  - Game flow: waitingForPlayers -> roleSelection -> playingTricks -> finished
  - Subgame structure: multiple rounds per subgame, configurable subgame count
  - Logging: `TBLogEntryType` entries (card played, role chosen, trump chosen, etc.)
  - Translation: `TBTrObject` extends `TrObject`, `TBRichTrType` for cards/roles/colors
  - Entry point: `lib/tb_core.dart`

- **`packages/tricking_bees/`** - Flutter app
  - Game screens: `GameScreen` routes to WaitingDisplay, RoleSelectionDisplay, InGameDisplay, EndDisplay
  - Game board widget showing current trick, player cards, game log
  - Auto-play logic for offline bot games
  - Uses framework-provided screens (home, login, settings, etc.)
  - Entry point: `lib/main.dart`

- **`packages_external/`** - Symlinked dependencies
  - `flutter_game_framework/` (core + ui)
  - `yust/`, `yust_ui/`

## Key Dependencies

- `flutter_game_framework_core` / `flutter_game_framework_ui` - Shared game framework (local path)
- `easy_localization` - Translations from `assets/localizables/{en-US,de-DE}.json`
- `yust` / `yust_ui` - Firebase backend
- `flutter_riverpod` - State management
- `go_router` - Routing

## Migration Status (WIP)

**Done:**
- `tb_core` extends framework's `Game`, `Player`, `LogEntry`, `TrObject`
- App delegates to framework for auth screens, home, settings, game list
- Role system, card logic, trick mechanics all functional in tb_core

**Not done / broken:**
- `tb_game.service.dart` not generated (service builder commented out in exports)
- `TBGame` has unimplemented methods: `copy`, `init`, `start`
- Localization conflict: app uses `easy_localization` (`.tr()`, `context.tr()`), framework is migrating to Flutter built-in l10n
- Card removal UI is placeholder
- Some game start logic has TODOs ("look why this does not work")

## Game Logic

- 2-6 players, each dealt cards based on player count
- Each subgame: players select roles, then play trick rounds
- Trick resolution: highest card of led color wins (trump overrides)
- Points calculated per-role (most: 2pts/trick; some have special formulas)
- InputRequirement enum drives UI: selectRole, selectTrump, selectPlayer, selectCardToRemove, card, twoCards

## Translation Keys

Prefix-based system: `BUT:` (buttons), `ROLE:NAME:`, `ROLE:DESC:`, `LOG:`, `STATUS:`, `CARD:`, etc.
Files: `assets/localizables/en-US.json`, `de-DE.json`

## Common Commands

```bash
melos bootstrap           # Install all dependencies
melos run generate        # Run build_runner across packages
# Or per-package:
cd packages/tb_core && dart run build_runner build --delete-conflicting-outputs
cd packages/tricking_bees && dart run build_runner build --delete-conflicting-outputs
```
