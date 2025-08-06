// © 2016–2025 John Gary Pusey (see LICENSE.md)

import Foundation

/// An abstract base class that simplifies the implementation of a monitor
/// which relies on one or more notification observers.
open class BaseNotificationMonitor: BaseMonitor {

    // MARK: Open Instance Methods

    /// Adds observers to the default notification center.
    ///
    /// If monitoring is already active when the `startMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    open func addNotificationObservers() {
        withLock {
            unsafeObservers = []
        }
    }

    /// Removes observers from the default notification center.
    ///
    /// If monitoring is not active when the `stopMonitoring()` method is
    /// invoked, this method is not called. The default implementation of this
    /// method removes *all* observers from the specified notification center.
    /// If you override this method, you must be sure to invoke the superclass
    /// implementation.
    open func removeNotificationObservers() {
        let tmpObservers = withLock {
            let observers = unsafeObservers

            unsafeObservers = []

            return observers
        }

        tmpObservers.forEach { notificationCenter.removeObserver($0) }
    }

    // MARK: Public Initializers

    /// Initializes a new base notification monitor.
    /// - Parameters:
    ///   - queue:  The operation queue on which notification blocks execute.
    public init(queue: OperationQueue) {
        self.queue = queue
        self.unsafeObservers = []
    }

    // MARK: Private Instance Properties

    @Inject private var notificationCenter: any NotificationCenterProtocol

    private let queue: OperationQueue

    private var unsafeObservers: [any NSObjectProtocol]

    // MARK: Overridden Public Instance Methods

    override public final func cleanupMonitor() {
        removeNotificationObservers()

        super.cleanupMonitor()
    }

    override public final func configureMonitor() {
        super.configureMonitor()

        addNotificationObservers()
    }
}

// MARK: -

extension BaseNotificationMonitor {

    // MARK: Public Instance Methods

    /// Adds an observer to the default notification center
    /// - Parameters:
    ///   - name:   The name of the notification for which to register the
    ///             observer; that is, only notifications with this name are
    ///             used to add the block to the operation queue.
    ///   - object: The object whose notifications the observer wants to
    ///             receive; that is, only notifications sent by this sender
    ///             are used to add the block to the operation queue.
    ///   - block:  The block to be executed when the notification is received.
    public func observe(_ name: Notification.Name,
                        object: Any? = nil,
                        using block: @escaping @Sendable (Notification) -> Void) {
        let observer = notificationCenter.addObserver(forName: name,
                                                      object: object,
                                                      queue: queue,
                                                      using: block)

        withLock {
            unsafeObservers.append(observer)
        }
    }
}
