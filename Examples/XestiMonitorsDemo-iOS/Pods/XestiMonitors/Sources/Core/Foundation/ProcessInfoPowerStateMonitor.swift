//
//  ProcessInfoPowerStateMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS) || os(watchOS)

import Foundation

///
/// A `ProcessInfoPowerStateMonitor` instance monitors the device for changes
/// to its power state (Low Power Mode is enabled or disabled).
///
public class ProcessInfoPowerStateMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the power state of the device.
    ///
    public enum Event {
        ///
        /// The power state of the device has changed.
        ///
        case didChange(Bool)
    }

    ///
    /// Initializes a new `ProcessInfoPowerStateMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the power state of the device
    ///                 changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.processInfo = ProcessInfoInjector.inject()

        super.init(queue: queue)
    }

    ///
    /// A Boolean value indicating whether Lower Power Mode is enabled on the
    /// device.
    ///
    public var state: Bool {
        return processInfo.isLowPowerModeEnabled
    }

    private let handler: (Event) -> Void
    private let processInfo: ProcessInfoProtocol

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSProcessInfoPowerStateDidChange,
                object: processInfo) { [unowned self] _ in
                    self.handler(.didChange(self.processInfo.isLowPowerModeEnabled))
        }
    }
}

#endif
