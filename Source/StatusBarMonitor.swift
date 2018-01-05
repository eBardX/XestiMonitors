//
//  StatusBarMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `StatusBarMonitor` instance monitors the app for changes to the
/// orientation of its user interface or to the frame of the status bar.
///
public class StatusBarMonitor: BaseNotificationMonitor {

    // Public Nested Types

    ///
    /// Encapsulates changes to the orientation of the app’s user interface and
    /// to the frame of the status bar.
    ///
    public enum Event {

        ///
        /// The frame of the status bar has changed.
        ///
        case didChangeFrame(CGRect)

        ///
        /// The orientation of the app’s user interface has changed.
        ///
        case didChangeOrientation(UIInterfaceOrientation)

        ///
        /// The frame of the status bar is about to change.
        ///
        case willChangeFrame(CGRect)

        ///
        /// The orientation of the app’s user interface is about to change.
        ///
        case willChangeOrientation(UIInterfaceOrientation)
    }

    // Public Initializers

    ///
    /// Initializes a new `StatusBarMonitor`.
    ///
    /// - Parameters:
    ///   - notificationCenter
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - application
    ///   - handler:    The handler to call when the orientation of the app’s
    ///                 user interface or the frame of the status bar changes
    ///                 or is about to change.
    ///
    public init(notificationCenter: NotificationCenter = Foundation.NotificationCenter.`default`,
                queue: OperationQueue = .main,
                application: Application = UIApplication.shared,
                handler: @escaping (Event) -> Void) {

        self.application = application
        self.handler = handler

        super.init(notificationCenter: notificationCenter,
                   queue: queue)

    }

    // Public Instance Properties

    ///
    /// The current frame rectangle defining the area of the status bar.
    ///
    public var frame: CGRect {
        return application.statusBarFrame
    }

    ///
    /// The orientation of the app’s user interface.
    ///
    public var orientation: UIInterfaceOrientation {
        return application.statusBarOrientation
    }

    // Private Instance Properties

    private let application: Application
    private let handler: (Event) -> Void

    // Private Instance Methods

    private func extractStatusBarFrame(_ notification: Notification) -> CGRect {

        if let frame = (notification.userInfo?[UIApplicationStatusBarFrameUserInfoKey] as? NSValue)?.cgRectValue {
            return frame
        }

        return .zero

    }

    private func extractStatusBarOrientation(_ notification: Notification) -> UIInterfaceOrientation {

        if let rawValue = (notification.userInfo?[UIApplicationStatusBarOrientationUserInfoKey] as? NSNumber)?.intValue,
            let orientation = UIInterfaceOrientation(rawValue: rawValue) {
            return orientation
        }

        return .unknown

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() {

        super.addNotificationObservers()

        observe(.UIApplicationDidChangeStatusBarFrame) { [unowned self] in
            self.handler(.didChangeFrame(self.extractStatusBarFrame($0)))
        }

        observe(.UIApplicationDidChangeStatusBarOrientation) { [unowned self] in
            self.handler(.didChangeOrientation(self.extractStatusBarOrientation($0)))
        }

        observe(.UIApplicationWillChangeStatusBarFrame) { [unowned self] in
            self.handler(.willChangeFrame(self.extractStatusBarFrame($0)))
        }

        observe(.UIApplicationWillChangeStatusBarOrientation) { [unowned self] in
            self.handler(.willChangeOrientation(self.extractStatusBarOrientation($0)))
        }

    }

}
