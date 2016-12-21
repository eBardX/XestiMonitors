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
/// A `MagnetometerMonitor` object monitors ...
///
public class MagnetometerMonitor: BaseMonitor {

    ///
    /// Encapsulates ...
    ///
    public enum Info {

        ///
        ///
        ///
        case data(CMMagnetometerData)

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
    public static var isAvailable = CMMotionManager.shared.isMagnetometerAvailable

    // Public Initializers

    ///
    /// Initializes a new `MagnetometerMonitor`.
    ///
    /// - Parameters:
    ///   - motionManager:  The ...
    ///   - interval: The ...
    ///   - handler:        The handler to call when ...
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
    ///
    ///
    public var info: Info {

        if let data = motionManager.magnetometerData {
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

        guard motionManager.isMagnetometerActive else { return false }

        motionManager.stopMagnetometerUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor() else { return false }

        motionManager.magnetometerUpdateInterval = interval

        motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in

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
