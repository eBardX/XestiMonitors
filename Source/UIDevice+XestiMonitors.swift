//
//  UIDevice+XestiMonitors.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-29.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit

public protocol Device: class {

    var batteryLevel: Float { get }

    var batteryState: UIDeviceBatteryState { get }

    var isBatteryMonitoringEnabled: Bool { get set }

    var isProximityMonitoringEnabled: Bool { get set }

    var orientation: UIDeviceOrientation { get }

    var proximityState: Bool { get }

    func beginGeneratingDeviceOrientationNotifications()

    func endGeneratingDeviceOrientationNotifications()

}

extension UIDevice: Device {}
