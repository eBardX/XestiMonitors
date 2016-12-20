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
/// A `GyroMonitor` object monitors ...
///
public class GyroMonitor: BaseMonitor {

    ///
    /// Encapsulates ...
    ///
    public enum Info {

        ///
        ///
        ///
        case data(CMGyroData)

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
    public static var isAvailable = CMMotionManager.shared.isGyroAvailable

    // Public Initializers

    ///
    /// Initializes a new `GyroMonitor`.
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

        if let data = motionManager.gyroData {
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

        guard motionManager.isGyroActive else { return false }

        motionManager.stopGyroUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor() else { return false }

        motionManager.gyroUpdateInterval = updateInterval

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
