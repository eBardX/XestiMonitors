//
//  SignificantLocationMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(macOS)

import CoreLocation

///
/// A `SignificantLocationMonitor` instance monitors the device for
/// *significant* changes to its current location.
///
/// - Note:
///   An authorization status of `authorizedAlways` is required.
///
public class SignificantLocationMonitor: BaseMonitor {
    ///
    /// Encapsulates changes to the device’s current location.
    ///
    public enum Event {
        ///
        /// The current location has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates information associated with a significant location monitor
    /// event.
    ///
    public enum Info {
        ///
        /// The error encountered in attempting to obtain the current location.
        ///
        case error(Error)

        ///
        /// The latest location data.
        ///
        case location(CLLocation)
    }

    ///
    /// Initializes a new `SignificantLocationMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when the current location of the
    ///                 device changes significantly.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue

        super.init()

        self.adapter.didFail = { [unowned self] in
            self.handler(.didUpdate(.error($0)))
        }

        self.adapter.didUpdateLocations = { [unowned self] in
            if let location = $0.first {
                self.handler(.didUpdate(.location(location)))
            }
        }

        self.locationManager.delegate = self.adapter
    }

    ///
    /// A Boolean value indicating whether the significant-change location
    /// service is available.
    ///
    public var isAvailable: Bool {
        return type(of: locationManager).significantLocationChangeMonitoringAvailable()
    }

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: LocationManagerProtocol
    private let queue: OperationQueue

    override public func cleanupMonitor() {
        locationManager.stopMonitoringSignificantLocationChanges()

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        locationManager.startMonitoringSignificantLocationChanges()
    }
}

#endif
