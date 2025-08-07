// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// A `TextViewMonitor` instance monitors a text view for changes.
public final class TextViewMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the text view.
    public enum Event {
        /// An editing session has begun for the text view.
        case textDidBeginEditing(UITextView)

        /// The text in the text view has changed.
        case textDidChange(UITextView)

        /// The editing session has ended for the text view.
        case textDidEndEditing(UITextView)
    }

    /// Initializes a new `TextViewMonitor`.
    /// - Parameters:
    ///   - textview:   The text view to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the text view changes.
    public init(textView: UITextView,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.textView = textView

        super.init(queue: queue)
    }

    /// The text view being monitored.
    public let textView: UITextView

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UITextView.textDidBeginEditingNotification,
                object: textView) { [unowned self] in
            if let textView = $0.object as? UITextView {
                self.handler(.textDidBeginEditing(textView))
            }
        }

        observe(UITextView.textDidChangeNotification,
                object: textView) { [unowned self] in
            if let textView = $0.object as? UITextView {
                self.handler(.textDidChange(textView))
            }
        }

        observe(UITextView.textDidEndEditingNotification,
                object: textView) { [unowned self] in
            if let textView = $0.object as? UITextView {
                self.handler(.textDidEndEditing(textView))
            }
        }
    }
}
#endif
