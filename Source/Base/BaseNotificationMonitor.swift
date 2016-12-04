//
//  BaseNotificationMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// An abstract base class that simplifies the implementation of a monitor
/// which relies on one or more notification observers.
///
public class BaseNotificationMonitor: BaseMonitor {

    // Public Instance Methods

    ///
    /// Adds observers to the specified notification center.
    ///
    /// If monitoring is already active when the `startMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    ///
    /// - Parameters:
    ///   - notificationCenter: The notification center to add observers to.
    ///
    /// - Returns:  `true` if notification observers were successfully added or
    ///             `false` on failure.
    ///
    public func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        return true

    }

    ///
    /// Removes observers from the specified notification center.
    ///
    /// If monitoring is not active when the `stopMonitoring()` method is
    /// invoked, this method is not called. The default implementation of this
    /// method removes *all* observers from the specified notification center.
    /// If you override this method, you must be sure to invoke the superclass
    /// implementation.
    ///
    /// - Parameters:
    ///   - notificationCenter: The notification center to remove observers from.
    ///
    /// - Returns:  `true` if notification observers were successfully removed
    ///             or `false` on failure.
    ///
    public func removeNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        notificationCenter.removeObserver(self)

        return true

    }

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        return removeNotificationObservers(NotificationCenter.`default`)
            && super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        return super.configureMonitor()
            && addNotificationObservers(NotificationCenter.`default`)

    }

}
