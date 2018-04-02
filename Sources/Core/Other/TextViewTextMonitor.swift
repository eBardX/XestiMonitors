//
//  TextViewTextMonitor.swift
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
    /// A `TextViewMonitor` instance monitors a text view for changes to its
    /// text.
    ///
    internal class TextViewTextMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates changes to the text of the text view.
        ///
        public enum Event {
            ///
            /// An editing session has begun for the text view.
            ///
            case didBeginEditing(UITextView)

            ///
            /// The text in the text view has changed.
            ///
            case didChange(UITextView)

            ///
            /// The editing session has ended for the text view.
            ///
            case didEndEditing(UITextView)
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
            public let rawValue: UInt
        }

        ///
        /// Initializes a new `TextViewMonitor`.
        ///
        /// - Parameters:
        ///   - textview:   The text view to monitor.
        ///   - options:    The options that specify which events to monitor.
        ///                 By default, all events are monitored.
        ///   - queue:      The operation queue on which the handler executes.
        ///                 By default, the main operation queue is used.
        ///   - handler:    The handler to call when the text of the text view
        ///                 changes.
        ///
        public init(textView: UITextView,
                    options: Options = .all,
                    queue: OperationQueue = .main,
                    handler: @escaping (Event) -> Void) {
            self.textView = textView
            self.options = options
            self.handler = handler

            super.init(queue: queue)
        }

        ///
        /// The text view being monitored.
        ///
        public let textView: UITextView

        private let handler: (Event) -> Void
        private let options: Options

        public override func addNotificationObservers() {
            super.addNotificationObservers()

            if options.contains(.didBeginEditing) {
                observe(.UITextViewTextDidBeginEditing,
                        object: textView) { [unowned self] in
                            if let textView = $0.object as? UITextView {
                                self.handler(.didBeginEditing(textView))
                            }
                }
            }

            if options.contains(.didChange) {
                observe(.UITextViewTextDidChange,
                        object: textView) { [unowned self] in
                            if let textView = $0.object as? UITextView {
                                self.handler(.didChange(textView))
                            }
                }
            }

            if options.contains(.didEndEditing) {
                observe(.UITextViewTextDidEndEditing,
                        object: textView) { [unowned self] in
                            if let textView = $0.object as? UITextView {
                                self.handler(.didEndEditing(textView))
                            }
                }
            }
        }
    }
#endif
