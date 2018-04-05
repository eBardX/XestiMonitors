//
//  DeviceInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-29.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)

import UIKit

internal protocol DeviceProtocol: class {
    var batteryLevel: Float { get }

    var batteryState: UIDeviceBatteryState { get }

    var isBatteryMonitoringEnabled: Bool { get set }

    var isProximityMonitoringEnabled: Bool { get set }

    var orientation: UIDeviceOrientation { get }

    var proximityState: Bool { get }

    func beginGeneratingDeviceOrientationNotifications()

    func endGeneratingDeviceOrientationNotifications()
}

extension UIDevice: DeviceProtocol {}

internal struct DeviceInjector {
    internal static var inject: () -> DeviceProtocol = { return UIDevice.current }
}

#endif
