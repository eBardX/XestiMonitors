//
//  ScreenshotMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `ScreenshotMonitor` object monitors the app for screenshots.
///
public class ScreenshotMonitor: BaseNotificationMonitor {

    // Public Nested Types

    ///
    /// Encapsulates screenshots taken when the user presses the Home and Lock
    /// buttons.
    ///
    public enum Event {
        ///
        /// The user has taken a screenshot.
        ///
        case userDidTake
    }

    // Public Initializers

    ///
    /// Initializes a new `ScreenshotMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which notification blocks
    ///                 execute. By default, the main operation queue is used.
    ///   - handler:    The handler to call when the user presses the Home and
    ///                 Lock buttons to take a screenshot.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.handler = handler

        super.init(queue: queue)

    }

    // Private Instance Properties

    private let handler: (Event) -> Void

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard super.addNotificationObservers()
            else { return false }

        observe(.UIApplicationUserDidTakeScreenshot) { [unowned self] _ in
            self.handler(.userDidTake)
        }

        return true

    }

}
