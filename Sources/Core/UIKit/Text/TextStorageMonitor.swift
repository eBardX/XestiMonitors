//
//  TextStorageMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-04-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

///
/// A `TextStorageMonitor` instance monitors ...
///
public class TextStorageMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates ...
    ///
    public enum Event {
        ///
        ///
        ///
        case didProcessEditing(NSTextStorage)

        ///
        ///
        ///
        case willProcessEditing(NSTextStorage)
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didProcessEditing` events.
        ///
        public static let didProcessEditing = Options(rawValue: 1 << 0)

        ///
        /// Monitor `willProcessEditing` events.
        ///
        public static let willProcessEditing = Options(rawValue: 1 << 1)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.didProcessEditing,
                                          .willProcessEditing]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public var rawValue: UInt
    }

    ///
    /// Initializes a new `TextStorageMonitor`.
    ///
    /// - Parameters:
    ///   - textStorage:    The text storage to monitor.
    ///   - options:        The options that specify which events to monitor.
    ///                     By default, all events are monitored.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when ...
    ///
    public init(textStorage: NSTextStorage,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options
        self.textStorage = textStorage

        super.init(queue: queue)
    }

    ///
    /// The text storage being monitored.
    ///
    public let textStorage: NSTextStorage

    private let handler: (Event) -> Void
    private let options: Options

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didProcessEditing) {
            observe(.NSTextStorageDidProcessEditing,
                    object: textStorage) { [unowned self] in
                        if let textStorage = $0.object as? NSTextStorage {
                            self.handler(.didProcessEditing(textStorage))
                        }
            }
        }

        if options.contains(.willProcessEditing) {
            observe(.NSTextStorageWillProcessEditing,
                    object: textStorage) { [unowned self] in
                        if let textStorage = $0.object as? NSTextStorage {
                            self.handler(.willProcessEditing(textStorage))
                        }
            }
        }
    }
}

#endif
