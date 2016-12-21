//
//  DeviceMotionMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-20.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation

///
/// A `DeviceMotionMonitor` object monitors the device’s accelerometer,
/// gyroscope, and magnetometer for periodic raw measurements which are
/// processed into device motion measurements.
///
public class DeviceMotionMonitor: BaseMonitor {

    ///
    /// Encapsulates the measurement of device motion.
    ///
    public enum Info {

        ///
        /// The device motion measurement at a moment of time.
        ///
        case data(CMDeviceMotion)

        ///
        /// The error encountered in attempting to obtain the device motion
        /// measurement.
        ///
        case error(Error)

        ///
        /// No device motion measurement is available.
        ///
        case unknown
    }

    // Public Type Properties

    ///
    /// A Boolean value indicating whether device motion measuring is available
    /// on the device.
    ///
    public static var isAvailable: Bool {

        return CMMotionManager.shared.isDeviceMotionAvailable

    }

    // Public Initializers

    ///
    /// Initializes a new `DeviceMotionMonitor`.
    ///
    /// - Parameters:
    ///   - manager:        The instance of `CMMotionManager` to use. By
    ///                     default, a shared instance is used as recommended
    ///                     by Apple.
    ///   - interval:       The interval, in seconds, for providing device
    ///                     motion measurements to the handler.
    ///   - referenceFrame: The reference frame to use for device motion
    ///                     measurements.
    ///   - handler:        The handler to call periodically when a new device
    ///                     motion measurement is available.
    ///
    public init(manager: CMMotionManager = CMMotionManager.shared,
                interval: TimeInterval,
                using referenceFrame: CMAttitudeReferenceFrame,
                handler: @escaping (Info) -> Void) {

        self.handler = handler
        self.interval = interval
        self.manager = manager
        self.referenceFrame = referenceFrame

    }

    // Public Instance Properties

    ///
    /// The latest device motion measurement available.
    ///
    public var info: Info {

        if let data = manager.deviceMotion {
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
    private let referenceFrame: CMAttitudeReferenceFrame

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        guard manager.isDeviceMotionActive else { return false }

        manager.stopDeviceMotionUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor() else { return false }

        manager.accelerometerUpdateInterval = interval

        manager.startDeviceMotionUpdates(using: self.referenceFrame,
                                         to: .main) { [weak self] data, error in

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
