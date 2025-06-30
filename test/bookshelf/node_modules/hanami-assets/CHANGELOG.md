# hanami-assets

Assets management via Esbuild

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

## [v2.2.2] - 2025-03-14

### Changed

- Bump esbuild dependency to `^0.25.1`. This brings in [the security fix in 0.25.0](https://github.com/evanw/esbuild/releases/tag/v0.25.0) and allows Hanami projects to address the related security warnings (@timriley in #35).

## v2.2.1 - 2024-11-12

## v2.2.0 - 2024-11-05

## v2.2.0.rc.1 - 2024-10-29

## v2.2.0.beta.2 - 2024-09-25

## v2.2.0.beta.1 - 2024-07-16

### Added

- [Sven Schwyn] Support for `.avip` and `.webp` formats (#28)

## v2.1.1 - 2024-04-01

### Fixed

- [Tim Riley, krzykamil] Support references to assets in other directories from from JS and CSS files (in js/ and css/)

## v2.1.0 - 2024-02-27

## v2.1.0-rc.3 - 2024-02-16

### Changed

- [Tim Riley] Compile a single directory of assets only (specified by arguments), instead of crawling the app
  structure to detect assets. The `--path` argument specifies the source directory of assets, and `--dest` specifies
  the directory to output the compiled assets and the manifest file. The `hanami assets` CLI commands will provide
  these arguments for each slice, so that each slice has its own separate compiled assets directory and manifest file.

### Fixed

- [Phil Arndt] Copy asset files from deeply nested directories.

## v2.1.0-rc.2 - 2023-11-02

### Added

- [Luca Guidi] Official support for Node 20 and 21

### Changed

- [Luca Guidi] Drop support for Node 18

## v2.1.0-rc.1 - 2023-11-01

### Changed

- [Tim Riley] Removed `hanami-assets` executable
- [Tim Riley] Export `run` function as main entry point for running Hanami assets commands.

## v2.1.0-beta.2 - 2023-10-04

### Added

- [Luca Guidi] Assets watch mode
- [Luca Guidi] Handle static files (images, fonts)
- [Luca Guidi] Subresource Integrity
- [Luca Guidi] Assets manifest
- [Luca Guidi] Assets compilation

[unreleased]: https://github.com/hanami/assets-js/compare/v2.2.2...HEAD
[v2.2.2]: https://github.com/olivierlacan/keep-a-changelog/compare/v2.2.1...v2.2.2
