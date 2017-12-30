//
//  AccelerometerMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-16.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation

///
/// An `AccelerometerMonitor` instance monitors the device’s accelerometer for
/// periodic raw measurements of the acceleration along the three spatial axes.
///
public class AccelerometerMonitor: BaseMonitor {

    // Public Nested Types

    ///
    /// Encapsulates updates to the measurement of the acceleration along the
    /// three spatial axes.
    ///
    public enum Event {
        ///
        /// The acceleration measurement has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates the measurement of the acceleration along the three
    /// spatial axes at a moment of time.
    ///
    public enum Info {

        ///
        /// The acceleration measurement.
        ///
        case data(CMAccelerometerData)

        ///
        /// The error encountered in attempting to obtain the acceleration
        /// measurement.
        ///
        case error(Error)

        ///
        /// No acceleration measurement is available.
        ///
        case unknown

    }

    // Public Initializers

    ///
    /// Initializes a new `AccelerometerMonitor`.
    ///
    /// - Parameters:
    ///   - motionManager:  The instance of `CMMotionManager` to use. By
    ///                     default, a shared instance is used as recommended
    ///                     by Apple.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     Because the events might arrive at a high rate,
    ///                     using the main operation queue is not recommended.
    ///   - interval:       The interval, in seconds, for providing
    ///                     acceleration measurements to the handler.
    ///   - handler:        The handler to call periodically when a new
    ///                     acceleration measurement is available.
    ///
    public init(motionManager: CMMotionManager = .shared,
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
    /// The latest acceleration measurement available.
    ///
    public var info: Info {
        if let data = motionManager.accelerometerData {
            return .data(data)
        } else {
            return .unknown
        }
    }

    ///
    /// A Boolean value indicating whether an accelerometer is available on the
    /// device.
    ///
    public var isAvailable: Bool {
        return motionManager.isAccelerometerAvailable
    }

    // Private

    private let handler: (Event) -> Void
    private let interval: TimeInterval
    private let motionManager: CMMotionManager
    private let queue: OperationQueue

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        guard
            motionManager.isAccelerometerActive
            else { return false }

        motionManager.stopAccelerometerUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard
            super.configureMonitor()
            else { return false }

        motionManager.accelerometerUpdateInterval = interval

        motionManager.startAccelerometerUpdates(to: queue) { [unowned self] data, error in

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

        return true

    }

}
