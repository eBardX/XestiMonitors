//
//  GyroMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-20.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation

///
/// A `GyroMonitor` object monitors the device’s gyroscope for periodic
/// measurements of the rotation rate around the three spatial axes.
///
public class GyroMonitor: BaseMonitor {

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

    // Public Type Properties

    ///
    /// A Boolean value indicating whether a gyroscope is available on the
    /// device.
    ///
    public static var isAvailable: Bool {

        return CMMotionManager.shared.isGyroAvailable

    }

    // Public Initializers

    ///
    /// Initializes a new `GyroMonitor`.
    ///
    /// - Parameters:
    ///   - motionManager:  The instance of `CMMotionManager` to use. By
    ///                     default, a shared instance is used as recommended
    ///                     by Apple.
    ///   - interval:       The interval, in seconds, for providing rotation
    ///                     rate measurements to the handler.
    ///   - handler:        The handler to call periodically when a new
    ///                     rotation rate measurement is available.
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
    /// The latest rotation rate measurement available.
    ///
    public var info: Info {

        if let data = motionManager.gyroData {
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

        guard motionManager.isGyroActive else { return false }

        motionManager.stopGyroUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor() else { return false }

        motionManager.gyroUpdateInterval = interval

        motionManager.startGyroUpdates(to: .main) { [weak self] data, error in

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
