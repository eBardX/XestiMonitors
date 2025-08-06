// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
@testable import XestiMonitors

internal class MockDevice: DeviceProtocol {
    init() {
        self.batteryLevel = 0
        self.batteryState = .unknown
        self.isBatteryMonitoringEnabled = false
        self.isProximityMonitoringEnabled = false
        self.orientation = .unknown
        self.proximityState = false
    }

    var batteryLevel: Float
    var batteryState: UIDevice.BatteryState
    var isBatteryMonitoringEnabled: Bool
    var isProximityMonitoringEnabled: Bool
    var orientation: UIDeviceOrientation
    var proximityState: Bool

    func beginGeneratingDeviceOrientationNotifications() {
    }

    func endGeneratingDeviceOrientationNotifications() {
    }
}
