//
//  PasteboardMonitor.swift
//  XestiMonitors-iOS
//
//  Created by Paul nyondo on 15/03/2018.
//  Copyright © 2018 Xesticode. All rights reserved.
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
            case didChange(UIPasteboard)
            ///
            ///  Contents of the pasteboard object have been removed.
            ///
            case didRemove(UIPasteboard)
            
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
        
        public init(pasteboard: UIPasteboard,
                    queue: OperationQueue = .main,
                    handler: @escaping(Event) -> Void) {
            self.pasteboard = pasteboard
            self.handler = handler
            
            super.init(queue: queue)
        }
        
        ///
        /// The pasteboard being monitored.
        ///
        public let pasteboard: UIPasteboard
        
        private let handler: (Event) -> Void
        
        override public func addNotificationObservers() {
            super.addNotificationObservers()
            
            observe(.UIPasteboardChanged, object: pasteboard) { [unowned self] in
                if let pasteboard = $0.object as? UIPasteboard {
                    self.handler(.didChange(pasteboard))
                }
            }
            
            observe(.UIPasteboardRemoved, object: pasteboard) { [unowned self] in
                if let pasteboard = $0.object as? UIPasteboard {
                    self.handler(.didRemove(pasteboard))
                }
            }
        }
    }
    
#endif
