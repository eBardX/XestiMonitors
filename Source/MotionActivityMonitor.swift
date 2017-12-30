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
/// A `MotionActivityMonitor` instance monitors provides access to the motion
/// data stored by a device. Motion data reflects whether the user is walking,
/// running, in a vehicle, or stationary for periods of time. A navigation app
/// might look for changes in the current type of motion and offer different
/// directions for each. Using this class, you can ask for notifications when
/// the current type of motion changes or you can gather past motion change
/// data.
///
public class MotionActivityMonitor: BaseMonitor {

    // Public Nested Types

    ///
    /// Encapsulates updates to ...
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
    /// Encapsulates ... the current type of motion for the device
    ///
    public enum Info {

        ///
        /// An array of CMMotionActivity objects indicating the updates that
        /// occurred. The objects in the array are ordered by the time at which
        /// they occurred in the specified time interval. Use the startDate
        /// property in each motion object to determine when the update
        /// occurred.
        ///
        case activities([CMMotionActivity])

        ///
        /// The motion activity object that defines the current type of motion
        /// for the device.
        ///
        case activity(CMMotionActivity)

        ///
        /// An error object indicating that there was a problem gathering the
        /// data or nil if the motion data was determined correctly.
        ///
        case error(Error)

        ///
        ///
        ///
        case unknown    // ELIMINATE???

    }

    // Public Initializers

    ///
    /// Initializes a new `MotionActivityMonitor`.
    ///
    /// - Parameters:
    ///   - motionActivityManager
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when a change in the current type
    ///                 of motion is detected.
    ///                 - OR -
    ///                 The block to execute with the results.
    ///
    public init(motionActivityManager: MotionActivityManager = CMMotionActivityManager(),
                queue: OperationQueue,
                handler: @escaping (Event) -> Void) {

        self.handler = handler
        self.motionActivityManager = motionActivityManager
        self.queue = queue

    }

    // Public Instance Properties

    ///
    /// A Boolean value indicating whether motion data is available on the
    /// device.
    ///
    public var isAvailable: Bool {

        return type(of: motionActivityManager).isActivityAvailable()

    }

    // Public Instance Methods

    ///
    /// Gathers and returns historical motion data for the specified time
    /// period.
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

    // Private Instance Properties

    private let handler: (Event) -> Void
    private let motionActivityManager: MotionActivityManager
    private let queue: OperationQueue

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        motionActivityManager.stopActivityUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard
            super.configureMonitor()
            else { return false }

        motionActivityManager.startActivityUpdates(to: queue) { [unowned self] activity in

            var info: Info

            if let activity = activity {
                info = .activity(activity)
            } else {
                info = .unknown
            }

            self.handler(.didUpdate(info))

        }

        return true

    }

}
