# XestiMonitors

[![Build Status](https://travis-ci.org/eBardX/XestiMonitors.svg?branch=master)](https://travis-ci.org/eBardX/XestiMonitors)
[![Platform](https://img.shields.io/cocoapods/p/XestiMonitors.svg)](http://cocoapods.org/pods/XestiMonitors)
[![Version](https://img.shields.io/cocoapods/v/XestiMonitors.svg)](http://cocoapods.org/pods/XestiMonitors)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://cocoapods.org/pods/XestiMonitors)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-blue.svg)](https://developer.apple.com/swift/)
[![Documented](https://img.shields.io/cocoapods/metrics/doc-percent/XestiMonitors.svg)](http://ebardx.github.io/XestiMonitors/)

* [Overview](#overview)
* [Reference Documentation](#reference_documentation)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
    * [Application Monitors](#application_monitors)
    * [Device Monitors](#device_monitors)
    * [Motion Monitors](#motion_monitors)
    * [Accessibility Monitors](#accessibility_monitors)
    * [Other Monitors](#other_monitors)
    * [Custom Monitors](#custom_monitors)
* [Credits](#credits)
* [License](#license)

## <a name="overview">Overview</a>

The XestiMonitors framework provides nearly two dozen fully-functional monitor
classes right out of the box that make it easy for your iOS app to detect and
respond to many common system-generated events.

Among other things, you can think of XestiMonitors as a better way to manage
the most common iOS notifications. At present, XestiMonitors provides
“wrappers” around many `UIKit` notifications:

* **Accessibility-related**

    * `UIAccessibilityAnnouncementDidFinish`
    * `UIAccessibilityAssistiveTouchStatusDidChange`
    * `UIAccessibilityBoldTextStatusDidChange`
    * `UIAccessibilityClosedCaptioningStatusDidChange`
    * `UIAccessibilityDarkerSystemColorsStatusDidChange`
    * `UIAccessibilityElementFocused`
    * `UIAccessibilityGrayscaleStatusDidChange`
    * `UIAccessibilityGuidedAccessStatusDidChange`
    * `UIAccessibilityHearingDevicePairedEarDidChange`
    * `UIAccessibilityInvertColorsStatusDidChange`
    * `UIAccessibilityMonoAudioStatusDidChange`
    * `UIAccessibilityReduceMotionStatusDidChange`
    * `UIAccessibilityReduceTransparencyStatusDidChange`
    * `UIAccessibilityShakeToUndoDidChange`
    * `UIAccessibilitySpeakScreenStatusDidChange`
    * `UIAccessibilitySpeakSelectionStatusDidChange`
    * `UIAccessibilitySwitchControlStatusDidChange`
    * `UIAccessibilityVoiceOverStatusDidChange`

    See [Accessibility Monitors](#accessibility_monitors) for details.

* **Application-related**

    * `UIApplicationBackgroundRefreshStatusDidChange`
    * `UIApplicationDidBecomeActive`
    * `UIApplicationDidChangeStatusBarFrame`
    * `UIApplicationDidChangeStatusBarOrientation`
    * `UIApplicationDidEnterBackground`
    * `UIApplicationDidFinishLaunching`
    * `UIApplicationDidReceiveMemoryWarning`
    * `UIApplicationProtectedDataDidBecomeAvailable`
    * `UIApplicationProtectedDataWillBecomeUnavailable`
    * `UIApplicationSignificantTimeChange`
    * `UIApplicationUserDidTakeScreenshot`
    * `UIApplicationWillChangeStatusBarFrame`
    * `UIApplicationWillChangeStatusBarOrientation`
    * `UIApplicationWillEnterForeground`
    * `UIApplicationWillResignActive`
    * `UIApplicationWillTerminate`

    See [Application Monitors](#application_monitors) for details.

* **Device-related**

    * `UIDeviceBatteryLevelDidChange`
    * `UIDeviceBatteryStateDidChange`
    * `UIDeviceOrientationDidChange`
    * `UIDeviceProximityStateDidChange`

    See [Device Monitors](#device_monitors) for details.

* **Keyboard-related**

    * `UIKeyboardDidChangeFrame`
    * `UIKeyboardDidHide`
    * `UIKeyboardDidShow`
    * `UIKeyboardWillChangeFrame`
    * `UIKeyboardWillHide`
    * `UIKeyboardWillShow`

    See [Other Monitors](#other_monitors) for details.

XestiMonitors also provides a “wrapper” around `CMMotionManager` to
make it easier for your app to obtain both raw and processed motion
measurements from the device. See [Motion Monitors](#motion_monitors) for
details.

XestiMonitors also provides a “wrapper” around `SCNetworkReachability` to make
it super easy for your app to determine the reachability of a target host. See
[Other Monitors](#other_monitors) for details.

Additional monitors targeting even more parts of iOS will be rolled out in
future releases of XestiMonitor!

Finally, XestiMonitors is *extensible*—you can easily create your own *custom*
monitors. See [Custom Monitors](#custom_monitors) for details.

## <a name="reference_documentation">Reference Documentation</a>

Full [reference documentation][refdoc] is available courtesy of [Jazzy][jazzy].

## <a name="requirements">Requirements</a>

* iOS 9.0+
* Xcode 9.0+
* Swift 4.0+

## <a name="installation">Installation</a>

XestiMonitors is available through [CocoaPods][cocoapods]. To install it,
simply add the following line to your Podfile:

```ruby
pod 'XestiMonitors'
```

## <a name="usage">Usage</a>

All monitor classes conform to the [Monitor][p_monitor] protocol, thus
enabling you to create arrays of monitors that can be started or
stopped uniformly—fewer lines of code!

For example, in a view controller, you can lazily instantiate several
monitors and, in addition, lazily instantiate an array variable containing
these monitors:

```swift
import XestiMonitors

lazy var keyboardMonitor = KeyboardMonitor { [unowned self] in
    // do something…
}
lazy var memoryMonitor = MemoryMonitor { [unowned self] in
    // do something…
}
lazy var orientationMonitor = OrientationMonitor { [unowned self] in
    // do something…
}
lazy var monitors: [Monitor] = [self.keyboardMonitor,
                                self.memoryMonitor,
                                self.orientationMonitor]
```

Then, in the `viewWillAppear(_:)` and `viewWillDisappear(_:)` methods, you can
simply start or stop all these monitors with a single line of code:

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

Easy peasy!

### <a name="application_monitors">Application Monitors</a>

XestiMonitors provides seven monitor classes that you can use to observe common
events generated by the system about the app:

* [ApplicationStateMonitor][application_state_monitor] to monitor the app for
  changes to its runtime state.
* [BackgroundRefreshMonitor][background_refresh_monitor] to monitor the app for
  changes to its status for downloading content in the background.
* [MemoryMonitor][memory_monitor] to monitor the app for memory warnings from
  the operating system.
* [ProtectedDataMonitor][protected_data_monitor] to monitor the app for changes
  to the accessibility of protected files.
* [ScreenshotMonitor][screenshot_monitor] to monitor the app for screenshots.
* [StatusBarMonitor][status_bar_monitor] to monitor the app for changes to the
  orientation of its user interface or to the frame of the status bar.
* [TimeMonitor][time_monitor] to monitor the app for significant changes in
  time.

### <a name="device_monitors">Device Monitors</a>

XestiMonitors provides three monitor classes that you can use to detect changes
in the characteristics of the device:

* [BatteryMonitor][battery_monitor] to monitor the device for changes to the
  charge state and charge level of its battery.
* [OrientationMonitor][orientation_monitor] to monitor the device for changes
  to its physical orientation.
* [ProximityMonitor][proximity_monitor] to monitor the device for changes to
  the state of its proximity sensor.

### <a name="motion_monitors">Motion Monitors</a>

XestiMonitors provides seven monitor classes that you can use to obtain raw and
processed motion measurements from the device:

* [AccelerometerMonitor][accelerometer_monitor] to monitor the device’s
  accelerometer for periodic raw measurements of the acceleration along the
  three spatial axes.
* [AltimeterMonitor][altimeter_monitor] to monitor the device for changes in
  relative altitude.
* [DeviceMotionMonitor][device_motion_monitor] to monitor the device’s
  accelerometer, gyroscope, and magnetometer for periodic raw measurements
  which are processed into device motion measurements.
* [GyroscopeMonitor][gyroscope_monitor] to monitor the device’s gyroscope for
  periodic raw measurements of the rotation rate around the three spatial axes.
* [MagnetometerMonitor][magnetometer_monitor] to monitor the device’s
  magnetometer for periodic raw measurements of the magnetic field around the
  three spatial axes.
* [MotionActivityMonitor][motion_activity_monitor] to provide access to the
  motion data stored by the device.
* [PedometerMonitor][pedometer_monitor] to monitor the device to fetch
  pedestrian-related data.

### <a name="accessibility_monitors">Accessibility Monitors</a>

XestiMonitors provides three monitor classes that you can use to observe
accessibility events generated by the system:

* [AccessibilityAnnouncementMonitor][accessibility_announcement_monitor] to
  monitor the system for accessibility announcements that VoiceOver has
  finished outputting.
* [AccessibilityElementMonitor][accessibility_element_monitor] to monitor the
  system for changes to element focus by an assistive technology.
* [AccessibilityStatusMonitor][accessibility_status_monitor] to monitor the
  system for changes to the status of various accessibility settings.

### <a name="other_monitors">Other Monitors</a>

In addition, XestiMonitors provides two other monitors:

* [KeyboardMonitor][keyboard_monitor] to monitor the keyboard for changes to
  its visibility or to its frame.
* [NetworkReachabilityMonitor][network_reachability_monitor] to monitor a
  network node name or address for changes to its reachability.

[KeyboardMonitor][keyboard_monitor] is especially handy in removing lots of
boilerplate code from your app. This is how keyboard monitoring is typically
handled in a custom view controller:

```swift
func keyboardWillHide(_ notification: Notification) {
    let userInfo = notification.userInfo
    var animationDuration: TimeInterval = 0
    if let value = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
        animationDuration = value
    }
    constraint.constant = 0
    UIView.animate(withDuration: animationDuration) {
        self.view.layoutIfNeeded()
    }
}

func keyboardWillShow(_ notification: Notification) {
    let userInfo = notification.userInfo
    var animationDuration: TimeInterval = 0
    if let value = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
        animationDuration = value
    }
    var frameEnd = CGRect.zero
    if let value = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        frameEnd = value
    }
    constraint.constant = frameEnd.height
    UIView.animate(withDuration: animationDuration) {
        self.view.layoutIfNeeded()
    }
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let nc = NotificationCenter.`default`
    nc.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                   name: .UIKeyboardWillHide, object: nil)
    nc.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                   name: .UIKeyboardWillShow, object: nil)
}

override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.`default`.removeObserver(self)
    super.viewWillDisappear(animated)
}
```

And this is the XestiMonitors way using [KeyboardMonitor][keyboard_monitor]:

```swift
import XestiMonitors

lazy var keyboardMonitor = KeyboardMonitor { [unowned self] event in
    guard let constraint = self?.constraint,
          let view = self?.view else { return }
    switch event {
    case let .willHide(info):
        constraint.constant = 0
        UIView.animate(withDuration: info.animationDuration) {
            view.layoutIfNeeded()
        }
    case let .willShow(info):
        constraint.constant = info.frameEnd.height
        UIView.animate(withDuration: info.animationDuration) {
            view.layoutIfNeeded()
        }
    default:
        break
    }
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    keyboardMonitor.startMonitoring()
}

override func viewWillDisappear(_ animated: Bool) {
    keyboardMonitor.stopMonitoring()
    super.viewWillDisappear(animated)
}
```

What’s in *your* wallet?

### <a name="custom_monitors">Custom Monitors</a>

Best of all, the XestiMonitors framework provides several ways to create your
own custom monitors quite easily.

#### Implementing the Monitor Protocol

You can create a new class, or extend an existing class, that conforms to the
[Monitor][p_monitor] protocol. You need only implement the
[startMonitoring()][m_start_monitoring] and
[stopMonitoring()][m_stop_monitoring] methods, as well as the
[isMonitoring][m_is_monitoring] property:

```swift
import XestiMonitors

extension MegaHoobieWatcher: Monitor {
    var isMonitoring: Bool { return watchingForHoobiesCount() > 0 }

    func startMonitoring() -> Bool {
        guard !isMonitoring else { return }
        beginWatchingForHoobies()
    }

    func stopMonitoring() -> Bool {
        guard isMonitoring else { return }
        endWatchingForHoobies()
    }
}
```

**Note:** The guard statements in both [startMonitoring()][m_start_monitoring]
and [stopMonitoring()][m_stop_monitoring] protect against starting or stopping
the monitor if it is in the incorrect state. This is considered good coding
practice.

#### Subclassing the BaseMonitor Class

Typically, you will want to create a subclass of [BaseMonitor][base_monitor].
The advantage of using this abstract base class is that the basic guard logic
is taken care of for you. Specifically, the
[startMonitoring()][bm_start_monitoring] method does not attempt to start the
monitor if it is already active, and the [stopMonitoring()][bm_stop_monitoring]
method does not attempt to stop the monitor if it is *not* active. Instead of
directly implementing the required protocol methods and properties, you need
only override the [configureMonitor()][bm_configureMonitor] and
[cleanupMonitor()][bm_cleanupMonitor] methods of this base class. In fact, you
will *not* be able to override the [startMonitoring()][bm_start_monitoring] and
[stopMonitoring()][bm_stop_monitoring] methods or the
[isMonitoring][bm_is_monitoring] property—they are declared `final` in
[BaseMonitor][base_monitor].

```swift
import XestiMonitors

class GigaHoobieMonitor: BaseMonitor {
    let handler: (Float) -> Void
    @objc let hoobie: GigaHoobie
    private var observation: NSKeyValueObservation?

    init(_ hoobie: GigaHoobie, handler: @escaping (Float) -> Void) {
        self.handler = handler
        self.hoobie = hoobie
    }

    override func configureMonitor() -> Bool {
        super.configureMonitor()
        observation = hoobie.observe(\.nefariousActivityLevel) { [unowned self] hoobie, _ in
            self.handler(hoobie.nefariousActivityLevel) }
    }

    override func cleanupMonitor() -> Bool {
        observation?.invalidate()
        observation = nil
        super.cleanupMonitor()
    }
}
```

**Note:** Be sure to invoke the superclass implementations of both
[configureMonitor()][bm_configureMonitor] and
[cleanupMonitor()][bm_cleanupMonitor].

#### Subclassing the BaseNotificationMonitor Class

If your custom monitor determines events by observing notifications, you should
consider creating a subclass of
[BaseNotificationMonitor][base_notification_monitor] instead. In most cases you
need only override the
[addNotificationObservers(_:)][bnm_addNotificationObservers] method. You can
also override the
[removeNotificationObservers(_:)][bnm_removeNotificationObservers] method if
you require extra cleanup when the notification observers are removed upon
stopping the monitor. Although this base class inherits from
[BaseMonitor][base_monitor], you will *not* be able to override the
[configureMonitor()][bnm_configureMonitor] and
[cleanupMonitor()][bnm_cleanupMonitor] methods—they are declared `final` in
[BaseNotificationMonitor][base_notification_monitor].

```swift
import XestiMonitors

class TeraHoobieMonitor: BaseNotificationMonitor {
    let handler: (Bool) -> Void
    let hoobie: TeraHoobie

    init(hoobie: TeraHoobie, queue: OperationQueue = .main,
         handler: @escaping (Bool) -> Void) {
        self.handler = handler
        self.hoobie = hoobie
        super.init(queue: queue)
    }

    override func addNotificationObservers() -> Bool {
        super.addNotificationObservers()
        observe(.teraHoobieDidChange) { [unowned self] _ in
            self.handler(self.hoobie.value) }
    }
}
```

**Note:** Be sure to invoke the superclass implementations of both
[addNotificationObservers(_:)][bnm_addNotificationObservers] and
[removeNotificationObservers(_:)][bnm_removeNotificationObservers] in your
overrides.

## <a name="credits">Credits</a>

J. G. Pusey (ebardx@gmail.com)

## <a name="license">License</a>

XestiMonitors is available under [the MIT license][license].

[cocoapods]:    http://cocoapods.org
[jazzy]:        https://github.com/realm/jazzy
[license]:      https://github.com/eBardX/XestiMonitors/blob/master/LICENSE.md
[refdoc]:       https://eBardX.github.io/XestiMonitors/

[accelerometer_monitor]:                https://eBardX.github.io/XestiMonitors/Classes/AccelerometerMonitor.html
[accessibility_announcement_monitor]:   https://eBardX.github.io/XestiMonitors/Classes/AccessibilityAnnouncementMonitor.html
[accessibility_element_monitor]:        https://eBardX.github.io/XestiMonitors/Classes/AccessibilityElementMonitor.html
[accessibility_status_monitor]:         https://eBardX.github.io/XestiMonitors/Classes/AccessibilityStatusMonitor.html
[altimeter_monitor]:                    https://eBardX.github.io/XestiMonitors/Classes/AltimeterMonitor.html
[device_motion_monitor]:                https://eBardX.github.io/XestiMonitors/Classes/DeviceMotionMonitor.html
[gyroscope_monitor]:                    https://eBardX.github.io/XestiMonitors/Classes/GyroscopeMonitor.html
[magnetometer_monitor]:                 https://eBardX.github.io/XestiMonitors/Classes/MagnetometerMonitor.html
[application_state_monitor]:            https://eBardX.github.io/XestiMonitors/Classes/ApplicationStateMonitor.html
[background_refresh_monitor]:           https://eBardX.github.io/XestiMonitors/Classes/BackgroundRefreshMonitor.html
[base_monitor]:                         https://eBardX.github.io/XestiMonitors/Classes/BaseMonitor.html
[base_notification_monitor]:            https://eBardX.github.io/XestiMonitors/Classes/BaseNotificationMonitor.html
[battery_monitor]:                      https://eBardX.github.io/XestiMonitors/Classes/BatteryMonitor.html
[keyboard_monitor]:                     https://eBardX.github.io/XestiMonitors/Classes/KeyboardMonitor.html
[memory_monitor]:                       https://eBardX.github.io/XestiMonitors/Classes/MemoryMonitor.html
[motion_activity_monitor]:              https://eBardX.github.io/XestiMonitors/Classes/MotionActivityMonitor.html
[network_reachability_monitor]:         https://eBardX.github.io/XestiMonitors/Classes/NetworkReachabilityMonitor.html
[orientation_monitor]:                  https://eBardX.github.io/XestiMonitors/Classes/OrientationMonitor.html
[pedometer_monitor]:                    https://eBardX.github.io/XestiMonitors/Classes/PedometerMonitor.html
[protected_data_monitor]:               https://eBardX.github.io/XestiMonitors/Classes/ProtectedDataMonitor.html
[proximity_monitor]:                    https://eBardX.github.io/XestiMonitors/Classes/ProximityMonitor.html
[screenshot_monitor]:                   https://eBardX.github.io/XestiMonitors/Classes/ScreenshotMonitor.html
[status_bar_monitor]:                   https://eBardX.github.io/XestiMonitors/Classes/StatusBarMonitor.html
[time_monitor]:                         https://eBardX.github.io/XestiMonitors/Classes/TimeMonitor.html

[p_monitor]:    https://eBardX.github.io/XestiMonitors/Protocols/Monitor.html

[m_is_monitoring]:      https://ebardx.github.io/XestiMonitors/Protocols/Monitor.html#/s:vP13XestiMonitors7Monitor12isMonitoringSb
[m_start_monitoring]:   https://ebardx.github.io/XestiMonitors/Protocols/Monitor.html#/s:FP13XestiMonitors7Monitor15startMonitoringFT_Sb
[m_stop_monitoring]:    https://ebardx.github.io/XestiMonitors/Protocols/Monitor.html#/s:FP13XestiMonitors7Monitor14stopMonitoringFT_Sb

[bm_cleanupMonitor]:    https://eBardX.github.io/XestiMonitors/Classes/BaseMonitor.html#/s:FC13XestiMonitors11BaseMonitor14cleanupMonitorFT_Sb
[bm_configureMonitor]:  https://eBardX.github.io/XestiMonitors/Classes/BaseMonitor.html#/s:FC13XestiMonitors11BaseMonitor16configureMonitorFT_Sb
[bm_is_monitoring]:     https://eBardX.github.io/XestiMonitors/Classes/BaseMonitor.html#/s:vC13XestiMonitors11BaseMonitor12isMonitoringSb
[bm_start_monitoring]:  https://eBardX.github.io/XestiMonitors/Classes/BaseMonitor.html#/s:FC13XestiMonitors11BaseMonitor15startMonitoringFT_Sb
[bm_stop_monitoring]:   https://eBardX.github.io/XestiMonitors/Classes/BaseMonitor.html#/s:FC13XestiMonitors11BaseMonitor14stopMonitoringFT_Sb

[bnm_addNotificationObservers]:     https://eBardX.github.io/XestiMonitors/Classes/BaseNotificationMonitor.html#/s:FC13XestiMonitors23BaseNotificationMonitor24addNotificationObserversFCSo18NotificationCenterSb
[bnm_cleanupMonitor]:               https://eBardX.github.io/XestiMonitors/Classes/BaseNotificationMonitor.html#/s:FC13XestiMonitors23BaseNotificationMonitor14cleanupMonitorFT_Sb
[bnm_configureMonitor]:             https://eBardX.github.io/XestiMonitors/Classes/BaseNotificationMonitor.html#/s:FC13XestiMonitors23BaseNotificationMonitor16configureMonitorFT_Sb
[bnm_removeNotificationObservers]:  https://eBardX.github.io/XestiMonitors/Classes/BaseNotificationMonitor.html#/s:FC13XestiMonitors23BaseNotificationMonitor27removeNotificationObserversFCSo18NotificationCenterSb
