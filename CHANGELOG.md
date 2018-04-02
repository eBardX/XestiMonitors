# 2.6.0 (2018-04-02)

Adds support for three new monitor classes: `ScreenBrightnessMonitor`,
`ScreenModeMonitor`, and `TextViewTextMonitor`.

# 2.5.0 (2018-03-21)

* Adds support for new monitor class: `WindowMonitor`.
* Adds contributing guidelines.
* Adds issue template and pull request template.

# 2.4.0 (2018-03-19)

Adds support for new monitor class: `PasteboardMonitor`.

# 2.3.0 (2018-03-15)

* Adds support for three new monitor classes: `MetadataQueryMonitor`,
  `UbiquitousKeyValueStoreMonitor`, and `UbiquityIdentityMonitor`.
* Adds code of conduct document.

# 2.2.0 (2018-02-23)

* Adds support for new monitor class: `FileSystemObjectMonitor`.
* Changes the initializer parameter order for several monitor classes for
  consistency. (The old initializers have been deprecated, but are still
  available.)

# 2.1.0 (2018-02-16)

* Adds support for new monitor class: `DocumentStateMonitor`.
* Corrects the initializer parameter order for a few motion monitor classes.

# 2.0.1 (2018-01-18)

Makes dependency injection both simpler and more flexible.

# 2.0.0 (2018-01-11)

Major rewrite.

* Adds support for Swift 4 as well as macOS, tvOS, and watchOS platforms.
* Adds support for installation with Carthage and Swift Package Manager.
* Adds support for three new monitor classes: `AltimeterMonitor`,
  `MotionActivityMonitor`, and `PedometerMonitor`.
* Adds unit tests for all public classes.

**NOTE:** Developers using older versions of XestiMonitors will need to
manually conform to the new APIs introduced in this version. There is _no_
deprecation path. Sorry! Life is too short.

# 1.3.0 (2017-01-18)

Adds support for three new monitor classes:
`AccessibilityAnnouncementMonitor`, `AccessibilityElementMonitor`, and
`AccessibilityStatusMonitor`.

# 1.2.0 (2016-12-21)

Adds support for four new monitor classes: `AccelerometerMonitor`,
`DeviceMotionMonitor`, `GyroMonitor`, and `MagnetometerMonitor`.

# 1.1.0 (2016-12-06)

Adds support for new `ReachabilityMonitor` class.

# 1.0.1 (2016-12-06)

Adds `documentation_url` to podspec.

# 1.0.0 (2016-12-06)

Initial release.
