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
/// A `UndoManagerMonitor` instance monitors a device for changes whenever
/// text editing occurs.
///
public class UndoManagerMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates recording of the device's undo and redo operations.
    ///
    public enum Event {
        ///
        /// UndoManager object opens or closes an undo group.
        ///
        case checkpoint(UndoManager)

        ///
        /// UndoManager object closes an undo group, which occurs in the
        /// implementation of the endUndoGrouping() method.
        ///
        case didCloseUndoGroup(UndoManager)

        ///
        /// UndoManager object opens an undo group, which occurs in the
        /// implementation of the beginUndoGrouping() method.
        ///
        case didOpenUndoGroup(UndoManager)

        ///
        /// UndoManager object performs a redo operation.
        ///
        case didRedoChange(UndoManager)

        ///
        /// UndoManager object performs an undo operation.
        ///
        case didUndoChange(UndoManager)

        ///
        /// UndoManager object closes an undo group, which occurs in the
        /// implementation of the endUndoGrouping() method.
        ///
        case willCloseUndoGroup(UndoManager)

        ///
        /// UndoManager object performs a redo operation.
        ///
        case willRedoChange(UndoManager)

        ///
        /// UndoManager object performs an undo operation.
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
    ///   - undoManger: The undo manager to monitor.
    ///   - options:    The options that specify which events to monitor.
    ///                 By default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when an Undo or Redo operation
    ///                 is called.
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
    /// The undo manager is being monitored.
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
