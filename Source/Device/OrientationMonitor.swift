//
//  OrientationMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// An `OrientationMonitor` object monitors the device for changes to its
/// orientation.
///
public class OrientationMonitor: BaseNotificationMonitor {

    // MARK: Public

    ///
    /// Initializes a new `OrientationMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the orientation of the device
    ///                 changes.
    ///
    public init(handler: @escaping (UIDeviceOrientation) -> Void) {

        self.device = UIDevice.current
        self.handler = handler

    }

    // MARK: Public Instance Properties

    ///
    /// The physical orientation of the device.
    ///
    public var orientation: UIDeviceOrientation { return device.orientation }

    // MARK: Private

    private let device: UIDevice
    private let handler: (UIDeviceOrientation) -> Void

    @objc private func deviceOrientationDidChange(_ notification: NSNotification) {

        handler(device.orientation)

    }

    // MARK: Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        notificationCenter.addObserver(self,
                                       selector: #selector(deviceOrientationDidChange(_:)),
                                       name: .UIDeviceOrientationDidChange,
                                       object: nil)

        device.beginGeneratingDeviceOrientationNotifications()

        return true

    }

    public override func removeNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        device.endGeneratingDeviceOrientationNotifications()

        return super.removeNotificationObservers(notificationCenter)

    }

}
