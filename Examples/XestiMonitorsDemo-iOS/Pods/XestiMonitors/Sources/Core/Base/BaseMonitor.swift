//
//  BaseMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// An abstract base class that simplifies the implementation of a monitor.
///
open class BaseMonitor: Monitor {
    ///
    /// Cleans up the monitor so that active monitoring can stop.
    ///
    /// If monitoring is not active when the `stopMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    ///
    open func cleanupMonitor() {
    }

    ///
    /// Configures the monitor so that active monitoring can start.
    ///
    /// If monitoring is already active when the `startMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    ///
    open func configureMonitor() {
    }

    ///
    /// Initializes a new base monitor.
    ///
    public init() {
    }

    ///
    /// A Boolean value indicating whether monitoring of events specific to the
    /// monitor is active.
    ///
    public private(set) final var isMonitoring = false

    ///
    /// Starts active monitoring of events specific to the monitor.
    ///
    public final func startMonitoring() {
        if !isMonitoring {
            configureMonitor()
            isMonitoring = true
        }
    }

    ///
    /// Stops active monitoring of events specific to the monitor.
    ///
    public final func stopMonitoring() {
        if isMonitoring {
            cleanupMonitor()
            isMonitoring = false
        }
    }

    deinit {
        stopMonitoring()
    }
}
