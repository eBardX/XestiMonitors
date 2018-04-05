//
//  GyroscopeMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-20.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(watchOS)

import CoreMotion
import Foundation

///
/// A `GyroscopeMonitor` instance monitors the device’s gyroscope for
/// periodic raw measurements of the rotation rate around the three spatial
/// axes.
///
public class GyroscopeMonitor: BaseMonitor {
    ///
    /// Encapsulates updates to the measurement of the rotation rate around
    /// the three spatial axes.
    ///
    public enum Event {
        ///
        /// The rotation rate measurement has been updated.
        ///
        case didUpdate(Info)
    }

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

    ///
    /// Initializes a new `GyroscopeMonitor`.
    ///
    /// - Parameters:
    ///   - interval:   The interval, in seconds, for providing rotation
    ///                 rate measurements to the handler.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 Because the events might arrive at a high rate,
    ///                 using the main operation queue is not recommended.
    ///   - handler:    The handler to call periodically when a new
    ///                 rotation rate measurement is available.
    ///
    public init(interval: TimeInterval,
                queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.interval = interval
        self.motionManager = MotionManagerInjector.inject()
        self.queue = queue
    }

    ///
    /// The latest rotation rate measurement available.
    ///
    public var info: Info {
        guard
            let data = motionManager.gyroData
            else { return .unknown }

        return .data(data)
    }

    ///
    /// A Boolean value indicating whether a gyroscope is available on the
    /// device.
    ///
    public var isAvailable: Bool {
        return motionManager.isGyroAvailable
    }

    private let handler: (Event) -> Void
    private let interval: TimeInterval
    private let motionManager: MotionManagerProtocol
    private let queue: OperationQueue

    override public func cleanupMonitor() {
        motionManager.stopGyroUpdates()

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        motionManager.gyroUpdateInterval = interval

        motionManager.startGyroUpdates(to: queue) { [unowned self] data, error in
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
    }

    // MARK: Deprecated

    ///
    /// Initializes a new `GyroscopeMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 Because the events might arrive at a high rate,
    ///                 using the main operation queue is not recommended.
    ///   - interval:   The interval, in seconds, for providing rotation
    ///                 rate measurements to the handler.
    ///   - handler:    The handler to call periodically when a new
    ///                 rotation rate measurement is available.
    ///
    /// - Warning:  Deprecated. Use `init(interval:queue:handler)` instead.
    ///
    @available(*, deprecated, message: "Use `init(interval:queue:handler)` instead.")
    public init(queue: OperationQueue,
                interval: TimeInterval,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.interval = interval
        self.motionManager = MotionManagerInjector.inject()
        self.queue = queue
    }
}

#endif
