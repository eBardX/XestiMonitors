// © 2016–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

/// An abstract base class that simplifies the implementation of a monitor.
open class BaseMonitor: Monitor {

    // MARK: Open Instance Methods

    /// Cleans up the monitor so that active monitoring can stop.
    /// If monitoring is not active when the `stopMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    open func cleanupMonitor() {
    }

    /// Configures the monitor so that active monitoring can start.
    /// If monitoring is already active when the `startMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    open func configureMonitor() {
    }

    // MARK: Public Initializers

    /// Initializes a new base monitor.
    public init() {
        self.lock = .init(named: "\(type(of: self)).lock")
        self.unsafeIsMonitoring = false
    }

    // MARK: Deinitializer

    deinit {
        stopMonitoring()
    }

    // MARK: Private Instance Properties

    private let lock: NSRecursiveLock

    private var unsafeIsMonitoring: Bool
}

// MARK: -

extension BaseMonitor {

    // MARK: Public Instance Properties

    /// A Boolean value indicating whether monitoring of events specific to the
    /// monitor is active.
    public final var isMonitoring: Bool {
        withLock {
            unsafeIsMonitoring
        }
    }

    // MARK: Public Instance Methods

    /// Starts active monitoring of events specific to the monitor.
    public final func startMonitoring() {
        withLock {
            guard !unsafeIsMonitoring
            else { return }

            unsafeIsMonitoring = true

            configureMonitor()
        }
    }

    /// Stops active monitoring of events specific to the monitor.
    public final func stopMonitoring() {
        withLock {
            guard unsafeIsMonitoring
            else { return }

            unsafeIsMonitoring = false

            cleanupMonitor()
        }
    }

    public func withLock<R>(_ body: () throws -> R) rethrows -> R {
        try lock.withLock(body)
    }
}
