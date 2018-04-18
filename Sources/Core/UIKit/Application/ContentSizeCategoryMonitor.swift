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
/// A `ContentSizeCategoryMonitor` instance monitors the application for
/// content size category changes.
///
public class ContentSizeCategoryMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the content size category of the app.
    ///
    public enum Event {
        ///
        /// The content size category of the app has changed.
        ///
        case didChange(UIContentSizeCategory)
    }

    ///
    /// Initializes a new `ContentSizeCategoryMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the content size category of
    ///                 the application changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.application = ApplicationInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    ///
    /// The content size category of the app.
    ///
    public var contentSizeCategory: UIContentSizeCategory {
        return application.preferredContentSizeCategory
    }

    private let application: ApplicationProtocol
    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.UIContentSizeCategoryDidChange,
                object: application) { [unowned self] _ in
                    self.handler(.didChange(self.contentSizeCategory))
        }
    }
}

#endif
