//
//  ScreenBrightnessMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-03-23.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

#if os(iOS) || os(tvOS)

import UIKit

///
/// A `ScreenBrightnessMonitor` instance monitors a screen for changes to
/// its brightness level.
///
public class ScreenBrightnessMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the brightness level of the screen.
    ///
    public enum Event {
        ///
        /// The brightness level of the screen has changed.
        ///
        case didChange(UIScreen)
    }

    ///
    /// Initializes a new `ScreenBrightnessMonitor`.
    ///
    /// - Parameters:
    ///   - screen:     The screen to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the brightness level of
    ///                 the screen changes.
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

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.UIScreenBrightnessDidChange,
                object: screen) { [unowned self] in
                    if let screen = $0.object as? UIScreen {
                        self.handler(.didChange(screen))
                    }
        }
    }
}

#endif
