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
/// An `AccelerometerMonitor` object monitors the device’s accelerometers for
/// periodic measurements to the acceleration along the three spatial axes.
///
public class AccelerometerMonitor: BaseMonitor {

    ///
    /// Encapsulates the measurement of acceleration along the three spatial axes
    /// at a moment of time.
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


    // Public Type Properties

    ///
    /// A Boolean value indicating whether accelerometers are available on the
    /// device.
    ///
    public static var isAvailable: Bool {

        return CMMotionManager.shared.isAccelerometerAvailable

    }

    // Public Initializers

    ///
    /// Initializes a new `AccelerometerMonitor`.
    ///
    /// - Parameters:
    ///   - motionManager:  The instance of `CMMotionManager` to use. By
    ///                     default, a shared instance is used as recommended
    ///                     by the Apple documentation.
    ///   - interval:       The interval, in seconds, for providing
    ///                     acceleration measurements to the handler.
    ///   - handler:        The handler to call periodically when a new
    ///                     acceleration measurement is available.
    ///
    public init(motionManager: CMMotionManager = CMMotionManager.shared,
                interval: TimeInterval,
                handler: @escaping (Info) -> Void) {

        self.handler = handler
        self.interval = interval
        self.motionManager = motionManager

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

    // Private

    private let handler: (Info) -> Void
    private let interval: TimeInterval
    private let motionManager: CMMotionManager
    private let queue = DispatchQueue.main

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        guard motionManager.isAccelerometerActive else { return false }

        motionManager.stopAccelerometerUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor() else { return false }

        motionManager.accelerometerUpdateInterval = interval

        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in

            var info: Info

            if let error = error {
                info = .error(error)
            } else if let data = data {
                info = .data(data)
            } else {
                info = .unknown
            }

            self?.queue.async { self?.handler(info) }

        }

        return true
    }

}
