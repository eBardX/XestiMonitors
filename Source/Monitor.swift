//
//  Monitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// A type that monitors something.
///
public protocol Monitor {

    // MARK: Instance Properties

    ///
    /// A Boolean value indicating whether monitoring is active (`true`) or not
    /// (`false`).
    ///
    var isMonitoring: Bool { get }

    // MARK: Instance Methods

    ///
    /// Begins active monitoring of changes specific to the monitor.
    ///
    /// - Returns:  `true` if active monitoring was successfully begun or
    ///             `false` on failure (or if monitoring was already active).
    ///
    @discardableResult
    func beginMonitoring() -> Bool

    ///
    /// Ends active monitoring of changes specific to the monitor.
    ///
    /// - Returns:  `true` if active monitoring was successfully ended or
    ///             `false` on failure (or if monitoring was not active).
    ///
    @discardableResult
    func endMonitoring() -> Bool

}
