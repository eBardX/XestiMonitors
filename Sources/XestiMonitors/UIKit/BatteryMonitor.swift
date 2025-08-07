// © 2016–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS)

import Foundation
import UIKit

/// A `BatteryMonitor` instance monitors the device for changes to the
/// charge state and charge level of its battery.
public final class BatteryMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the battery state or battery level of the
    /// device.
    public enum Event {
        /// The battery level of the device has changed.
        case levelDidChange(Float)

        /// The battery state of the device has changed.
        case stateDidChange(UIDevice.BatteryState)
    }

    /// Initializes a new `BatteryMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the battery state or
    ///                 battery level of the device changes.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.device = DeviceInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    /// The battery charge level for the device.
    public var level: Float {
        device.batteryLevel
    }

    /// The battery state for the device.
    public var state: UIDevice.BatteryState {
        device.batteryState
    }

    private let device: any DeviceProtocol
    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIDevice.batteryLevelDidChangeNotification,
                object: device) { [unowned self] _ in
            self.handler(.levelDidChange(self.level))
        }

        observe(UIDevice.batteryStateDidChangeNotification,
                object: device) { [unowned self] _ in
            self.handler(.stateDidChange(self.state))
        }

        device.isBatteryMonitoringEnabled = true
    }

    override public func removeNotificationObservers() {
        device.isBatteryMonitoringEnabled = false

        super.removeNotificationObservers()
    }
}

#endif
