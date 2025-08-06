// © 2016–2025 John Gary Pusey (see LICENSE.md)

/// A type that monitors events. What constitutes an *event* is specific to the
/// implementation.
public protocol Monitor {
    /// A Boolean value indicating whether monitoring of events specific to the
    /// monitor is active.
    var isMonitoring: Bool { get }

    /// Starts active monitoring of events specific to the monitor.
    func startMonitoring()

    /// Stops active monitoring of events specific to the monitor.
    func stopMonitoring()
}
