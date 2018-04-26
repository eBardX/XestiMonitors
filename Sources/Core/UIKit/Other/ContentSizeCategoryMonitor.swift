//
//  ContentSizeCategoryMonitor.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-04-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

///
/// A `ContentSizeCategoryMonitor` instance monitors the app for changes to its
/// preferred content size category.
///
public class ContentSizeCategoryMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the app’s preferred content size category.
    ///
    public enum Event {
        ///
        /// The preferred content size category has changed.
        ///
        case didChange(UIContentSizeCategory)
    }

    ///
    /// Initializes a new `ContentSizeCategoryMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the app’s preferred content
    ///                 size category changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.application = ApplicationInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    ///
    /// The font sizing option preferred by the user.
    ///
    public var preferred: UIContentSizeCategory {
        return application.preferredContentSizeCategory
    }

    private let application: ApplicationProtocol
    private let handler: (Event) -> Void

    private func extractContentSizeCategory(_ notification: Notification) -> UIContentSizeCategory? {
        guard
            let rawValue = notification.userInfo?[UIContentSizeCategoryNewValueKey] as? String
            else { return nil }

        return UIContentSizeCategory(rawValue: rawValue)
    }

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.UIContentSizeCategoryDidChange,
                object: application) { [unowned self] in
                    if let category = self.extractContentSizeCategory($0) {
                        self.handler(.didChange(category))
                    }
        }
    }
}

#endif
