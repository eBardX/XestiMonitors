//
//  BaseNotificationMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// An abstract base class that simplifies the implementation of a monitor
/// which relies on one or more notification observers.
///
open class BaseNotificationMonitor: BaseMonitor {
    ///
    /// Adds observers to the default notification center.
    ///
    /// If monitoring is already active when the `startMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    ///
    open func addNotificationObservers() {
        observers = []
    }

    ///
    /// Removes observers from the default notification center.
    ///
    /// If monitoring is not active when the `stopMonitoring()` method is
    /// invoked, this method is not called. The default implementation of this
    /// method removes *all* observers from the specified notification center.
    /// If you override this method, you must be sure to invoke the superclass
    /// implementation.
    ///
    open func removeNotificationObservers() {
        observers.forEach { notificationCenter.removeObserver($0) }

        observers = []
    }

    ///
    /// Initializes a new base notification monitor.
    ///
    /// - Parameters:
    ///   - queue:  The operation queue on which notification blocks execute.
    ///
    public init(queue: OperationQueue) {
        self.queue = queue
    }

    ///
    /// Adds an observer to the default notification center
    ///
    /// - Parameters:
    ///   - name:   The name of the notification for which to register the
    ///             observer; that is, only notifications with this name are
    ///             used to add the block to the operation queue.
    ///   - object: The object whose notifications the observer wants to
    ///             receive; that is, only notifications sent by this sender
    ///             are used to add the block to the operation queue.
    ///   - block:  The block to be executed when the notification is received.
    ///
    public func observe(_ name: Notification.Name,
                        object: Any? = nil,
                        using block: @escaping (Notification) -> Void) {
        let observer = notificationCenter.addObserver(forName: name,
                                                      object: object,
                                                      queue: queue,
                                                      using: block)

        observers.append(observer)
    }

    private let queue: OperationQueue

    private var observers: [NSObjectProtocol] = []

    public override final func cleanupMonitor() {
        removeNotificationObservers()

        super.cleanupMonitor()
    }

    public override final func configureMonitor() {
        super.configureMonitor()

        addNotificationObservers()
    }
}

extension BaseNotificationMonitor: NotificationCenterInjected {}
