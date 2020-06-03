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
    ///
    /// A Boolean value indicating whether monitoring of events specific to the
    /// monitor is active (`true`) or not (`false`).
    ///
    var isMonitoring: Bool { get }

    ///
    /// Starts active monitoring of events specific to the monitor.
    ///
    func startMonitoring()

    ///
    /// Stops active monitoring of events specific to the monitor.
    ///
    func stopMonitoring()
}
