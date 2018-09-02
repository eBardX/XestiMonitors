# Changelog

All notable changes to this project will be documented in this file. The format
is based on [Keep a Changelog].

This project adheres to [Semantic Versioning].

## [Unreleased]

## [2.12.1] - 2018-09-02

### Changed

- Enhances unit testing to ensure that handler is executed on correct operation
  queue.

### Fixed

- Issues with `FileSystemObjectMonitor` and `HTTPCookieStorageMonitor` handlers
  being executed on incorrect operation queues.

## [2.12.0] - 2018-06-09

### Added

- Three new monitor classes: `CurrentLocaleMonitor`, `SystemClockMonitor`, and
  `URLCredentialStorageMonitor`.

### Fixed

- Issues with `MenuControllerMonitor` implementation.
- Issues with Swift Package Manager builds (for real this time).

## [2.11.0] - 2018-05-28

### Added

- Five new monitor classes: `BundleClassLoadMonitor`,
  `BundleResourceRequestMonitor`, `CalendarDayMonitor`, `ExtensionHostMonitor`,
  and `HTTPCookieStorageMonitor`.

### Fixed

- Issues with Swift Package Manager builds.

## [2.10.0] - 2018-05-20

### Added

- Six new monitor classes: `PortMonitor`, `ProcessInfoPowerStateMonitor`,
  `ProcessInfoThermalStateMonitor`, `SystemTimeZoneMonitor`,
  `UndoManagerMonitor`, and `UserDefaultsMonitor`.

### Changed

- Improves code coverage for `FocusMonitor`.

## [2.9.0] - 2018-05-01

### Added

- Three new monitor classes: `ContentSizeCategoryMonitor`,
  `TableViewSelectionMonitor`, and `TextStorageMonitor`.

### Changed

- Improves documentation.

## [2.8.0] - 2018-04-15

### Added

- Four new monitor classes: `FocusMonitor`, `MenuControllerMonitor`,
  `ScreenConnectionMonitor`, and `ViewControllerShowDetailTargetMonitor`.

### Changed

- Improves code coverage.
- Reorganizes README and reference documentation.

## [2.7.0] - 2018-04-09

### Added

- Ten new monitor classes: `BeaconRangingMonitor`, `HeadingMonitor`,
  `LocationAuthorizationMonitor`, `RegionMonitor`, `ScreenCapturedMonitor`,
  `SignificantLocationMonitor`, `StandardLocationMonitor`,
  `TextFieldTextMonitor`, `TextInputModeMonitor`, and `VisitMonitor`.

### Changed

- Improves code coverage.
- Enhances iOS and tvOS demo apps.

### Removed

- Deprecated initializers for several monitor classes.

## [2.6.0] - 2018-04-02

### Added

- Three new monitor classes: `ScreenBrightnessMonitor`, `ScreenModeMonitor`,
  and `TextViewTextMonitor`.

## [2.5.0] - 2018-03-21

### Added

- New monitor class: `WindowMonitor`.
- Contributing guidelines.
- Issue template and pull request template.

## [2.4.0] - 2018-03-19

### Added

- New monitor class: `PasteboardMonitor`.

## [2.3.0] - 2018-03-15

### Added

- Three new monitor classes: `MetadataQueryMonitor`,
  `UbiquitousKeyValueStoreMonitor`, and `UbiquityIdentityMonitor`.
- Code of conduct document.

## [2.2.0] - 2018-02-23

### Added

- New monitor class: `FileSystemObjectMonitor`.

### Changed

- Initializer parameter order for several monitor classes for consistency.

### Deprecated

- Old initializers for several monitor classes.

## [2.1.0] - 2018-02-16

### Added

- New monitor class: `DocumentStateMonitor`.

### Fixed

- Initializer parameter order for a few motion monitor classes.

## [2.0.1] - 2018-01-18

### Changed

- Makes dependency injection both simpler and more flexible.

## [2.0.0] - 2018-01-11

Major rewrite.

### Added

- Support for Swift 4.
- Support for macOS, tvOS, and watchOS platforms.
- Support for installation with Carthage and Swift Package Manager.
- Three new monitor classes: `AltimeterMonitor`, `MotionActivityMonitor`, and
  `PedometerMonitor`.
- Unit tests for all public classes.

### Deprecated

> **Note:** Developers using older versions of XestiMonitors will need to
> manually conform to the new APIs introduced in this version. There is _no_
> deprecation path. Sorry! Life is too short.

## [1.3.0] - 2017-01-18

### Added

- Three new monitor classes: `AccessibilityAnnouncementMonitor`,
  `AccessibilityElementMonitor`, and `AccessibilityStatusMonitor`.

## [1.2.0] - 2016-12-21

### Added

- Four new monitor classes: `AccelerometerMonitor`, `DeviceMotionMonitor`,
  `GyroMonitor`, and `MagnetometerMonitor`.

## [1.1.0] - 2016-12-06

### Added

- New `ReachabilityMonitor` class.

## [1.0.1] - 2016-12-06

### Added

- Missing `documentation_url` in podspec.

## 1.0.0 - 2016-12-06

Initial release.

[Unreleased]:   https://github.com/eBardX/XestiMonitors/compare/v2.12.1...HEAD
[2.12.1]:       https://github.com/eBardX/XestiMonitors/compare/v2.12.0...v2.12.1
[2.12.0]:       https://github.com/eBardX/XestiMonitors/compare/v2.11.0...v2.12.0
[2.11.0]:       https://github.com/eBardX/XestiMonitors/compare/v2.10.0...v2.11.0
[2.10.0]:       https://github.com/eBardX/XestiMonitors/compare/v2.9.0...v2.10.0
[2.9.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.8.0...v2.9.0
[2.8.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.7.0...v2.8.0
[2.7.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.6.0...v2.7.0
[2.6.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.5.0...v2.6.0
[2.5.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.4.0...v2.5.0
[2.4.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.3.0...v2.4.0
[2.3.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.2.0...v2.3.0
[2.2.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.1.0...v2.2.0
[2.1.0]:        https://github.com/eBardX/XestiMonitors/compare/v2.0.1...v2.1.0
[2.0.1]:        https://github.com/eBardX/XestiMonitors/compare/v2.0.0...v2.0.1
[2.0.0]:        https://github.com/eBardX/XestiMonitors/compare/v1.3.0...v2.0.0
[1.3.0]:        https://github.com/eBardX/XestiMonitors/compare/v1.2.0...v1.3.0
[1.2.0]:        https://github.com/eBardX/XestiMonitors/compare/v1.1.0...v1.2.0
[1.1.0]:        https://github.com/eBardX/XestiMonitors/compare/v1.0.1...v1.1.0
[1.0.1]:        https://github.com/eBardX/XestiMonitors/compare/v1.0.0...v1.0.1

[Keep a Changelog]:     https://keepachangelog.com
[Semantic Versioning]:  https://semver.org
