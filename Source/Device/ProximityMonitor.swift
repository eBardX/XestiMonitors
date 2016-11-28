//
//  ProximityMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// A `ProximityMonitor` object monitors the device for changes to the state of
/// its proximity sensor.
///
public class ProximityMonitor: BaseNotificationMonitor {

    // MARK: Public Type Properties

    ///
    /// A Boolean value indicating whether proximity monitoring is available on
    /// the device (`true`) or not (`false`).
    ///
    public static var isAvailable: Bool = {

        let device = UIDevice.current
        let oldValue = device.isProximityMonitoringEnabled

        defer { device.isProximityMonitoringEnabled = oldValue; }

        device.isProximityMonitoringEnabled = true

        return device.isProximityMonitoringEnabled

    }()

    // MARK: Public Initializers

    ///
    /// Initializes a new `ProximityMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the state of the proximity
    ///                 sensor changes.
    ///
    public init(handler: @escaping (Bool) -> Void) {

        self.device = UIDevice.current
        self.handler = handler

    }

    // MARK: Public Instance Properties

    ///
    /// A Boolean value indicating whether the proximity sensor is close to the
    /// user (`true`) or not (`false`).
    ///
    public var state: Bool { return device.proximityState }

    // MARK: Private

    private let device: UIDevice
    private let handler: (Bool) -> Void

    @objc private func deviceProximityStateDidChange(_ notification: NSNotification) {

        handler(device.proximityState)

    }

    // MARK: Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ center: NotificationCenter) -> Bool {

        center.addObserver(self,
                       selector: #selector(deviceProximityStateDidChange(_:)),
                       name: .UIDeviceProximityStateDidChange,
                       object: nil)

        device.isProximityMonitoringEnabled = true

        return true
    }

    public override func removeNotificationObservers(_ center: NotificationCenter) -> Bool {

        device.isProximityMonitoringEnabled = false

        return super.removeNotificationObservers(center)

    }

}
