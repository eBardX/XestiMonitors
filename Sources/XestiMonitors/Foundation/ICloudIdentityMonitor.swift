// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

/// An `ICloudIdentityMonitor` instance monitors the system for changes to the
/// iCloud identity. The iCloud identity changes when the current
/// user logs into or out of an iCloud account, or enables or disables the
/// syncing of documents and data.
public final class ICloudIdentityMonitor: BaseNotificationMonitor {

    // MARK: Public Initializers

    /// Initializes a new `ICloudIdentityMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the iCloud identity changes.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    // MARK: Private Instance Properties

    @Inject private var fileManager: any FileManagerProtocol

    private let handler: (Event) -> Void

    // MARK: Overridden Public Instance Methods

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSUbiquityIdentityDidChange) { [unowned self] _ in
            self.handler(.didChange(self.identity))
        }
    }
}

// MARK: -

extension ICloudIdentityMonitor {

    // MARK: Public Nested Types

    /// Encapsulates changes to the iCloud identity.
    public enum Event {
        /// The iCloud identity has changed. The associated value is `nil` if
        /// this change is due to the current user disabling or logging out of
        /// iCloud.
        case didChange(ICloudIdentity?)
    }

    // MARK: Public Instance Properties

    /// An opaque token that represents the current user’s iCloud identity. The
    /// value of this token is `nil` if the current user has disabled or logged
    /// out of iCloud.
    public var identity: ICloudIdentity? {
        guard let token = fileManager.ubiquityIdentityToken
        else { return nil }

        return .init(token)
    }
}
