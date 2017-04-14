//
//  BaseMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// An abstract base class that simplifies the implementation of a monitor.
///
open class BaseMonitor: Monitor {

    // Open Instance Methods

    ///
    /// Cleans up the monitor so that active monitoring can stop.
    ///
    /// If monitoring is not active when the `stopMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    ///
    /// - Returns:  `true` if the monitor was successfully cleaned up or
    ///             `false` on failure.
    ///
    open func cleanupMonitor() -> Bool {

        return true

    }

    ///
    /// Configures the monitor so that active monitoring can start.
    ///
    /// If monitoring is already active when the `startMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    ///
    /// - Returns:  `true` if the monitor was successfully configured or
    ///             `false` on failure.
    ///
    open func configureMonitor() -> Bool {

        return true

    }

    // Public Instance Properties

    ///
    /// A Boolean value indicating whether monitoring of events specific to the
    /// monitor is active (`true`) or not (`false`).
    ///
    public private(set) final var isMonitoring = false

    // Public Instance Methods

    ///
    /// Starts active monitoring of events specific to the monitor.
    ///
    /// - Returns:  `true` if active monitoring was successfully started or
    ///             `false` on failure (or if monitoring was already active).
    ///
    @discardableResult
    public final func startMonitoring() -> Bool {

        guard !isMonitoring
            else { return false }

        if configureMonitor() {
            isMonitoring = true
        }

        return isMonitoring

    }

    ///
    /// Stops active monitoring of events specific to the monitor.
    ///
    /// - Returns:  `true` if active monitoring was successfully stopped or
    ///             `false` on failure (or if monitoring was not active).
    ///
    @discardableResult
    public final func stopMonitoring() -> Bool {

        guard isMonitoring
            else { return false }

        if cleanupMonitor() {
            isMonitoring = false
        }

        return !isMonitoring

    }

    // Deinitializer

    deinit {

        stopMonitoring()

    }

}
