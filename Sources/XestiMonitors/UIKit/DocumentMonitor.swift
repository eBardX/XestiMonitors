// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS)

import UIKit

/// A `DocumentMonitor` instance monitors a document for changes.
public final class DocumentMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the document.
    public enum Event {
        /// The state of the document has changed.
        case stateDidChange(UIDocument)
    }

    /// Initializes a new `DocumentMonitor`.
    /// - Parameters:
    ///   - document:   The document to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the document changes.
    public init(document: UIDocument,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.document = document
        self.handler = handler

        super.init(queue: queue)
    }

    /// The document being monitored.
    public let document: UIDocument

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIDocument.stateChangedNotification,
                object: document) { [unowned self] in
            if let document = $0.object as? UIDocument {
                self.handler(.stateDidChange(document))
            }
        }
    }
}

#endif
