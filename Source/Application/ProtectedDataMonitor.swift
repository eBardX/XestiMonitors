//
//  ProtectedDataMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// A `ProtectedDataMonitor` object monitors the app for changes to the
/// accessibility of protected files.
///
public class ProtectedDataMonitor: BaseNotificationMonitor {

    ///
    /// Encapsulates changes to the accessibility of protected files.
    ///
    public enum Event {

        ///
        /// Protected files have become available for your code to access.
        ///
        case didBecomeAvailable

        ///
        /// Protected files are about to be locked down and become
        /// inaccessible.
        ///
        case willBecomeUnavailable
    }

    // MARK: Public Initializers

    ///
    /// Initializes a new `ProtectedDataMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when protected files become
    ///                 available for your code to access, or shortly before
    ///                 protected files are locked down and become inaccessible.
    ///
    public init(handler: @escaping (Event) -> Void) {

        self.handler = handler

    }

    // MARK: Private Instance Properties

    private let handler: (Event) -> Void

    // MARK: Private Instance Methods

    @objc private func applicationProtectedDataDidBecomeAvailable(_ notification: NSNotification) {

        handler(.didBecomeAvailable)

    }

    @objc private func applicationProtectedDataWillBecomeUnavailable(_ notification: NSNotification) {

        handler(.willBecomeUnavailable)

    }

    // MARK: Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ center: NotificationCenter) -> Bool {

        center.addObserver(self,
                           selector: #selector(applicationProtectedDataDidBecomeAvailable(_:)),
                           name: .UIApplicationProtectedDataDidBecomeAvailable,
                           object: nil)

        center.addObserver(self,
                           selector: #selector(applicationProtectedDataWillBecomeUnavailable(_:)),
                           name: .UIApplicationProtectedDataWillBecomeUnavailable,
                           object: nil)

        return true

    }

}
