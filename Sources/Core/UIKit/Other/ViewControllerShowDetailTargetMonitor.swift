//
//  ViewControllerShowDetailTargetMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-04-14.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import UIKit

///
/// A `ViewControllerShowDetailTargetMonitor` instance monitors the app for
/// changes to a split view controller’s display mode in the view hierarchy.
///
public class ViewControllerShowDetailTargetMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to a split view controller’s display mode in the
    /// view hierarchy.
    ///
    public enum Event {
        ///
        /// A split view controller has been expanded or collapsed. The
        /// associated value is the view controller that caused the change.
        ///
        case didChange(UIViewController)
    }

    ///
    /// Initializes a new `ViewControllerShowDetailTargetMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when a split view controller is
    ///                 expanded or collapsed.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIViewController.showDetailTargetDidChangeNotification) { [unowned self] in
            if let vc = $0.object as? UIViewController {
                self.handler(.didChange(vc))
            }
        }
    }
}

#endif
