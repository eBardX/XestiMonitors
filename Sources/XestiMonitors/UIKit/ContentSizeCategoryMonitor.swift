// © 2018–2025 John Gary Pusey (see LICENSE.md).

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// A `ContentSizeCategoryMonitor` instance monitors the app for changes to its
/// preferred content size category.
public final class ContentSizeCategoryMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the app’s preferred content size category.
    public enum Event {
        /// The preferred content size category has changed.
        case didChange(UIContentSizeCategory)
    }

    /// Initializes a new `ContentSizeCategoryMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the app’s preferred content
    ///                 size category changes.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.app = AppInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    /// The font sizing option preferred by the user.
    public var preferred: UIContentSizeCategory {
        app.preferredContentSizeCategory
    }

    private let app: any AppProtocol
    private let handler: (Event) -> Void

    private func extractContentSizeCategory(_ notification: Notification) -> UIContentSizeCategory? {
        guard let rawValue = notification.userInfo?[UIContentSizeCategory.newValueUserInfoKey] as? String
        else { return nil }

        return UIContentSizeCategory(rawValue: rawValue)
    }

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIContentSizeCategory.didChangeNotification,
                object: app) { [unowned self] in
            if let category = self.extractContentSizeCategory($0) {
                self.handler(.didChange(category))
            }
        }
    }
}

#endif
