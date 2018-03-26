//
//  TextViewMonitor.swift
//  XestiMonitors
//
//  Created by kayeli dennis on 2018-03-27.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

    import Foundation
    import UIKit

    ///
    /// An `TextViewMonitor` instance monitors a text view for
    /// editing-related messages.
    ///

    internal class TextViewMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates changes to the state of the text view.
        ///
        public enum Event {
            ///
            /// editing of the text view has begun.
            ///
            case didBeginEditing(UITextView)

            ///
            /// editing of the text view has ended.
            ///
            case didEndEditing(UITextView)

            ///
            /// the state of the text view has changed.
            ///
            case textDidChange(UITextView)
        }

        ///
        /// Specifies which events to monitor
        ///
        public struct Options: OptionSet {
            ///
            /// Monitor `didBeginEditing` events.
            ///
            public static let didBeginEditing = Options(rawValue: 1 << 0)

            ///
            /// Monitor `didEndEditing` events.
            ///
            public static let didEndEditing = Options(rawValue: 1 << 1)

            ///
            /// Monitor `textDidChange` events.
            ///
            public static let textDidChange = Options(rawValue: 1 << 2)


            ///
            /// Monitor all events.
            ///
            public static let all: Options = [.didBeginEditing,
                                              .didEndEditing,
                                              .textDidChange]

            /// :nodoc:
            public init(rawValue: UInt) {
                self.rawValue = rawValue
            }

            /// :nodoc:
            public let rawValue: UInt
        }

        ///
        /// Initializes a new `TextViewMonitor`.
        ///
        /// - Parameters:
        ///   - textview:   The text view to monitor.
        ///   - queue:      The operation queue on which the handler executes. By
        ///                 default, the main operation queue is used.
        ///   - handler:    The handler to call when the state of the text view
        ///                 changes.
        ///
        public init(textview: UITextView,
                    options: Options = .all,
                    queue: OperationQueue = .main,
                    handler: @escaping (Event) -> Void) {
            self.textview = textview
            self.options = options
            self.handler = handler

            super.init(queue: queue)
        }

        ///
        /// The text view being monitored.
        ///
        public let textview: UITextView

        private let handler: (Event) -> Void
        private let options: Options

        public override func addNotificationObservers() {
            super.addNotificationObservers()

            if options.contains(.didBeginEditing) {
                observe(.UITextViewTextDidBeginEditing,
                        object: textview) { [unowned self] in
                            if let textview = $0.object as? UITextView {
                                self.handler(.didBeginEditing(textview))
                            }
                }
            }

            if options.contains(.didEndEditing) {
                observe(.UITextViewTextDidEndEditing,
                        object: textview) { [unowned self] in
                            if let textview = $0.object as? UITextView {
                                self.handler(.didEndEditing(textview))
                            }
                }
            }

            if options.contains(.textDidChange) {
                observe(.UITextViewTextDidChange,
                        object: textview) { [unowned self] in
                            if let textview = $0.object as? UITextView {
                                self.handler(.textDidChange(textview))
                            }
                }
            }
        }
    }
#endif
