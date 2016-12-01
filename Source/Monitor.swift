//
//  Monitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// A type that monitors events. What constitutes an *event* is specific to the
/// implementation.
///
public protocol Monitor {

    // MARK: Instance Properties

    ///
    /// A Boolean value indicating whether monitoring of events specific to the
    /// monitor is active (`true`) or not (`false`).
    ///
    var isMonitoring: Bool { get }

    // MARK: Instance Methods

    ///
    /// Starts active monitoring of events specific to the monitor.
    ///
    /// - Returns:  `true` if active monitoring was successfully started or
    ///             `false` on failure (or if monitoring was already active).
    ///
    @discardableResult
    func startMonitoring() -> Bool

    ///
    /// Stops active monitoring of events specific to the monitor.
    ///
    /// - Returns:  `true` if active monitoring was successfully stopped or
    ///             `false` on failure (or if monitoring was not active).
    ///
    @discardableResult
    func stopMonitoring() -> Bool

}
