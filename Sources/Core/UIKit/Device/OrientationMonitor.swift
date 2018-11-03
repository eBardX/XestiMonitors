//
//  OrientationMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)

import Foundation
import UIKit

///
/// An `OrientationMonitor` instance monitors the device for changes to its
/// physical orientation.
///
public class OrientationMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the physical orientation of the device.
    ///
    public enum Event {
        ///
        /// The physical orientation of the device has changed.
        ///
        case didChange(UIDeviceOrientation)
    }

    ///
    /// Initializes a new `OrientationMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the physical orientation
    ///                 of the device changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.device = DeviceInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    ///
    /// The physical orientation of the device.
    ///
    public var orientation: UIDeviceOrientation {
        return device.orientation
    }

    private let device: DeviceProtocol
    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIDevice.orientationDidChangeNotification,
                object: device) { [unowned self] _ in
                    self.handler(.didChange(self.device.orientation))
        }

        device.beginGeneratingDeviceOrientationNotifications()
    }

    override public func removeNotificationObservers() {
        device.endGeneratingDeviceOrientationNotifications()

        super.removeNotificationObservers()
    }
}

#endif
