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
/// A `StatusBarMonitor` object monitors the app for changes to the orientation
/// of its user interface or to the frame of the status bar.
///
public class StatusBarMonitor: BaseNotificationMonitor {

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
    ///   - handler:    The handler to call when the orientation of the app’s
    ///                 user interface or the frame of the status bar changes
    ///                 or is about to change.
    ///
    public init(handler: @escaping (Event) -> Void) {

        self.application = UIApplication.shared
        self.handler = handler

    }

    // Public Instance Properties

    ///
    /// The current frame rectangle defining the area of the status bar.
    ///
    public var frame: CGRect { return application.statusBarFrame }

    ///
    /// The orientation of the app’s user interface.
    ///
    public var orientation: UIInterfaceOrientation { return application.statusBarOrientation }

    // Private Instance Properties

    private let application: UIApplication
    private let handler: (Event) -> Void

    // Private Instance Methods

    @objc private func applicationDidChangeStatusBarFrame(_ notification: Notification) {

        if let frame = (notification.userInfo?[UIApplicationStatusBarFrameUserInfoKey] as? NSValue)?.cgRectValue {
            handler(.didChangeFrame(frame))
        } else {
            handler(.didChangeFrame(.zero))
        }

    }

    @objc private func applicationDidChangeStatusBarOrientation(_ notification: Notification) {

        if let rawValue = (notification.userInfo?[UIApplicationStatusBarOrientationUserInfoKey] as? NSNumber)?.intValue,
            let orientation = UIInterfaceOrientation(rawValue: rawValue) {
            handler(.didChangeOrientation(orientation))
        } else {
            handler(.didChangeOrientation(.unknown))
        }

    }

    @objc private func applicationWillChangeStatusBarFrame(_ notification: Notification) {

        if let frame = (notification.userInfo?[UIApplicationStatusBarFrameUserInfoKey] as? NSValue)?.cgRectValue {
            handler(.willChangeFrame(frame))
        } else {
            handler(.willChangeFrame(.zero))
        }

    }

    @objc private func applicationWillChangeStatusBarOrientation(_ notification: Notification) {

        if let rawValue = (notification.userInfo?[UIApplicationStatusBarOrientationUserInfoKey] as? NSNumber)?.intValue,
            let orientation = UIInterfaceOrientation(rawValue: rawValue) {
            handler(.willChangeOrientation(orientation))
        } else {
            handler(.willChangeOrientation(.unknown))
        }

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        guard super.addNotificationObservers(notificationCenter) else { return false }

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidChangeStatusBarFrame(_:)),
                                       name: .UIApplicationDidChangeStatusBarFrame,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidChangeStatusBarOrientation(_:)),
                                       name: .UIApplicationDidChangeStatusBarOrientation,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationWillChangeStatusBarFrame(_:)),
                                       name: .UIApplicationWillChangeStatusBarFrame,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationWillChangeStatusBarOrientation(_:)),
                                       name: .UIApplicationWillChangeStatusBarOrientation,
                                       object: nil)

        return true

    }

}
