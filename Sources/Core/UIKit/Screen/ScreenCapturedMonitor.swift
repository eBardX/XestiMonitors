//
//  ScreenCapturedMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-04-06.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

#if os(iOS) || os(tvOS)

import UIKit

///
/// A `ScreenCapturedMonitor` instance monitors a screen for changes to its
/// captured status.
///
@available(iOS 11.0, tvOS 11.0, *)
public class ScreenCapturedMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the captured status of the screen.
    ///
    public enum Event {
        ///
        /// The captured status of the screen has changed.
        ///
        case didChange(UIScreen)
    }

    ///
    /// Initializes a new `ScreenCapturedMonitor`.
    ///
    /// - Parameters:
    ///   - screen:     The screen to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the captured status of the
    ///                 screen changes.
    ///
    public init(screen: UIScreen,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.screen = screen

        super.init(queue: queue)
    }

    ///
    /// The screen being monitored.
    ///
    public let screen: UIScreen

    private let handler: (Event) -> Void

    public override func addNotificationObservers() {
        super.addNotificationObservers()
        observe(.UIScreenCapturedDidChange) { [unowned self] in
            if let screen = $0.object as? UIScreen {
                self.handler(.didChange(screen))
            }
        }
    }
}

#endif
