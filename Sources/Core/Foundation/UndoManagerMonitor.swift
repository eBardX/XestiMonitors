//
//  UndoManagerMonitor.swift
//  XestiMonitors
//
//  Created by Rose Maina on 2018-04-30.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// An `UndoManagerMonitor` instance monitors an undo manager for changes to
/// its recording of operations.
///
public class UndoManagerMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the undo manager.
    ///
    public enum Event {
        ///
        /// The undo manager has opened or closed an undo group, or has checked
        /// the redo stack.
        ///
        case checkpoint(UndoManager)

        ///
        /// The undo manager has closed an undo group.
        ///
        case didCloseUndoGroup(UndoManager)

        ///
        /// The undo manager has opened an undo group.
        ///
        case didOpenUndoGroup(UndoManager)

        ///
        /// The undo manager has performed a redo operation.
        ///
        case didRedoChange(UndoManager)

        ///
        /// The undo manager has performed an undo operation.
        ///
        case didUndoChange(UndoManager)

        ///
        /// The undo manager is about to close an undo group.
        ///
        case willCloseUndoGroup(UndoManager)

        ///
        /// The undo manager is about to perform a redo operation.
        ///
        case willRedoChange(UndoManager)

        ///
        /// The undo manager is about to perform an undo operation.
        ///
        case willUndoChange(UndoManager)
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor 'checkpoint' events.
        ///
        public static let checkpoint = Options(rawValue: 1 << 0)

        ///
        /// Monitor 'didCloseUndoGroup' events.
        ///
        public static let didCloseUndoGroup = Options(rawValue: 1 << 1)

        ///
        /// Monitor 'didOpenUndoGroup' events.
        ///
        public static let didOpenUndoGroup = Options(rawValue: 1 << 2)

        ///
        /// Monitor 'didRedoChange' events.
        ///
        public static let didRedoChange = Options(rawValue: 1 << 3)

        ///
        /// Monitor 'didUndoChange' events.
        ///
        public static let didUndoChange = Options(rawValue: 1 << 4)

        ///
        /// Monitor 'willCloseUndoGroup' events.
        ///
        public static let willCloseUndoGroup = Options(rawValue: 1 << 5)

        ///
        /// Monitor 'willRedoChange' events.
        ///
        public static let willRedoChange = Options(rawValue: 1 << 6)

        ///
        /// Monitor 'willUndoChange' events.
        ///
        public static let willUndoChange = Options(rawValue: 1 << 7)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.checkpoint,
                                          .didCloseUndoGroup,
                                          .didOpenUndoGroup,
                                          .didRedoChange,
                                          .didUndoChange,
                                          .willCloseUndoGroup,
                                          .willRedoChange,
                                          .willUndoChange]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `UndoManagerMonitor`.
    ///
    /// - Parameters:
    ///   - undoManager:    The undo manager to monitor.
    ///   - options:        The options that specify which events to monitor.
    ///                     By default, all events are monitored.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when there is a change to the
    ///                     undo manager’s recording of operations.
    ///
    public init(undoManager: UndoManager,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options
        self.undoManager = undoManager

        super.init(queue: queue)
    }

    ///
    /// The undo manager being monitored.
    ///
    public let undoManager: UndoManager

    private let handler: (Event) -> Void
    private let options: Options

    private func observeIf(_ member: Options,
                           _ name: Notification.Name,
                           _ eventProvider: @escaping (UndoManager) -> Event) {
        if options.contains(member) {
            observe(name,
                    object: undoManager) { [unowned self] in
                        if let undoManager = $0.object as? UndoManager {
                            self.handler(eventProvider(undoManager))
                        }
            }
        }
    }

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observeIf(.checkpoint,
                  .NSUndoManagerCheckpoint) { .checkpoint($0) }

        observeIf(.didCloseUndoGroup,
                  .NSUndoManagerDidCloseUndoGroup) { .didCloseUndoGroup($0) }

        observeIf(.didOpenUndoGroup,
                  .NSUndoManagerDidOpenUndoGroup) { .didOpenUndoGroup($0) }

        observeIf(.didRedoChange,
                  .NSUndoManagerDidRedoChange) { .didRedoChange($0) }

        observeIf(.didUndoChange,
                  .NSUndoManagerDidUndoChange) { .didUndoChange($0) }

        observeIf(.willCloseUndoGroup,
                  .NSUndoManagerWillCloseUndoGroup) { .willCloseUndoGroup($0) }

        observeIf(.willRedoChange,
                  .NSUndoManagerWillRedoChange) { .willRedoChange($0) }

        observeIf(.willUndoChange,
                  .NSUndoManagerWillUndoChange) { .willUndoChange($0) }
    }
}
