// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

/// An `UndoManagerMonitor` instance monitors an undo manager for changes to
/// its recording of operations.
public final class UndoManagerMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the undo manager.
    public enum Event {
        /// The undo manager has opened or closed an undo group, or has checked
        /// the redo stack.
        case checkpoint(UndoManager)

        /// The undo manager has closed an undo group.
        case didCloseUndoGroup(UndoManager)

        /// The undo manager has opened an undo group.
        case didOpenUndoGroup(UndoManager)

        /// The undo manager has performed a redo operation.
        case didRedoChange(UndoManager)

        /// The undo manager has performed an undo operation.
        case didUndoChange(UndoManager)

        /// The undo manager is about to close an undo group.
        case willCloseUndoGroup(UndoManager)

        /// The undo manager is about to perform a redo operation.
        case willRedoChange(UndoManager)

        /// The undo manager is about to perform an undo operation.
        case willUndoChange(UndoManager)
    }

    /// Initializes a new `UndoManagerMonitor`.
    /// - Parameters:
    ///   - undoManager:    The undo manager to monitor.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when there is a change to the
    ///                     undo manager’s recording of operations.
    public init(undoManager: UndoManager,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.undoManager = undoManager

        super.init(queue: queue)
    }

    /// The undo manager being monitored.
    public let undoManager: UndoManager

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSUndoManagerCheckpoint,
                object: undoManager) { [unowned self] in
            if let undoManager = $0.object as? UndoManager {
                self.handler(.checkpoint(undoManager))
            }
        }

        observe(.NSUndoManagerDidCloseUndoGroup,
                object: undoManager) { [unowned self] in
            if let undoManager = $0.object as? UndoManager {
                self.handler(.didCloseUndoGroup(undoManager))
            }
        }

        observe(.NSUndoManagerDidOpenUndoGroup,
                object: undoManager) { [unowned self] in
            if let undoManager = $0.object as? UndoManager {
                self.handler(.didOpenUndoGroup(undoManager))
            }
        }

        observe(.NSUndoManagerDidRedoChange,
                object: undoManager) { [unowned self] in
            if let undoManager = $0.object as? UndoManager {
                self.handler(.didRedoChange(undoManager))
            }
        }

        observe(.NSUndoManagerDidUndoChange,
                object: undoManager) { [unowned self] in
            if let undoManager = $0.object as? UndoManager {
                self.handler(.didUndoChange(undoManager))
            }
        }

        observe(.NSUndoManagerWillCloseUndoGroup,
                object: undoManager) { [unowned self] in
            if let undoManager = $0.object as? UndoManager {
                self.handler(.willCloseUndoGroup(undoManager))
            }
        }

        observe(.NSUndoManagerWillRedoChange,
                object: undoManager) { [unowned self] in
            if let undoManager = $0.object as? UndoManager {
                self.handler(.willRedoChange(undoManager))
            }
        }

        observe(.NSUndoManagerWillUndoChange,
                object: undoManager) { [unowned self] in
            if let undoManager = $0.object as? UndoManager {
                self.handler(.willUndoChange(undoManager))
            }
        }
    }
}
