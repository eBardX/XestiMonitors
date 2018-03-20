//
//  WindowMonitor.swift
//  XestiMonitors-iOS
//
//  Created by Martin Mungai on 20/03/2018.
//
//  © 2016 J. G. Pusey (see LICENSE.md)

#if os(iOS)
    import Foundation
    import UIKit

    ///
    /// A `WindowMonitor` instance monitors the window for changes to its
    /// visibility or to its frame.
    ///
    
    public class WindowMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates changes to the visibility of the window and to the frame
        /// of the window.
        ///
        public enum Event {
            
            case didBecomeVisible(UIWindow)
            case didBecomeHidden(UIWindow)
            case didBecomeKey(UIWindow)
            case didResignKey(UIWindow)
        }
        
        public struct Options: OptionSet {
            
            ///
            /// Monitor `didBecomeVisible` events
            ///
            public static let didBecomeVisible = Options(rawValue: 1 << 0)
            
            
            ///
            /// Monitor `didBecomeHidden` events
            ///
            public static let didBecomeHidden = Options(rawValue: 1 << 1)
            
            ///
            /// Monitor `didBecomeKey` events
            ///
            public static let didBecomeKey = Options(rawValue: 1 << 2)
            
            ///
            /// Monitor `didResignKey` events
            ///
            public static let didResignKey = Options(rawValue: 1 << 3)
            
            ///
            /// Monitor all events
            ///
            public static let all: Options = [.didBecomeVisible,
                                              .didBecomeHidden,
                                              .didBecomeKey,
                                              .didResignKey]
            
            public init(rawValue: UInt) {
                self.rawValue = rawValue
            }
            
            public let rawValue: UInt
        }
        
        ///
        /// Initializes a new `WindowMonitor`.
        ///
        /// - Parameters:
        ///   - queue:      The operation queue on which the handler executes. By
        ///                 default, the main operation queue is used.
        ///   - options:    The options that specify which events to monitor. By
        ///                 default, all events are monitored.
        ///   - handler:    The handler to call when the visibility of the keyboard
        ///                 or the frame of the keyboard changes or is about to
        ///                 change.
        ///
        
        public init(queue: OperationQueue = .main,
                    window: UIWindow,
                    options: Options = .all,
                    handler: @escaping (Event) -> Void) {
            self.handler = handler
            self.options = options
            self.window = window
            
            super.init(queue: queue)
        }
        
        public let handler: (Event) -> Void
        public let options: Options
        public let window: UIWindow
        
        public override func addNotificationObservers() {
            super.addNotificationObservers()
            
            if options.contains(.didBecomeHidden) {
                observe(.UIWindowDidBecomeHidden, object: window) { _ in
                    self.handler(.didBecomeHidden(self.window))
                }
            }
            
            if options.contains(.didBecomeKey) {
                observe(.UIWindowDidBecomeKey, object: window) { _ in
                    self.handler(.didBecomeKey(self.window))
                }
            }
            
            if options.contains(.didBecomeVisible) {
                observe(.UIWindowDidBecomeVisible, object: window) { _ in
                    self.handler(.didBecomeVisible(self.window))
                }
            }
            
            if options.contains(.didResignKey) {
                observe(.UIWindowDidResignKey, object: window) { _ in
                    self.handler(.didResignKey(self.window))
                }
            }
            
           
        }
    }

#endif
