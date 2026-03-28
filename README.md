# Nook

Nook is a privacy-first, open-source macOS break reminder that lives in your menu bar and helps you keep a gentler work rhythm without accounts, subscriptions, or cloud syncing.

**Status:** Early alpha  
**Platform:** macOS 13+  
**Distribution:** Source build only for now  
**Privacy:** Local-only settings, no server component

## What Nook Is

Nook is a native SwiftUI menu bar app for screen-break reminders on macOS. It combines a simple break timer with context-aware pause behavior so reminders can stay helpful without feeling as interruptive during focused work.

## Why This Exists

Healthy break reminders should be available without a paywall, account system, or opaque syncing model. Nook is being built as a community-owned, privacy-first alternative in this category, starting with a practical local-first MVP and growing from there.

## Current Status

Nook is in early alpha. The core app structure is in place, the scheduler works, and the menu bar flow is usable for local development, but the project is not yet packaged as a polished public app.

Today that means:

- Expect rough edges in UI, onboarding, and contributor workflows.
- Expect implementation details and project structure to continue changing.
- Do not treat the current repo as a notarized, end-user-ready release yet.

## Features Available Today

- Native macOS menu bar app in SwiftUI
- Break scheduler core in `NookKit`
- Short and long breaks
- Heads-up reminder panel
- Break overlay window
- Postpone, skip, early end, and manual pause/resume
- Office hours, idle reset, and launch-at-login wiring
- Smart pause for full-screen focus
- Versioned local JSON settings

## Requirements and Local Setup

There is no packaged or notarized download yet. The current way to try Nook is to build it from source.

You will need:

- macOS 13 or newer
- A current Swift toolchain
- A full Xcode installation for the best local development experience

Clone the repo, then build and run it from the project root.

## Build, Test, and Run

Build the app:

```bash
swift build
```

Run the menu bar app:

```bash
swift run Nook
```

Force starter setup during local development:

```bash
NOOK_FORCE_ONBOARDING=1 swift run Nook
```

Test command:

```bash
swift test
```

Notes:

- A full Xcode installation is currently needed for the test workflow in this repository.
- The public contributor test setup still needs cleanup before it is as smooth as the build and run flow.

## Known Limitations

- Source build and developer setup are required today.
- There is no notarized app bundle, packaged release, or Homebrew install yet.
- Screenshots and demo assets are not included in the README yet.
- Packaging, notarization, and release distribution are still in progress rather than current deliverables.

## Contributing

Contributions are welcome, especially around scheduler behavior, macOS polish, onboarding, and documentation.

Start with [CONTRIBUTING.md](CONTRIBUTING.md) for local setup expectations and contribution guidelines. If you find a bug or want to propose a feature, open an issue or feature request in GitHub.

## Privacy

Nook stores its settings locally in Application Support and does not send data to a server.

## License

Nook is available under the [MIT License](LICENSE).

## Roadmap

### Near term

- Polish the reminder and break overlay interactions
- Improve keyboard accessibility and labeling
- Strengthen smart timing beyond the current MVP
- Tighten the public contributor workflow

### Later

- Additional smart pause providers such as meetings and video contexts
- AppleScript or Shortcuts support
- Focus Filters integration
- Notarized distribution and release packaging

## Repository Follow-Ups

Before broader public promotion, the repo would benefit from a few standard open-source community docs:

- `SECURITY.md` for vulnerability reporting guidance
- `CODE_OF_CONDUCT.md` for contributor expectations
- Optional `SUPPORT.md` if the project wants a support path beyond GitHub issues

After that, the next practical cleanup is repairing the stale test workflow so the repo matches its contributor-facing documentation more closely.
