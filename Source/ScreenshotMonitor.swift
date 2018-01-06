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
/// A `ScreenshotMonitor` instance monitors the app for screenshots.
///
public class ScreenshotMonitor: BaseNotificationMonitor {
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

    ///
    /// Initializes a new `ScreenshotMonitor`.
    ///
    /// - Parameters:
    ///   - notificationCenter:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the user presses the Home and
    ///                 Lock buttons to take a screenshot.
    ///
    public init(notificationCenter: NotificationCenter = NSNotificationCenter.`default`,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(notificationCenter: notificationCenter,
                   queue: queue)
    }

    private let handler: (Event) -> Void

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.UIApplicationUserDidTakeScreenshot) { [unowned self] _ in
            self.handler(.userDidTake)
        }
    }
}
