// © 2017–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS)

import UIKit

internal protocol DeviceProtocol: AnyObject {
    var batteryLevel: Float { get }

    var batteryState: UIDevice.BatteryState { get }

    var isBatteryMonitoringEnabled: Bool { get set }

    var isProximityMonitoringEnabled: Bool { get set }

    var orientation: UIDeviceOrientation { get }

    var proximityState: Bool { get }

    func beginGeneratingDeviceOrientationNotifications()

    func endGeneratingDeviceOrientationNotifications()
}

// MARK: -

extension UIDevice: DeviceProtocol {}

// MARK: -

internal enum DeviceInjector {
    internal static var inject: () -> any DeviceProtocol = { UIDevice.current }
}

#endif
