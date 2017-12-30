//
//  MockDevice.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-30.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
@testable import XestiMonitors

internal class MockDevice: Device {

    init() {

        self.batteryLevel = 0
        self.batteryState = .unknown
        self.isBatteryMonitoringEnabled = false
        self.isProximityMonitoringEnabled = false
        self.orientation = .unknown
        self.proximityState = false

    }

    var batteryLevel: Float
    var batteryState: UIDeviceBatteryState
    var isBatteryMonitoringEnabled: Bool
    var isProximityMonitoringEnabled: Bool
    var orientation: UIDeviceOrientation
    var proximityState: Bool

    func beginGeneratingDeviceOrientationNotifications() {
    }

    func endGeneratingDeviceOrientationNotifications() {
    }

}
