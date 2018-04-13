//
//  MenuControllerMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-04-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)
import UIKit

///
/// A `MenuControllerMonitor` instance monitors the UIMenuController for changes to the
/// visibility of its menu or its menu frame
///
public class MenuControllerMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the visibility of the menu and to the
    /// frame of the menu.
    ///
    public enum Event {
        ///
        /// The menu controller has hidden its menu.
        ///
        case didHideMenu(UIMenuController)

        ///
        /// The menu controller has shown its menu.
        ///
        case didShowMenu(UIMenuController)

        ///
        /// The frame of the visible menu has changed.
        ///
        case menuFrameDidChange(UIMenuController)

        ///
        /// The menu controller will hide its menu.
        ///
        case willHideMenu(UIMenuController)

        ///
        /// The menu controller will show its menu.
        ///
        case willShowMenu(UIMenuController)
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didHideMenu` events.
        ///
        public static let didHideMenu = Options(rawValue: 1 << 0)

        ///
        /// Monitor `didShowMenu` events.
        ///
        public static let didShowMenu = Options(rawValue: 1 << 1)

        ///
        /// Monitor `menuFrameDidChange` events.
        ///
        public static let menuFrameDidChange = Options(rawValue: 1 << 2)

        ///
        /// Monitor `willHideMenu` events.
        ///
        public static let willHideMenu = Options(rawValue: 1 << 3)

        ///
        /// Monitor `willShowMenu` events.
        ///
        public static let willShowMenu = Options(rawValue: 1 << 4)

        ///
        /// Monitor `all` events.
        ///
        public static let all: Options = [.didHideMenu,
                                          .didShowMenu,
                                          .menuFrameDidChange,
                                          .willHideMenu,
                                          .willShowMenu]
        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `MenuControllerMonitor`.
    ///
    /// - Parameters:
    ///   - options:    The options that specify which events to monitor.
    ///                 By default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the visibility of the MenuController
    ///                 or the frame of the MenuController changes
    ///
    ///
    public init(options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void
    private let options: Options

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didHideMenu) {
            observe(.UIMenuControllerDidHideMenu) { [unowned self] in
                if let menu = $0.object as? UIMenuController {
                    self.handler(.didHideMenu(menu))
                }
            }
        }

        if options.contains(.didShowMenu) {
            observe(.UIMenuControllerDidShowMenu) { [unowned self] in
                if let menu = $0.object as? UIMenuController {
                    self.handler(.didShowMenu(menu))
                }
            }
        }

        if options.contains(.menuFrameDidChange) {
            observe(.UIMenuControllerMenuFrameDidChange) { [unowned self] in
                if let menu = $0.object as? UIMenuController {
                    self.handler(.menuFrameDidChange(menu))
                }
            }
        }

        if options.contains(.willHideMenu) {
            observe(.UIMenuControllerWillHideMenu) { [unowned self] in
                if let menu = $0.object as? UIMenuController {
                    self.handler(.willHideMenu(menu))
                }
            }
        }

        if options.contains(.willShowMenu) {
            observe(.UIMenuControllerWillShowMenu) { [unowned self] in
                if let menu = $0.object as? UIMenuController {
                    self.handler(.willShowMenu(menu))
                }
            }
        }
    }
}

#endif
