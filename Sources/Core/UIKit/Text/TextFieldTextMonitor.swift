//
//  TextFieldTextMonitor.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-04-04.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

///
/// A `TextFieldTextMonitor` instance monitors a text field for changes to its
/// text.
///
public class TextFieldTextMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the text of the text field.
    ///
    public enum Event {
        ///
        /// An editing session has begun for the text field.
        ///
        case didBeginEditing(UITextField)

        ///
        /// The text in the text field has changed.
        ///
        case didChange(UITextField)

        ///
        /// The editing session has ended for the text field.
        ///
        case didEndEditing(UITextField)
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didBeginEditing` events.
        ///
        public static let didBeginEditing = Options(rawValue: 1 << 0)

        ///
        /// Monitor `didChange` events.
        ///
        public static let didChange = Options(rawValue: 1 << 1)

        ///
        /// Monitor `didEndEditing` events.
        ///
        public static let didEndEditing = Options(rawValue: 1 << 2)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.didBeginEditing,
                                          .didChange,
                                          .didEndEditing]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public var rawValue: UInt
    }

    ///
    /// Initializes a new `TextFieldTextMonitor`.
    ///
    /// - Parameters:
    ///   - textField:  The text field to monitor.
    ///   - options:    The options that specify which events to monitor. By
    ///                 default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the text of the text field
    ///                 changes.
    ///
    public init(textField: UITextField,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options
        self.textField = textField

        super.init(queue: queue)
    }

    ///
    /// The text field being monitored.
    ///
    public let textField: UITextField

    private let handler: (Event) -> Void
    private let options: Options

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didBeginEditing) {
            observe(.UITextFieldTextDidBeginEditing,
                    object: textField) { [unowned self] in
                        if let textField = $0.object as? UITextField {
                            self.handler(.didBeginEditing(textField))
                        }
            }
        }

        if options.contains(.didChange) {
            observe(.UITextFieldTextDidChange,
                    object: textField) { [unowned self] in
                        if let textField = $0.object as? UITextField {
                            self.handler(.didChange(textField))
                        }
            }
        }

        if options.contains(.didEndEditing) {
            observe(.UITextFieldTextDidEndEditing,
                    object: textField) { [unowned self] in
                        if let textField = $0.object as? UITextField {
                            self.handler(.didEndEditing(textField))
                        }
            }
        }
    }
}

#endif
