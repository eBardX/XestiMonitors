//
//  PedometerMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-04-14.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(watchOS)

import CoreMotion
import Foundation

///
/// A `PedometerMonitor` instance monitors the device for live and historic
/// walking data. You can retrieve step counts and other information about
/// the distance traveled and the number of floors ascended or descended.
///
public class PedometerMonitor: BaseMonitor {
    ///
    /// Encapsulates updates to and queries about the walking data.
    ///
    public enum Event {
        ///
        /// The historic walking data query has completed.
        ///
        case didQuery(Info)

        ///
        /// The live walking data has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates information about the distance traveled by the user on
    /// foot.
    ///
    public enum Info {
        ///
        /// Information about the distance traveled by the user on foot.
        ///
        case data(CMPedometerData)

        ///
        /// The error encountered in attempting to obtain information about
        /// the distance traveled.
        ///
        case error(Error)

        ///
        /// No walking data is available.
        ///
        case unknown
    }

    ///
    /// Initializes a new `PedometerMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when new walking data is
    ///                 available or when a query for historical walking
    ///                 data completes.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.pedometer = PedometerInjector.inject()
        self.queue = queue
    }

    ///
    /// A Boolean value indicating whether cadence information is available
    /// on the device.
    ///
    public var isCadenceAvailable: Bool {
        return type(of: pedometer).isCadenceAvailable()
    }

    ///
    /// A Boolean value indicating whether distance estimation is available
    /// on the device.
    ///
    public var isDistanceAvailable: Bool {
        return type(of: pedometer).isDistanceAvailable()
    }

    ///
    /// A Boolean value indicating whether floor counting is available on
    /// the device.
    ///
    public var isFloorCountingAvailable: Bool {
        return type(of: pedometer).isFloorCountingAvailable()
    }

    ///
    /// A Boolean value indicating whether pace information is available on
    /// the device.
    ///
    public var isPaceAvailable: Bool {
        return type(of: pedometer).isPaceAvailable()
    }

    ///
    /// A Boolean value indicating whether step counting is available on
    /// the device.
    ///
    public var isStepCountingAvailable: Bool {
        return type(of: pedometer).isStepCountingAvailable()
    }

    ///
    /// Retrieves the historical walking data for the specified time
    /// period.
    ///
    /// - Parameters:
    ///   - start:  The start time to use when gathering walking data.
    ///   - end:    The end time to use when gathering walking data.
    ///
    public func query(from start: Date,
                      to end: Date) {
        pedometer.queryPedometerData(from: start,
                                     to: end) { [unowned self] data, error in
                                        var info: Info

                                        if let error = error {
                                            info = .error(error)
                                        } else if let data = data {
                                            info = .data(data)
                                        } else {
                                            info = .unknown
                                        }

                                        self.queue.addOperation {
                                            self.handler(.didQuery(info))
                                        }
        }
    }

    private let handler: (Event) -> Void
    private let pedometer: PedometerProtocol
    private let queue: OperationQueue

    override public func cleanupMonitor() {
        pedometer.stopUpdates()

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        pedometer.startUpdates(from: Date()) { [unowned self] data, error in
            var info: Info

            if let error = error {
                info = .error(error)
            } else if let data = data {
                info = .data(data)
            } else {
                info = .unknown
            }

            self.queue.addOperation {
                self.handler(.didUpdate(info))
            }
        }
    }
}

#endif
