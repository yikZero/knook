# Release Checklist

## Build and signing

- Confirm Xcode is selected with `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
- Set the Developer ID signing identity
- Archive the app bundle
- Notarize the build
- Staple the notarization ticket

## Functional QA

- Menu bar icon updates when a break starts
- Reminder panel appears before the next break
- Break overlay shows the configured message, sound, and background
- Skip, postpone, early end, and manual pause behave as expected
- Launch at login can be toggled on and off
- Office hours suppress reminders outside the configured window
- Idle reset starts a fresh timer after stepping away

## Distribution

- Attach screenshots to the release notes
- Publish the notarized archive
- Update the Homebrew cask with the new version and SHA
