// © 2018–2025 John Gary Pusey (see LICENSE.md).

#if os(iOS) || os(tvOS)

import UIKit

/// A `ScreenMonitor` instance monitors a screen for changes.
public final class ScreenMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the screen.
    public enum Event {
        /// The brightness level of the screen has changed.
        case brightnessDidChange(UIScreen)

        /// The captured status of the screen has changed.
        case capturedDidChange(UIScreen)

        /// The current mode of the screen has changed.
        case modeDidChange(UIScreen)
    }

    /// Initializes a new `ScreenMonitor`.
    /// - Parameters:
    ///   - screen:     The screen to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the screen changes.
    public init(screen: UIScreen,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.screen = screen

        super.init(queue: queue)
    }

    /// The screen being monitored.
    public let screen: UIScreen

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIScreen.brightnessDidChangeNotification,
                object: screen) { [unowned self] in
            if let screen = $0.object as? UIScreen {
                self.handler(.brightnessDidChange(screen))
            }
        }

        observe(UIScreen.capturedDidChangeNotification) { [unowned self] in
            if let screen = $0.object as? UIScreen {
                self.handler(.capturedDidChange(screen))
            }
        }

        observe(UIScreen.modeDidChangeNotification,
                object: screen) { [unowned self] in
            if let screen = $0.object as? UIScreen {
                self.handler(.modeDidChange(screen))
            }
        }
    }
}

#endif
