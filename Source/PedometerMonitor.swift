//
//  PedometerMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-04-14.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation

///
/// A `PedometerMonitor` instance monitors the device to fetch
/// pedestrian-related data.
///
public class PedometerMonitor: BaseMonitor {
    ///
    ///
    ///
    public enum Event {
        ///
        ///
        ///
        case didQuery(Info)

        ///
        ///
        ///
        case didUpdate(Info)
    }

    ///
    ///
    ///
    public enum Info {
        ///
        ///
        ///
        case data(CMPedometerData)

        ///
        ///
        ///
        case error(Error)

        ///
        ///
        ///
        case unknown
    }

    ///
    /// Initializes a new `PedometerMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when ...
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.queue = queue
    }

    ///
    /// A Boolean value indicating whether cadence information is available on
    /// the device.
    ///
    public var isCadenceAvailable: Bool {
        return type(of: pedometer).isCadenceAvailable()
    }

    ///
    /// A Boolean value indicating whether distance estimation is available on
    /// the device.
    ///
    public var isDistanceAvailable: Bool {
        return type(of: pedometer).isDistanceAvailable()
    }

    ///
    /// A Boolean value indicating whether floor counting is available on the
    /// device.
    ///
    public var isFloorCountingAvailable: Bool {
        return type(of: pedometer).isFloorCountingAvailable()
    }

    ///
    /// A Boolean value indicating whether pace information is available on the
    /// device.
    ///
    public var isPaceAvailable: Bool {
        return type(of: pedometer).isPaceAvailable()
    }

    ///
    /// A Boolean value indicating whether step counting is available on the
    /// device.
    ///
    public var isStepCountingAvailable: Bool {
        return type(of: pedometer).isStepCountingAvailable()
    }

    ///
    ///
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
    private let queue: OperationQueue

    public override final func cleanupMonitor() {
        pedometer.stopUpdates()

        super.cleanupMonitor()
    }

    public override final func configureMonitor() {
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

            self.queue.addOperation { self.handler(.didUpdate(info)) }
        }
    }
}

extension PedometerMonitor: PedometerInjected {}
