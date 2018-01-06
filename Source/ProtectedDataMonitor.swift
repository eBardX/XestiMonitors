//
//  ProtectedDataMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `ProtectedDataMonitor` instance monitors the app for changes to the
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

    ///
    ///
    ///
    public struct Options: OptionSet {
        ///
        ///
        ///
        public static let didBecomeAvailable = Options(rawValue: 1 << 0)

        ///
        ///
        ///
        public static let willBecomeUnavailable = Options(rawValue: 1 << 1)

        ///
        ///
        ///
        public static let all: Options = [.didBecomeAvailable,
                                          .willBecomeUnavailable]

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public let rawValue: UInt
    }

    ///
    /// Initializes a new `ProtectedDataMonitor`.
    ///
    /// - Parameters:
    ///   - notificationCenter:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - application:
    ///   - options:
    ///   - handler:    The handler to call when protected files become
    ///                 available for your code to access, or shortly before
    ///                 protected files are locked down and become inaccessible.
    ///
    public init(notificationCenter: NotificationCenter = NSNotificationCenter.`default`,
                queue: OperationQueue = .main,
                application: Application = UIApplication.shared,
                options: Options = .all,
                handler: @escaping (Event) -> Void) {
        self.application = application
        self.handler = handler
        self.options = options

        super.init(notificationCenter: notificationCenter,
                   queue: queue)
    }

    ///
    ///
    ///
    public var isContentAccessible: Bool {
        return application.isProtectedDataAvailable
    }

    private let application: Application
    private let handler: (Event) -> Void
    private let options: Options

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didBecomeAvailable) {
            observe(.UIApplicationProtectedDataDidBecomeAvailable) { [unowned self] _ in
                self.handler(.didBecomeAvailable)
            }
        }

        if options.contains(.willBecomeUnavailable) {
            observe(.UIApplicationProtectedDataWillBecomeUnavailable) { [unowned self] _ in
                self.handler(.willBecomeUnavailable)
            }
        }
    }
}
