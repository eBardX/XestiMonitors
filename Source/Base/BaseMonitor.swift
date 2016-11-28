//
//  BaseMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// An abstract base class that simplifies the implementation of `Monitor`
/// classes.
///
public class BaseMonitor: Monitor {

    // MARK: Public Instance Methods

    ///
    /// Cleans up the monitor so that active monitoring can end.
    ///
    /// If monitoring is not active when the `endMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    ///
    /// - Returns:  `true` if the monitor was successfully cleaned up or
    ///             `false` on failure.
    ///
    public func cleanupMonitor() -> Bool {

        return true

    }

    ///
    /// Configures the monitor so that active monitoring can begin.
    ///
    /// If monitoring is already active when the `beginMonitoring()` method is
    /// invoked, this method is not called. If you override this method, you
    /// must be sure to invoke the superclass implementation.
    ///
    /// - Returns:  `true` if the monitor was successfully configured or
    ///             `false` on failure.
    ///
    public func configureMonitor() -> Bool {

        return true

    }

    // MARK: Monitor Instance Properties

    ///
    /// A Boolean value indicating whether monitoring is active (`true`) or not
    /// (`false`).
    ///
    public private(set) final var isMonitoring = false

    // MARK: Monitor Instance Methods

    ///
    /// Begins active monitoring of changes specific to the monitor.
    ///
    /// - Returns:  `true` if active monitoring was successfully begun or
    ///             `false` on failure (or if monitoring was already active).
    ///
    @discardableResult
    public final func beginMonitoring() -> Bool {

        guard !isMonitoring else { return false }

        if configureMonitor() {
            isMonitoring = true
        }

        return isMonitoring

    }

    ///
    /// Ends active monitoring of changes specific to the monitor.
    ///
    /// - Returns:  `true` if active monitoring was successfully ended or
    ///             `false` on failure (or if monitoring was not active).
    ///
    @discardableResult
    public final func endMonitoring() -> Bool {

        guard isMonitoring else { return false }

        if cleanupMonitor() {
            isMonitoring = false
        }

        return !isMonitoring

    }

    // MARK: Deinitializer

    deinit {

        endMonitoring()

    }

}
