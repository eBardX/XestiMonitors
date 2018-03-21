//
//  UbiquityIdentityMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-12.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `UbiquityIdentityMonitor` instance monitors the system for changes to the
/// iCloud (”ubiquity”) identity. The iCloud identity changes when the current
/// user logs into or out of an iCloud account, or enables or disables the
/// syncing of documents and data.
///
public class UbiquityIdentityMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the iCloud identity.
    ///
    public enum Event {
        ///
        /// The iCloud identity has changed. The associated value is `nil` if
        /// this change is due to the current user disabling or logging out of
        /// iCloud.
        ///
        case didChange(AnyObject?)
    }

    ///
    /// Initializes a new `UbiquityIdentityMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the iCloud identity changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.fileManager = FileManagerInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    ///
    /// An opaque token that represents the current user’s iCloud identity. The
    /// value of this token is `nil` if the current user has disabled or logged
    /// out of iCloud.
    ///
    public var token: AnyObject? {
        return fileManager.ubiquityIdentityToken as AnyObject?
    }

    private let fileManager: FileManagerProtocol
    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSUbiquityIdentityDidChange) { [unowned self] _ in
            self.handler(.didChange(self.token))
        }
    }
}
