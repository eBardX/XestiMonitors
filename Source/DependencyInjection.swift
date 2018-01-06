//
//  DependencyInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-06.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation
import UIKit

internal protocol AltimeterInjected {}

internal struct AltimeterInjector {
    static var altimeter: Altimeter = CMAltimeter()
}

internal extension AltimeterInjected {
    var altimeter: Altimeter { return AltimeterInjector.altimeter }
}

internal protocol ApplicationInjected {}

internal struct ApplicationInjector {
    static var application: Application = UIApplication.shared
}

internal extension ApplicationInjected {
    var application: Application { return ApplicationInjector.application }
}

internal protocol DeviceInjected {}

internal struct DeviceInjector {
    static var device: Device = UIDevice.current
}

internal extension DeviceInjected {
    var device: Device { return DeviceInjector.device }
}

internal protocol MotionActivityManagerInjected {}

internal struct MotionActivityManagerInjector {
    static var motionActivityManager: MotionActivityManager = CMMotionActivityManager()
}

internal extension MotionActivityManagerInjected {
    var motionActivityManager: MotionActivityManager { return MotionActivityManagerInjector.motionActivityManager }
}

internal protocol MotionManagerInjected {}

internal struct MotionManagerInjector {
    static var motionManager: MotionManager = CMMotionManager()
}

internal extension MotionManagerInjected {
    var motionManager: MotionManager { return MotionManagerInjector.motionManager }
}

internal protocol NotificationCenterInjected {}

internal struct NotificationCenterInjector {
    static var notificationCenter: NotificationCenter = NSNotificationCenter.`default`
}

internal extension NotificationCenterInjected {
    var notificationCenter: NotificationCenter { return NotificationCenterInjector.notificationCenter }
}

internal protocol PedometerInjected {}

internal struct PedometerInjector {
    static var pedometer: Pedometer = CMPedometer()
}

internal extension PedometerInjected {
    var pedometer: Pedometer { return PedometerInjector.pedometer }
}
