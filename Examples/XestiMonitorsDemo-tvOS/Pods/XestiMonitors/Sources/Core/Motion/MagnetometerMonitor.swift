//
//  MagnetometerMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-20.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(watchOS)

    import CoreMotion
    import Foundation

    ///
    /// A `MagnetometerMonitor` instance monitors the device’s magnetometer for
    /// periodic raw measurements of the magnetic field around the three spatial
    /// axes.
    ///
    public class MagnetometerMonitor: BaseMonitor {
        ///
        /// Encapsulates updates to the measurement of the magnetic field around
        /// the three spatial axes.
        ///
        public enum Event {
            ///
            /// The magnetic field measurement has been updated.
            ///
            case didUpdate(Info)
        }

        ///
        /// Encapsulates the measurement of the magnetic field around the three
        /// spatial axes.
        ///
        public enum Info {
            ///
            /// The magnetic field measurement.
            ///
            case data(CMMagnetometerData)

            ///
            /// The error encountered in attempting to obtain the magnetic field
            /// measurement.
            ///
            case error(Error)

            ///
            /// No magnetic field measurement is available.
            ///
            case unknown
        }

        ///
        /// Initializes a new `MagnetometerMonitor`.
        ///
        /// - Parameters:
        ///   - queue:          The operation queue on which the handler executes.
        ///                     Because the events might arrive at a high rate,
        ///                     using the main operation queue is not recommended.
        ///   - interval:       The interval, in seconds, for providing magnetic
        ///                     field measurements to the handler.
        ///   - handler:        The handler to call periodically when a new
        ///                     magnetic field measurement is available.
        ///
        public init(queue: OperationQueue,
                    interval: TimeInterval,
                    handler: @escaping (Event) -> Void) {
            self.handler = handler
            self.interval = interval
            self.queue = queue
        }

        ///
        /// The latest magnetic field measurement available.
        ///
        public var info: Info {
            guard
                let data = motionManager.magnetometerData
                else { return .unknown }

            return .data(data)
        }

        ///
        /// A Boolean value indicating whether a magnetometer is available on the
        /// device.
        ///
        public var isAvailable: Bool {
            return motionManager.isMagnetometerAvailable
        }

        private let handler: (Event) -> Void
        private let interval: TimeInterval
        private let queue: OperationQueue

        public override final func cleanupMonitor() {
            motionManager.stopMagnetometerUpdates()

            super.cleanupMonitor()
        }

        public override final func configureMonitor() {
            super.configureMonitor()

            motionManager.magnetometerUpdateInterval = interval

            motionManager.startMagnetometerUpdates(to: queue) { [unowned self] data, error in
                var info: Info

                if let error = error {
                    info = .error(error)
                } else if let data = data {
                    info = .data(data)
                } else {
                    info = .unknown
                }

                self.handler(.didUpdate(info))
            }
        }
    }

    extension MagnetometerMonitor: MotionManagerInjected {}

#endif
