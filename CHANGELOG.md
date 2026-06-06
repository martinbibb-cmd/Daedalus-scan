# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

### Changed
- Reset the product direction to spatial-first, camera-first capture.
- Updated the documentation to describe Daedalus Scan as a walk-the-job scanning app instead of a non-LiDAR or form-first scaffold.
- Changed visit creation so opening or creating a visit lands directly in live capture.
- Stopped auto-creating a placeholder room during visit creation; scanned areas now emerge from capture.
- Added explicit spatial placement metadata and fallback state to exported rooms/areas and components.

### Added
- Spatial placement contract types for anchor metadata, approximate positions, confidence, and capture fallback state.
- Secondary fallback detail views that expose spatial metadata for captured areas and objects.
