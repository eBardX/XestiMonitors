// © 2016–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(watchOS)

import CoreMotion
import Foundation

/// An `AccelerometerMonitor` instance monitors the device’s accelerometer
/// for periodic raw measurements of the acceleration along the three
/// spatial axes.
public final class AccelerometerMonitor: BaseMonitor {
    /// Encapsulates updates to the measurement of the acceleration along
    /// the three spatial axes.
    public enum Event {
        /// The acceleration measurement has been updated.
        case didUpdate(Info)
    }

    /// Encapsulates the measurement of the acceleration along the three
    /// spatial axes at a moment of time.
    public enum Info {
        /// The acceleration measurement.
        case data(CMAccelerometerData)

        /// The error encountered in attempting to obtain the acceleration
        /// measurement.
        case error(any Error)

        /// No acceleration measurement is available.
        case unknown
    }

    /// Initializes a new `AccelerometerMonitor`.
    /// - Parameters:
    ///   - interval:   The interval, in seconds, for providing
    ///                 acceleration measurements to the handler.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 Because the events might arrive at a high rate,
    ///                 using the main operation queue is not recommended.
    ///   - handler:    The handler to call periodically when a new
    ///                 acceleration measurement is available.
    public init(interval: TimeInterval,
                queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.interval = interval
        self.motionManager = MotionManagerInjector.inject()
        self.queue = queue
    }

    /// The latest acceleration measurement available.
    public var info: Info {
        guard let data = motionManager.accelerometerData
        else { return .unknown }

        return .data(data)
    }

    /// A Boolean value indicating whether an accelerometer is available on
    /// the device.
    public var isAvailable: Bool {
        motionManager.isAccelerometerAvailable
    }

    private let handler: (Event) -> Void
    private let interval: TimeInterval
    private let motionManager: any MotionManagerProtocol
    private let queue: OperationQueue

    override public func cleanupMonitor() {
        motionManager.stopAccelerometerUpdates()

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        motionManager.accelerometerUpdateInterval = interval

        motionManager.startAccelerometerUpdates(to: queue) { [unowned self] data, error in
            var info: Info

            if let error {
                info = .error(error)
            } else if let data {
                info = .data(data)
            } else {
                info = .unknown
            }

            self.handler(.didUpdate(info))
        }
    }
}

#endif
