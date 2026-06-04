# Daedalus Scan

Canonical iOS field-capture application for the Daedalus platform.

## Purpose

Daedalus Scan captures structured survey data, photos and voice notes for site visits. It does not generate recommendations, quotations, pricing or customer advice.

## Architecture

- SwiftUI application target
- iOS only
- XcodeGen is the source of truth
- MVVM presentation flow
- `DaedalusContracts` local package for canonical shared models
- JSON persistence for local-first storage

## Features in this scaffold

- Visit list
- Create visit workflow
- Room list workflow
- Structured survey questions per room
- Photo capture attachment
- Voice note attachment
- Export/import visit packages

## Getting started

1. Install XcodeGen on macOS (`brew install xcodegen`).
2. Generate the project from the checked-in spec:
   ```bash
   xcodegen generate
   ```
3. Open the generated `DaedalusScan.xcodeproj` in Xcode.
4. Select a physical iPhone target and run.

Generated Xcode project artefacts are intentionally excluded from source control.

## Shared contracts tests

The shared contract package can be validated from a fresh clone with:

```bash
cd DaedalusContracts
swift test
```
