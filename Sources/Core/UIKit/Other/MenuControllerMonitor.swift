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
/// A `MenuControllerMonitor` instance monitors the menu controller for changes
/// to the visibility of the editing menu or to the frame of the editing menu.
///
public class MenuControllerMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the visibility of the editing menu and to the
    /// frame of the editing menu.
    ///
    public enum Event {
        ///
        /// The editing menu has been dismissed.
        ///
        case didHideMenu(UIMenuController)

        ///
        /// The editing menu has been displayed.
        ///
        case didShowMenu(UIMenuController)

        ///
        /// The frame of the editing menu has changed.
        ///
        case menuFrameDidChange(UIMenuController)

        ///
        /// The editing menu is about to be dismissed.
        ///
        case willHideMenu(UIMenuController)

        ///
        /// The editing menu is about to be displayed.
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
    ///   - handler:    The handler to call when the visibility of the editing
    ///                 menu or the frame of the editing menu changes or is
    ///                 about to change.
    ///
    public init(options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.menuController = .shared
        self.options = options

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void
    private let menuController: UIMenuController
    private let options: Options

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didHideMenu) {
            observe(UIMenuController.didHideMenuNotification,
                    object: menuController) { [unowned self] in
                if let menuController = $0.object as? UIMenuController {
                    self.handler(.didHideMenu(menuController))
                }
            }
        }

        if options.contains(.didShowMenu) {
            observe(UIMenuController.didShowMenuNotification,
                    object: menuController) { [unowned self] in
                if let menuController = $0.object as? UIMenuController {
                    self.handler(.didShowMenu(menuController))
                }
            }
        }

        if options.contains(.menuFrameDidChange) {
            observe(UIMenuController.menuFrameDidChangeNotification,
                    object: menuController) { [unowned self] in
                if let menuController = $0.object as? UIMenuController {
                    self.handler(.menuFrameDidChange(menuController))
                }
            }
        }

        if options.contains(.willHideMenu) {
            observe(UIMenuController.willHideMenuNotification,
                    object: menuController) { [unowned self] in
                if let menuController = $0.object as? UIMenuController {
                    self.handler(.willHideMenu(menuController))
                }
            }
        }

        if options.contains(.willShowMenu) {
            observe(UIMenuController.willShowMenuNotification,
                    object: menuController) { [unowned self] in
                if let menuController = $0.object as? UIMenuController {
                    self.handler(.willShowMenu(menuController))
                }
            }
        }
    }
}

#endif
