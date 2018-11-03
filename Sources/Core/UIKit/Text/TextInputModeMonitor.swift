//
//  TextInputModeMonitorswift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-04-07.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import UIKit

///
/// A `TextInputModeMonitor` instance monitors the responder chain for changes
/// to the current input mode.
///
public class TextInputModeMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the current input mode.
    ///
    public enum Event {
        ///
        /// The current input mode has changed.
        ///
        case didChange(UITextInputMode?)
    }

    ///
    /// Initializes a new `TextInputModeMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the current input mode
    ///                 changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UITextInputMode.currentInputModeDidChangeNotification) { [unowned self] in
            self.handler(.didChange($0.object as? UITextInputMode))
        }
    }
}

#endif
