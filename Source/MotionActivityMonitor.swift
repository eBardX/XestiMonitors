//
//  MotionActivityMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-04-14.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation

///
/// A `MotionActivityMonitor` instance monitors the device for live and
/// historic motion data. Motion data reflects whether the user is walking,
/// running, in a vehicle, or stationary for periods of time.
///
public class MotionActivityMonitor: BaseMonitor {
    ///
    /// Encapsulates updates to and queries about the motion data.
    ///
    public enum Event {
        ///
        /// The historic motion data query has completed.
        ///
        case didQuery(Info)

        ///
        /// The live motion data has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates the type (or types) of motion for the device.
    ///
    public enum Info {
        ///
        /// An array of motion activity objects that define the types of motion
        /// for the device that occurred during the queried time period.
        ///
        case activities([CMMotionActivity])

        ///
        /// The motion activity object that defines the current type of motion
        /// for the device.
        ///
        case activity(CMMotionActivity)

        ///
        /// The error encountered in attempting to obtain the motion data.
        ///
        case error(Error)

        ///
        /// No motion data is available.
        ///
        case unknown
    }

    ///
    /// Initializes a new `MotionActivityMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when new motion data is available
    ///                 or when a query for historical motion data completes.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.queue = queue
    }

    ///
    /// A Boolean value indicating whether motion data is available on the
    /// device.
    ///
    public var isAvailable: Bool {
        return type(of: motionActivityManager).isActivityAvailable()
    }

    ///
    /// Retrieves historical motion data for the specified time period.
    ///
    /// - Parameters:
    ///   - start:  The start time to use when gathering motion data.
    ///   - end:    The end time to use when gathering motion data.
    ///
    public func query(from start: Date,
                      to end: Date) {
        motionActivityManager.queryActivityStarting(from: start,
                                                    to: end,
                                                    to: queue) { [unowned self] activities, error in
                                                        var info: Info

                                                        if let error = error {
                                                            info = .error(error)
                                                        } else if let activities = activities {
                                                            info = .activities(activities)
                                                        } else {
                                                            info = .unknown
                                                        }

                                                        self.handler(.didQuery(info))
        }
    }

    private let handler: (Event) -> Void
    private let queue: OperationQueue

    public override final func cleanupMonitor() {
        motionActivityManager.stopActivityUpdates()

        super.cleanupMonitor()
    }

    public override final func configureMonitor() {
        super.configureMonitor()

        motionActivityManager.startActivityUpdates(to: queue) { [unowned self] activity in
            var info: Info

            if let activity = activity {
                info = .activity(activity)
            } else {
                info = .unknown
            }

            self.handler(.didUpdate(info))
        }
    }
}

extension MotionActivityMonitor: MotionActivityManagerInjected {}
