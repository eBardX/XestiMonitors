// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

/// A `ProcessInfoMonitor` instance monitors…
public final class ProcessInfoMonitor: BaseNotificationMonitor {

    // MARK: Public Initializers

    /// Initializes a new `ProcessInfoMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the thermal state changes.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.processInfo = ProcessInfoInjector.inject()

        super.init(queue: queue)
    }

    // MARK: Private Instance Properties

    private let handler: (Event) -> Void
    private let processInfo: any ProcessInfoProtocol

    // MARK: Overridden Public Instance Methods

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSProcessInfoPowerStateDidChange,
                object: processInfo) { [unowned self] _ in
            self.handler(.powerStateDidChange(self.isLowPowerModeEnabled))
        }

        observe(ProcessInfo.thermalStateDidChangeNotification,
                object: processInfo) { [unowned self] _ in
            self.handler(.thermalStateDidChange(self.thermalState))
        }
    }
}

// MARK: -

extension ProcessInfoMonitor {

    // MARK: Public Nested Types

    /// Encapsulates changes to…
    public enum Event {
        /// The power state of the device has changed.
        case powerStateDidChange(Bool)

        /// The thermal state has changed.
        case thermalStateDidChange(ProcessInfo.ThermalState)
    }

    // MARK: Public Instance Properties

    /// A Boolean value indicating whether Low Power Mode is enabled on the
    /// device.
    public var isLowPowerModeEnabled: Bool {
        processInfo.isLowPowerModeEnabled
    }

    /// The current thermal state.
    public var thermalState: ProcessInfo.ThermalState {
        processInfo.thermalState
    }
}
