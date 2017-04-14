//
//  OrientationMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// An `OrientationMonitor` object monitors the device for changes to its
/// physical orientation.
///
public class OrientationMonitor: BaseNotificationMonitor {

    // Public Nested Types

    ///
    /// Encapsulates changes to the physical orientation of the device.
    ///
    public enum Event {
        ///
        /// The physical orientation of the device has changed.
        ///
        case didChange(UIDeviceOrientation)
    }

    // Public Initializers

    ///
    /// Initializes a new `OrientationMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which notification blocks
    ///                 execute. By default, the main operation queue is used.
    ///   - handler:    The handler to call when the physical orientation of
    ///                 the device changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.device = .current
        self.handler = handler

        super.init(queue: queue)

    }

    // Public Instance Properties

    ///
    /// The physical orientation of the device.
    ///
    public var orientation: UIDeviceOrientation { return device.orientation }

    // Private Instance Properties

    private let device: UIDevice
    private let handler: (Event) -> Void

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard super.addNotificationObservers()
            else { return false }

        observe(.UIDeviceOrientationDidChange) { [unowned self] _ in
            self.handler(.didChange(self.device.orientation))
        }

        device.beginGeneratingDeviceOrientationNotifications()

        return true

    }

    public override func removeNotificationObservers() -> Bool {

        device.endGeneratingDeviceOrientationNotifications()

        return super.removeNotificationObservers()

    }

}
