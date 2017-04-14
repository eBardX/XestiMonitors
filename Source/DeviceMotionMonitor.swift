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

    // Public Nested Types

    ///
    /// Encapsulates updates to the measurement of device motion.
    ///
    public enum Event {
        ///
        /// The device motion measurement has been updated.
        ///
        case didUpdate(Info)
    }

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

    // Public Initializers

    ///
    /// Initializes a new `DeviceMotionMonitor`.
    ///
    /// - Parameters:
    ///   - motionManager:  The instance of `CMMotionManager` to use. By
    ///                     default, a shared instance is used as recommended
    ///                     by Apple.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     Because the events might arrive at a high rate,
    ///                     using the main operation queue is not recommended.
    ///   - interval:       The interval, in seconds, for providing device
    ///                     motion measurements to the handler.
    ///   - referenceFrame: The reference frame to use for device motion
    ///                     measurements.
    ///   - handler:        The handler to call periodically when a new device
    ///                     motion measurement is available.
    ///
    public init(motionManager: CMMotionManager = .shared,
                queue: OperationQueue,
                interval: TimeInterval,
                using referenceFrame: CMAttitudeReferenceFrame,
                handler: @escaping (Event) -> Void) {

        self.handler = handler
        self.interval = interval
        self.motionManager = motionManager
        self.queue = queue
        self.referenceFrame = referenceFrame

    }

    // Public Instance Properties

    ///
    /// The latest device motion measurement available.
    ///
    public var info: Info {

        if let data = motionManager.deviceMotion {
            return .data(data)
        } else {
            return .unknown
        }

    }

    ///
    /// A Boolean value indicating whether device motion measuring is available
    /// on the device.
    ///
    public var isAvailable: Bool {

        return motionManager.isDeviceMotionAvailable

    }

    // Private

    private let handler: (Event) -> Void
    private let interval: TimeInterval
    private let motionManager: CMMotionManager
    private let queue: OperationQueue
    private let referenceFrame: CMAttitudeReferenceFrame

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        guard motionManager.isDeviceMotionActive
            else { return false }

        motionManager.stopDeviceMotionUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor()
            else { return false }

        motionManager.accelerometerUpdateInterval = interval

        motionManager.startDeviceMotionUpdates(using: self.referenceFrame,
                                               to: .main) { [unowned self] data, error in

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
