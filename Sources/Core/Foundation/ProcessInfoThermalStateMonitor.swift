//
//  ProcessInfoThermalStateMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `ProcessInfoThermalStateMonitor` instance monitors ...
///
@available(iOS 11.0, OSX 10.10.3, tvOS 11.0, watchOS 4.0, *)
public class ProcessInfoThermalStateMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to ...
    ///
    public enum Event {
        ///
        ///
        ///
        case didChange(ProcessInfo.ThermalState)
    }

    ///
    /// Initializes a new `ProcessInfoThermalStateMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when ...
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.processInfo = ProcessInfoInjector.inject()

        super.init(queue: queue)
    }

    ///
    /// The current thermal state of the system.
    ///
    public var state: ProcessInfo.ThermalState {
        return processInfo.thermalState
    }

    private let handler: (Event) -> Void
    private let processInfo: ProcessInfoProtocol

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(ProcessInfo.thermalStateDidChangeNotification) { [unowned self] _ in
            self.handler(.didChange(self.processInfo.thermalState))
        }
    }
}