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
/// A `BatteryMonitor` instance monitors the device for changes to the charge
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

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `levelDidChange` events.
        ///
        public static let levelDidChange = Options(rawValue: 1 << 0)

        ///
        /// Monitor `stateDidChange` events.
        ///
        public static let stateDidChange = Options(rawValue: 1 << 1)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.levelDidChange,
                                          .stateDidChange]

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public let rawValue: UInt
    }

    ///
    /// Initializes a new `BatteryMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - options:    The options that specify which events to monitor. By
    ///                 default, all events are monitored.
    ///   - handler:    The handler to call when the battery state or battery
    ///                 level of the device changes.
    ///
    public init(queue: OperationQueue = .main,
                options: Options = .all,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options

        super.init(queue: queue)
    }

    ///
    /// The battery charge level for the device.
    ///
    public var level: Float {
        return device.batteryLevel
    }

    ///
    /// The battery state for the device.
    ///
    public var state: UIDeviceBatteryState {
        return device.batteryState
    }

    private let handler: (Event) -> Void
    private let options: Options

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.levelDidChange) {
            observe(.UIDeviceBatteryLevelDidChange) { [unowned self] _ in
                self.handler(.levelDidChange(self.level))
            }
        }

        if options.contains(.stateDidChange) {
            observe(.UIDeviceBatteryStateDidChange) { [unowned self] _ in
                self.handler(.stateDidChange(self.state))
            }
        }

        device.isBatteryMonitoringEnabled = true
    }

    public override func removeNotificationObservers() {
        device.isBatteryMonitoringEnabled = false

        super.removeNotificationObservers()
    }
}

extension BatteryMonitor: DeviceInjected {}
