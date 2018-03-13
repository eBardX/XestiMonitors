//
//  ProximityMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)

    import Foundation
    import UIKit

    ///
    /// A `ProximityMonitor` instance monitors the device for changes to the state
    /// of its proximity sensor.
    ///
    public class ProximityMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates changes to the state of the proximity sensor.
        ///
        public enum Event {
            ///
            /// The state of the proximity sensor has changed.
            ///
            case stateDidChange(Bool)
        }

        ///
        /// Initializes a new `ProximityMonitor`.
        ///
        /// - Parameters:
        ///   - queue:      The operation queue on which the handler executes. By
        ///                 default, the main operation queue is used.
        ///   - handler:    The handler to call when the state of the proximity
        ///                 sensor changes.
        ///
        public init(queue: OperationQueue = .main,
                    handler: @escaping (Event) -> Void) {
            self.device = DeviceInjector.inject()
            self.handler = handler

            super.init(queue: queue)
        }

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
        public var state: Bool {
            return device.proximityState
        }

        private let device: DeviceProtocol
        private let handler: (Event) -> Void

        override public func addNotificationObservers() {
            super.addNotificationObservers()

            observe(.UIDeviceProximityStateDidChange,
                    object: device) { [unowned self] _ in
                self.handler(.stateDidChange(self.device.proximityState))
            }

            device.isProximityMonitoringEnabled = true
        }

        override public func removeNotificationObservers() {
            device.isProximityMonitoringEnabled = false

            super.removeNotificationObservers()
        }
    }

#endif
