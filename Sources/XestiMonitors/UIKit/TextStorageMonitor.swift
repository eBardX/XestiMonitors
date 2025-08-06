// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// A `TextStorageMonitor` instance monitors a text storage for the processing
/// of edits to its contents.
public final class TextStorageMonitor: BaseNotificationMonitor {
    /// Encapsulates the processing of edits to the contents of the
    /// text storage.
    public enum Event {
        /// The text storage has processed the edits to its contents.
        case didProcessEditing(NSTextStorage)

        /// The text storage is about to process the edits to its contents.
        case willProcessEditing(NSTextStorage)
    }

    /// Initializes a new `TextStorageMonitor`.
    /// - Parameters:
    ///   - textStorage:    The text storage to monitor.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when the text storage has
    ///                     processed or is about to process edits to its
    ///                     contents.
    public init(textStorage: NSTextStorage,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.textStorage = textStorage

        super.init(queue: queue)
    }

    /// The text storage being monitored.
    public let textStorage: NSTextStorage

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(NSTextStorage.didProcessEditingNotification,
                object: textStorage) { [unowned self] in
            if let textStorage = $0.object as? NSTextStorage {
                self.handler(.didProcessEditing(textStorage))
            }
        }

        observe(NSTextStorage.willProcessEditingNotification,
                object: textStorage) { [unowned self] in
            if let textStorage = $0.object as? NSTextStorage {
                self.handler(.willProcessEditing(textStorage))
            }
        }
    }
}

#endif
