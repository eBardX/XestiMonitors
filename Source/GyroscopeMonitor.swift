//
//  GyroscopeMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-20.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation

///
/// A `GyroscopeMonitor` instance monitors the device’s gyroscope for periodic raw
/// measurements of the rotation rate around the three spatial axes.
///
public class GyroscopeMonitor: BaseMonitor {

    // Public Nested Types

    ///
    /// Encapsulates updates to the measurement of the rotation rate around the
    /// three spatial axes.
    ///
    public enum Event {
        ///
        /// The rotation rate measurement has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates the measurement of the rotation rate around the three
    /// spatial axes at a moment of time.
    ///
    public enum Info {

        ///
        /// The rotation rate measurement.
        ///
        case data(CMGyroData)

        ///
        /// The error encountered in attempting to obtain the rotation rate
        /// measurement.
        ///
        case error(Error)

        ///
        /// No rotation rate measurement is available.
        ///
        case unknown

    }

    // Public Initializers

    ///
    /// Initializes a new `GyroscopeMonitor`.
    ///
    /// - Parameters:
    ///   - motionManager:  The instance of `CMMotionManager` to use. By
    ///                     default, a shared instance is used as recommended
    ///                     by Apple.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     Because the events might arrive at a high rate,
    ///                     using the main operation queue is not recommended.
    ///   - interval:       The interval, in seconds, for providing rotation
    ///                     rate measurements to the handler.
    ///   - handler:        The handler to call periodically when a new
    ///                     rotation rate measurement is available.
    ///
    public init(motionManager: MotionManager = CMMotionManager.shared,
                queue: OperationQueue,
                interval: TimeInterval,
                handler: @escaping (Event) -> Void) {

        self.handler = handler
        self.interval = interval
        self.motionManager = motionManager
        self.queue = queue

    }

    // Public Instance Properties

    ///
    /// The latest rotation rate measurement available.
    ///
    public var info: Info {
        guard
            let data = motionManager.gyroData
            else { return .unknown }

        return .data(data)
    }

    ///
    /// A Boolean value indicating whether a gyroscope is available on the
    /// device.
    ///
    public var isAvailable: Bool {
        return motionManager.isGyroAvailable
    }

    // Private

    private let handler: (Event) -> Void
    private let interval: TimeInterval
    private let motionManager: MotionManager
    private let queue: OperationQueue

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() {

        motionManager.stopGyroUpdates()

        super.cleanupMonitor()

    }

    public override final func configureMonitor() {

        super.configureMonitor()

        motionManager.gyroUpdateInterval = interval

        motionManager.startGyroUpdates(to: queue) { [unowned self] data, error in

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
