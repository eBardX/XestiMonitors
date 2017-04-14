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
/// A `MotionActivityMonitor` object monitors ...
///
public class MotionActivityMonitor: BaseMonitor {

    // Public Nested Types

    ///
    /// Encapsulates updates to the measurement of device motion.
    ///
    public enum Event {

        ///
        ///
        ///
        case didQuery(Info)

        ///
        /// The motion activity measurement has been updated.
        ///
        case didUpdate(Info)

    }

    ///
    /// Encapsulates the measurement of motion activity.
    ///
    public enum Info {

        ///
        ///
        ///
        case activities([CMMotionActivity])

        ///
        /// The motion activity measurement at a moment of time.
        ///
        case activity(CMMotionActivity)

        ///
        ///
        ///
        case error(Error)

        ///
        /// No motion activity measurement is available.
        ///
        case unknown

    }

    // Public Initializers

    ///
    /// Initializes a new `MotionActivityMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call periodically when a new device
    ///                 motion measurement is available.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {

        self.handler = handler
        self.manager = CMMotionActivityManager()
        self.queue = queue

    }

    // Public Instance Properties

    ///
    /// A Boolean value indicating whether device motion measuring is available
    /// on the device.
    ///
    public var isAvailable: Bool {

        return CMMotionActivityManager.isActivityAvailable()

    }

    // Public Instance Methods

    public func query(from start: Date,
                      to end: Date) -> Bool {

        manager.queryActivityStarting(from: start,
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

        return true

    }

    // Private Instance Properties

    private let handler: (Event) -> Void
    private let manager: CMMotionActivityManager
    private let queue: OperationQueue

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        manager.stopActivityUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor()
            else { return false }

        manager.startActivityUpdates(to: queue) { [unowned self] activity in

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
