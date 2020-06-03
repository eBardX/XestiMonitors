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
/// A `URLCredentialStorageMonitor` instance monitors the shared URL credential
/// storage object for changes to its stored credentials.
///
public class URLCredentialStorageMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the credential storage.
    ///
    public enum Event {
        ///
        /// The stored credentials have changed.
        ///
        case changed(URLCredentialStorage)
    }

    ///
    /// Initializes a new `URLCredentialStorageMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the set of stored URL
    ///                 credentials changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.credentialStorage = .shared
        self.handler = handler

        super.init(queue: queue)
    }

    private let credentialStorage: URLCredentialStorage
    private let handler: (Event) -> Void

    override public func  addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSURLCredentialStorageChanged,
                object: credentialStorage) { [unowned self] in
                    if let credentialStorage = $0.object as? URLCredentialStorage {
                        self.handler(.changed(credentialStorage))
                    }
        }
    }
}
