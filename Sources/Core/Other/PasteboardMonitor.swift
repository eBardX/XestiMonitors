//
//  PasteboardMonitor.swift
//  XestiMonitors
//
//  Created by Paul nyondo on 2018-03-15.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)
    import  UIKit
    ///
    /// A `PasteboardMonitor` instance monitors a pasteboard for changes to
    /// its state.
    ///
    public class PasteboardMonitor: BaseNotificationMonitor {
        
        ///
        /// Encapsulates changes to the contents of the pasteboard.
        ///
        
        public enum Event {
            ///
            ///  Contents of the pasteboard object have changed.
            ///
            case didChange(Info)
            ///
            ///  Contents of the pasteboard object have been removed.
            ///
            case didRemove(Info)
            
        }
        
        public struct Info {
            ///
            ///  The added representation types stored as an array
            ///  in the notification’s userInfo dictionary
            ///
            public let typesAdded: String
            ///
            ///  The removed representation types stored as an array
            ///  in the notification’s userInfo dictionary
            ///
            public let typesRemoved: String
            
            fileprivate init(_ notification: Notification) {
                let userInfo = notification.userInfo
                
                if let rawValue = (userInfo?[UIPasteboardChangedTypesAddedKey]) as? String {
                    self.typesAdded = rawValue
                } else {
                    self.typesAdded = ""
                }
                
                if let rawValue = (userInfo?[UIPasteboardChangedTypesRemovedKey]) as? String {
                    self.typesRemoved = rawValue
                } else {
                    self.typesRemoved = ""
                }
            }
            
        }
        
        public struct Options: OptionSet {
            ///
            /// Monitor `PasteboardChanged` events.
            ///
            public static let didChange = Options(rawValue: 1 << 0)
            
            ///
            /// Monitor `PasteboardRemoved` events.
            ///
            public static let didRemove = Options(rawValue: 1 << 1)
            
            ///
            /// Monitor all events.
            ///
            
            public static let all: Options = [.didChange,
                                              .didRemove]
            
            /// :nodoc:
            public init(rawValue: UInt) {
                self.rawValue = rawValue
            }
            
            /// :nodoc:
            public let rawValue: UInt
            
        }
        
        ///
        /// Initializes a new `PasteboardMonitor`.
        ///
        /// - Parameters:
        ///   - pasteboard:   The pasteboard to monitor.
        ///   - queue:      The operation queue on which the handler executes. By
        ///                 default, the main operation queue is used.
        ///   - handler:    The handler to call when the state of the document
        ///                 changes.
        ///
        
        public init(options: Options = .all,
                    queue: OperationQueue = .main,
                    handler: @escaping(Event) -> Void) {
            self.options = options
            self.handler = handler
            
            super.init(queue: queue)
        }
        
        ///
        /// The pasteboard being monitored.
        ///
        private let options: Options
        
        private let handler: (Event) -> Void
        
        override public func addNotificationObservers() {
            super.addNotificationObservers()
            
            if options.contains(.didChange) {
                observe(.UIPasteboardChanged) { [unowned self] in
                    self.handler(.didChange(Info($0)))
                }
            }
            
            if options.contains(.didRemove) {
                observe(.UIPasteboardRemoved) { [unowned self] in
                    self.handler(.didRemove(Info($0)))
                }
            }
            
            
        }
    }
    
#endif
