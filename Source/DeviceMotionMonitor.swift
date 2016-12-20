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
/// A `DeviceMotionMonitor` object monitors ...
///
public class DeviceMotionMonitor: BaseMonitor {

    ///
    /// Encapsulates ...
    ///
    public enum Info {

        ///
        ///
        ///
        case data(CMDeviceMotion)

        ///
        ///
        ///
        case error(Error)

        ///
        ///
        ///
        case unknown
    }


    // Public Type Properties

    ///
    /// A Boolean value indicating whether ...
    ///
    public static var isAvailable = CMMotionManager.shared.isDeviceMotionAvailable

    // Public Initializers

    ///
    /// Initializes a new `DeviceMotionMonitor`.
    ///
    /// - Parameters:
    ///   - motionManager:  The ...
    ///   - updateInterval: The ...
    ///   - handler:        The handler to call when ...
    ///
    public init(motionManager: CMMotionManager = CMMotionManager.shared,
                updateInterval: TimeInterval,
                handler: @escaping (Info) -> Void) {

        self.handler = handler
        self.motionManager = motionManager
        self.updateInterval = updateInterval

    }

    // Public Instance Properties

    ///
    ///
    ///
    public var info: Info {

        if let data = motionManager.deviceMotion {
            return .data(data)
        } else {
            return .unknown
        }

    }

    // Private

    private let handler: (Info) -> Void
    private let motionManager: CMMotionManager
    private let queue = DispatchQueue.main
    private let updateInterval: TimeInterval

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        guard motionManager.isDeviceMotionActive else { return false }

        motionManager.stopDeviceMotionUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor() else { return false }

        motionManager.accelerometerUpdateInterval = updateInterval

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in

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
