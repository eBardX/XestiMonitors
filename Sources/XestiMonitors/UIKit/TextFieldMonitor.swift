// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// A `TextFieldMonitor` instance monitors a text field for changes..
public final class TextFieldMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the text field.
    public enum Event {
        /// An editing session has begun for the text field.
        case textDidBeginEditing(UITextField)

        /// The text in the text field has changed.
        case textDidChange(UITextField)

        /// The editing session has ended for the text field.
        case textDidEndEditing(UITextField)
    }

    /// Initializes a new `TextFieldMonitor`.
    /// - Parameters:
    ///   - textField:  The text field to monitor.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the text field changes.
    public init(textField: UITextField,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.textField = textField

        super.init(queue: queue)
    }

    /// The text field being monitored.
    public let textField: UITextField

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UITextField.textDidBeginEditingNotification,
                object: textField) { [unowned self] in
            if let textField = $0.object as? UITextField {
                self.handler(.textDidBeginEditing(textField))
            }
        }

        observe(UITextField.textDidChangeNotification,
                object: textField) { [unowned self] in
            if let textField = $0.object as? UITextField {
                self.handler(.textDidChange(textField))
            }
        }

        observe(UITextField.textDidEndEditingNotification,
                object: textField) { [unowned self] in
            if let textField = $0.object as? UITextField {
                self.handler(.textDidEndEditing(textField))
            }
        }
    }
}

#endif
