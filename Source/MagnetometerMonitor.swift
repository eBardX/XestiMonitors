//
//  MagnetometerMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-20.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation

///
/// A `MagnetometerMonitor` object monitors the device’s magnetometer for
/// periodic raw measurements of the magnetic field around the three spatial
/// axes.
///
public class MagnetometerMonitor: BaseMonitor {

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

    // Public Type Properties

    ///
    /// A Boolean value indicating whether a magnetometer is available on the
    /// device.
    ///
    public static var isAvailable: Bool {

        return CMMotionManager.shared.isMagnetometerAvailable

    }

    // Public Initializers

    ///
    /// Initializes a new `MagnetometerMonitor`.
    ///
    /// - Parameters:
    ///   - manager:    The instance of `CMMotionManager` to use. By default, a
    ///                 shared instance is used as recommended by Apple.
    ///   - interval:   The interval, in seconds, for providing magnetic field
    ///                 measurements to the handler.
    ///   - handler:    The handler to call periodically when a new magnetic
    ///                 field measurement is available.
    ///
    public init(manager: CMMotionManager = CMMotionManager.shared,
                interval: TimeInterval,
                handler: @escaping (Info) -> Void) {

        self.handler = handler
        self.interval = interval
        self.manager = manager

    }

    // Public Instance Properties

    ///
    /// The latest magnetic field measurement available.
    ///
    public var info: Info {

        if let data = manager.magnetometerData {
            return .data(data)
        } else {
            return .unknown
        }

    }

    // Private

    private let handler: (Info) -> Void
    private let interval: TimeInterval
    private let manager: CMMotionManager
    private let queue = DispatchQueue.main

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        guard manager.isMagnetometerActive else { return false }

        manager.stopMagnetometerUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor() else { return false }

        manager.magnetometerUpdateInterval = interval

        manager.startMagnetometerUpdates(to: .main) { [weak self] data, error in

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
