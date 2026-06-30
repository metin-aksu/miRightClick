# CLAUDE.md

Working notes for Claude Code when developing **miRightClick**.

## What this app does

Adds a **New Text File** item to Finder's right-click (contextual) menu when the
user right-clicks the **empty background area** inside a folder. Selecting it
creates `untitled.txt` in that folder (with collision-safe naming).

## Architecture

This is a macOS host app + an embedded **Finder Sync extension**. The extension
is the only Apple-sanctioned way to inject items into the Finder contextual menu.

```
miRightClick.app                 (host app — onboarding, settings, enable UI)
└── Contents/PlugIns/
    └── FinderExtension.appex     (Finder Sync extension — the actual menu + file creation)
```

### Targets
- **miRightClick** (existing) — host app. Bundle ID `com.metinaksu.miRightClick`.
  SwiftUI. Its job: explain how to enable the extension (System Settings →
  General → Login Items & Extensions), optionally configure monitored folders,
  and host the `.appex`.
- **FinderExtension** (to be added) — Finder Sync extension. Bundle ID
  `com.metinaksu.miRightClick.FinderExtension`. Subclass of `FIFinderSync`.

Both targets: Team `Y5K2497B6G`, Automatic signing, macOS deployment 26.5.

## Key API facts (don't re-derive these)

- Subclass `FIFinderSync` (from `FinderSync` framework). Set it as the extension's
  principal class.
- **Monitored directories**: in `init()` set
  `FIFinderSyncController.default().directoryURLs = [ <root> ]`. The menu ONLY
  appears inside these directories (and their subfolders). Default root = user's
  home directory. This also grants the sandboxed extension read/write access to
  those directories — which is how file creation works without extra prompts.
- **Menu**: override `menu(for menuKind: FIMenuKind) -> NSMenu?`.
  - Right-click on empty folder background → `.contextualMenuForContainer` ← our case.
  - Right-click on selected items → `.contextualMenuForItems` (ignore for v1).
  - Return `nil` for other kinds.
- **Target folder of a container right-click**:
  `FIFinderSyncController.default().targetedURL()` returns the folder being viewed.
- Menu item action is an `@objc func` selector on the `FIFinderSync` subclass.

## File creation rules

- Base name `untitled.txt`. If it exists, fall back to `untitled 2.txt`,
  `untitled 3.txt`, … (macOS-style). Never overwrite.
- Create empty file via `FileManager.default.createFile(atPath:contents:)`.
- Write into `targetedURL()`'s directory.

## Sandbox / entitlements

- App Sandbox stays **enabled** on the extension (required for the extension to
  load cleanly and for Developer-ID distribution hygiene).
- File writes succeed because Finder Sync grants the extension access to its
  monitored directory tree. Do NOT assume arbitrary filesystem access.
- Use an **App Group** (`group.com.metinaksu.miRightClick`) if host and extension
  need to share settings (e.g. user-chosen monitored folders).

## Build / run / debug

```bash
# Build (host scheme builds and embeds the extension)
xcodebuild -project miRightClick.xcodeproj -scheme miRightClick -configuration Debug build

# Inspect / toggle the extension registration
pluginkit -m | grep miRightClick
pluginkit -e use -i com.metinaksu.miRightClick.FinderExtension

# Reload Finder after enabling / after rebuilds
killall Finder
```

Manual verification: run host app → enable the Finder extension in System
Settings → `killall Finder` → open any folder under the monitored root →
right-click empty space → confirm **New Text File** appears and creates the file.

## Gotchas

- The extension does NOT appear until enabled in System Settings at least once.
- Changes to the extension require `killall Finder` (sometimes a re-enable) to
  take effect — Finder caches the loaded plugin.
- The menu will not show outside monitored directories — by design. If "it doesn't
  work", first check the right-clicked folder is under the monitored root.
- Don't add the menu for `.contextualMenuForItems` in v1; we only target empty-space.

## Status

Planning phase. Source not yet written — see ROADMAP.md. Do not start coding until
the user gives the go-ahead.
