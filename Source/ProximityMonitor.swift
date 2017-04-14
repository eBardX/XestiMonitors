//
//  ProximityMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `ProximityMonitor` object monitors the device for changes to the state of
/// its proximity sensor.
///
public class ProximityMonitor: BaseNotificationMonitor {

    // Public Nested Types

    ///
    /// Encapsulates changes to the state of the proximity sensor.
    ///
    public enum Event {
        ///
        /// The state of the proximity sensor has changed.
        ///
        case stateDidChange(Bool)
    }

    // Public Initializers

    ///
    /// Initializes a new `ProximityMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which notification blocks
    ///                 execute. By default, the main operation queue is used.
    ///   - handler:    The handler to call when the state of the proximity
    ///                 sensor changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.device = .current
        self.handler = handler

        super.init(queue: queue)

    }

    // Public Instance Properties

    ///
    /// A Boolean value indicating whether proximity monitoring is available on
    /// the device (`true`) or not (`false`).
    ///
    public lazy var isAvailable: Bool = {

        let oldValue = self.device.isProximityMonitoringEnabled

        defer { self.device.isProximityMonitoringEnabled = oldValue }

        self.device.isProximityMonitoringEnabled = true

        return self.device.isProximityMonitoringEnabled

    }()

    ///
    /// A Boolean value indicating whether the proximity sensor is close to the
    /// user (`true`) or not (`false`).
    ///
    public var state: Bool { return device.proximityState }

    // Private Instance Properties

    private let device: UIDevice
    private let handler: (Event) -> Void

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard super.addNotificationObservers()
            else { return false }

        observe(.UIDeviceProximityStateDidChange) { [unowned self] _ in
            self.handler(.stateDidChange(self.device.proximityState))
        }

        device.isProximityMonitoringEnabled = true

        return true

    }

    public override func removeNotificationObservers() -> Bool {

        device.isProximityMonitoringEnabled = false

        return super.removeNotificationObservers()

    }

}
