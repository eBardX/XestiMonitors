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
    }

#endif
