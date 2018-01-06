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

    ///
    ///
    ///
    public struct Options: OptionSet {
        ///
        ///
        ///
        public static let didChangeFrame = Options(rawValue: 1 << 0)

        ///
        ///
        ///
        public static let didChangeOrientation = Options(rawValue: 1 << 1)

        ///
        ///
        ///
        public static let willChangeFrame = Options(rawValue: 1 << 2)

        ///
        ///
        ///
        public static let willChangeOrientation = Options(rawValue: 1 << 3)

        ///
        ///
        ///
        public static let all: Options = [.didChangeFrame,
                                          .didChangeOrientation,
                                          .willChangeFrame,
                                          .willChangeOrientation]

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public let rawValue: UInt
    }

    ///
    /// Initializes a new `StatusBarMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - options:
    ///   - handler:    The handler to call when the orientation of the app’s
    ///                 user interface or the frame of the status bar changes
    ///                 or is about to change.
    ///
    public init(queue: OperationQueue = .main,
                options: Options = .all,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options

        super.init(queue: queue)
    }

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

    private let handler: (Event) -> Void
    private let options: Options

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

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didChangeFrame) {
            observe(.UIApplicationDidChangeStatusBarFrame) { [unowned self] in
                self.handler(.didChangeFrame(self.extractStatusBarFrame($0)))
            }
        }

        if options.contains(.didChangeOrientation) {
            observe(.UIApplicationDidChangeStatusBarOrientation) { [unowned self] in
                self.handler(.didChangeOrientation(self.extractStatusBarOrientation($0)))
            }
        }

        if options.contains(.willChangeFrame) {
            observe(.UIApplicationWillChangeStatusBarFrame) { [unowned self] in
                self.handler(.willChangeFrame(self.extractStatusBarFrame($0)))
            }
        }

        if options.contains(.willChangeOrientation) {
            observe(.UIApplicationWillChangeStatusBarOrientation) { [unowned self] in
                self.handler(.willChangeOrientation(self.extractStatusBarOrientation($0)))
            }
        }
    }
}

extension StatusBarMonitor: ApplicationInjected {}
