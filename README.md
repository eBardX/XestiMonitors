# XestiMonitors

[![Swift3](https://img.shields.io/badge/Swift-3.0-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/cocoapods/l/XestiMonitors.svg)](http://cocoapods.org/pods/XestiMonitors)
[![Platform](https://img.shields.io/cocoapods/p/XestiMonitors.svg)](http://cocoapods.org/pods/XestiMonitors)
[![Version](https://img.shields.io/cocoapods/v/XestiMonitors.svg)](http://cocoapods.org/pods/XestiMonitors)

## Contents

* [Overview](#overview)
* [Reference Documentation](#reference_documentation)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
    * [Application Monitors](#application_monitors)
    * [Device Monitors](#device_monitors)
    * [Other Monitors](#other_monitors)
    * [Custom Monitors](#custom_monitors)
* [Credits](#credits)
* [License](#license)

## <a name="overview">Overview</a>

The XestiMonitors framework provides ...

## <a name="reference_documentation">Reference Documentation</a>

Full [reference documentation][refdocs] is available courtesy of [Jazzy][jazzy].

## <a name="requirements">Requirements</a>

- iOS 8.0+
- Xcode 8.0+
- Swift 3.0+

## <a name="installation">Installation</a>

XestiMonitors is available through [CocoaPods][cocoapods]. To install it,
simply add the following line to your Podfile:

```ruby
pod 'XestiMonitors'
```

## <a name="usage">Usage</a>

XestiMonitors provides almost a dozen fully-functional monitor classes right
out of the box that make it easy for your app to monitor and respond to many
common system-generated events. All monitors conform to the `Monitor` protocol.
This allows you to create arrays of monitors that can be started or stopped
uniformly and thereby save on coding.

For example, in a custom view controller, you can lazily instantiate several
monitors and then lazily instantiate an array variable containing the monitors:

```swift
lazy var keyboardMonitor: KeyboardMonitor = { KeyboardMonitor { /* do something… */ } }()

lazy var memoryMonitor: MemoryMonitor = { MemoryMonitor { /* do something… */ } }()

lazy var orientationMonitor: OrientationMonitor = { OrientationMonitor { /* do something… */ } }()

lazy var monitors: [Monitor] = { [self.keyboardMonitor,
                                  self.memoryMonitor,
                                  self.orientationMonitor] }()
```

Then, in the `viewWillAppear(_:)` and `viewWillDisappear(_:)` methods, you can
start and stop the monitors as a group:

```swift
override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(animated)

    monitors.forEach { $0.startMonitoring() }

}

override func viewWillDisappear(_ animated: Bool) {

    monitors.forEach { $0.stopMonitoring() }

    super.viewWillDisappear(animated)

}
```

### <a name="application_monitors">Application Monitors</a>

### <a name="device_monitors">Device Monitors</a>

### <a name="other_monitors">Other Monitors</a>

### <a name="custom_monitors">Custom Monitors</a>

## <a name="credits">Credits</a>

J. G. Pusey (ebardx@gmail.com)

## <a name="license">License</a>

XestiMonitors is available under [the MIT license][license].

[cocoapods]:    http://cocoapods.org
[jazzy]:        https://github.com/realm/jazzy
[license]:      https://github.com/eBardX/XestiMonitors/blob/master/LICENSE.md
[refdocs]:      https://eBardX.github.io/XestiMonitors/
