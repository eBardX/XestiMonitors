//
//  PortMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `PortMonitor` instance monitors a port for changes to its validity.
///
public class PortMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the validity of the port.
    ///
    public enum Event {
        ///
        /// The port has become invalid.
        ///
        case didBecomeInvalid(Port)
    }

    ///
    /// Initializes a new `PortMonitor`.
    ///
    /// - Parameters:
    ///   - port:       The port to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the validity of the port
    ///                 changes.
    ///
    public init(port: Port,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.port = port

        super.init(queue: queue)
    }

    ///
    /// The port being monitored.
    ///
    public let port: Port

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(Port.didBecomeInvalidNotification,
                object: port) { [unowned self] in
                    if let port = $0.object as? Port {
                        self.handler(.didBecomeInvalid(port))
                    }
        }
    }
}
