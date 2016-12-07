//
//  BatteryMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `BatteryMonitor` object monitors the device for changes to the charge
/// state and charge level of its battery.
///
public class BatteryMonitor: BaseNotificationMonitor {

    ///
    /// Encapsulates changes to the battery state or battery level of the
    /// device.
    ///
    public enum Event {

        ///
        /// The battery level of the device has changed.
        ///
        case levelDidChange(Float)

        ///
        /// The battery state of the device has changed.
        ///
        case stateDidChange(UIDeviceBatteryState)
    }

    // Public Initializers

    ///
    /// Initializes a new `BatteryMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the battery state or battery
    ///                 level of the device changes.
    ///
    public init(handler: @escaping (Event) -> Void) {

        self.device = UIDevice.current
        self.handler = handler

    }

    // Public Instance Properties

    ///
    /// The battery charge level for the device.
    ///
    public var level: Float { return device.batteryLevel }

    ///
    /// The battery state for the device.
    ///
    public var state: UIDeviceBatteryState { return device.batteryState }

    // Private Instance Properties

    private let device: UIDevice
    private let handler: (Event) -> Void

    // Private Instance Methods

    @objc private func deviceBatteryLevelDidChange(_ notification: NSNotification) {

        handler(.levelDidChange(level))

    }

    @objc private func deviceBatteryStateDidChange(_ notification: NSNotification) {

        handler(.stateDidChange(state))

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        notificationCenter.addObserver(self,
                                       selector: #selector(deviceBatteryLevelDidChange(_:)),
                                       name: .UIDeviceBatteryLevelDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(deviceBatteryStateDidChange(_:)),
                                       name: .UIDeviceBatteryStateDidChange,
                                       object: nil)

        device.isBatteryMonitoringEnabled = true

        return true

    }

    public override func removeNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        device.isBatteryMonitoringEnabled = false

        return super.removeNotificationObservers(notificationCenter)

    }

}
