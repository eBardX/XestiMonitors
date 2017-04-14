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

    // Public Nested Types

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
    ///   - queue:      The operation queue on which notification blocks
    ///                 execute. By default, the main operation queue is used.
    ///   - handler:    The handler to call when the battery state or battery
    ///                 level of the device changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.device = .current
        self.handler = handler

        super.init(queue: queue)

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

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard super.addNotificationObservers()
            else { return false }

        observe(.UIDeviceBatteryLevelDidChange) { [unowned self] _ in
            self.handler(.levelDidChange(self.level))
        }

        observe(.UIDeviceBatteryStateDidChange) { [unowned self] _ in
            self.handler(.stateDidChange(self.state))
        }

        device.isBatteryMonitoringEnabled = true

        return true

    }

    public override func removeNotificationObservers() -> Bool {

        device.isBatteryMonitoringEnabled = false

        return super.removeNotificationObservers()

    }

}
