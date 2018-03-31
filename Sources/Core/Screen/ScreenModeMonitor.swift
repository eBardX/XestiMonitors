//
//  ScreenModeMonitor.swift
//  XestiMonitors-iOS
//
//  Created by Paul Nyondo on 2018-03-31.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    ///
    /// A `ScreenModeMonitor` instance monitors a screen for changes to
    /// its mode.
    ///
    public class ScreenModeMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates changes to the screen mode.
        ///
        public enum Event {
            ///
            /// The screen mode has changed.
            ///
            case didChange(UIScreen)
        }
        ///
        /// Initializes a new `ScreenModeMonitor`.
        ///
        /// - Parameters:
        ///   - screen:     The screen to monitor.
        ///   - queue:      The operation queue on which the handler executes.
        ///                 By default, the main operation queue is used.
        ///   - handler:    The handler to call when the screen mode changes.
        ///                 
        ///
        public init(screen: UIScreen,
                    queue: OperationQueue = .main,
                    handler: @escaping (Event) -> Void) {
            
            self.screen = screen
            self.handler = handler
            
            super.init(queue: queue)
        }
        
        ///
        /// The screen being monitored.
        ///
        public let screen: UIScreen
        
        private let handler: (Event) -> Void
        
        public override func addNotificationObservers() {
            super.addNotificationObservers()
            
            observe(.UIScreenModeDidChange, object: screen) { [unowned self] in
                if let screen = $0.object as? UIScreen {
                    self.handler(.didChange(screen))
                }
            }
        }
    }
#endif
