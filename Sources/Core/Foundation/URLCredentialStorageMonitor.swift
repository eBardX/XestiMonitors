//
//  URLCredentialStorageMonitor.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-05-29.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `URLCredentialStorageMonitor` instance monitors the system for changes
/// in the credentials storage
///
public class URLCredentialStorageMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the url credentials storage.
    ///
    public enum Event {
        case changed(URLCredentialStorage)
    }

    ///
    /// Initializes a new `URLCredentialStorageMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the bundle dynamically loads
    ///                 classes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    private func extractUrlCredentialStorage(_ notification: Notification) -> URLCredentialStorage? {
        guard
            let urlCredentialStorage = notification.object as? URLCredentialStorage
            else { return nil }

        return urlCredentialStorage
    }

    override public func  addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSURLCredentialStorageChanged,
                object: URLCredentialStorage.shared) { [unowned self] in
                    if let urlCredentialStorage = self.extractUrlCredentialStorage($0) {
                        self.handler(.changed(urlCredentialStorage))
                    }
        }
    }
}
