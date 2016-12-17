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
/// A `AccelerometerMonitor` object monitors ...
///
public class AccelerometerMonitor: BaseMonitor {

    // Public Type Properties

    ///
    /// A Boolean value indicating whether ...
    ///
    public static var isAvailable = CMMotionManager.shared.isAccelerometerAvailable

    // Public Initializers

    ///
    /// Initializes a new `AccelerometerMonitor`.
    ///
    /// - Parameters:
    ///   - motionManager:  The ...
    ///   - updateInterval: The ...
    ///   - handler:        The handler to call when ...
    ///
    public init(motionManager: CMMotionManager = CMMotionManager.shared,
                updateInterval: TimeInterval,
                handler: @escaping (CMAccelerometerData?, Error?) -> Void) {

        self.handler = handler
        self.motionManager = motionManager

        motionManager.accelerometerUpdateInterval = updateInterval

    }

    // Public Instance Properties

    ///
    /// A Boolean value indicating whether ...
    ///
    public var data: CMAccelerometerData? { return motionManager.accelerometerData }

    // Private

    private let handler: (CMAccelerometerData?, Error?) -> Void
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

        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in

            self?.queue.async { self?.handler(data, error) }

        }

        return true
    }

}
