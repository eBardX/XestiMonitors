//
//  LocationAuthorizationMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-27.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation

///
/// A `LocationAuthorizationMonitor` instance monitors the app for updates to
/// its authorization to use location services.
///
public class LocationAuthorizationMonitor: BaseMonitor {
    ///
    /// Encapsulates updates to location services authorization.
    ///
    public enum Event {
        ///
        /// Location services authorization has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates information associated with a location authorization
    /// monitor event.
    ///
    public enum Info {
        ///
        /// The error encountered in attempting to request or update location
        /// services authorization.
        ///
        case error(Error)

        ///
        /// The updated location services authorization status.
        ///
        case status(CLAuthorizationStatus)
    }

    ///
    /// Initializes a new `LocationAuthorizationMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when location services
    ///                 authorization is requested or updated.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue

        super.init()

        self.adapter.didChangeAuthorization = handleDidChangeAuthorization
        self.adapter.didFail = handleDidFail

        self.locationManager.delegate = self.adapter
    }

    ///
    /// A Boolean value indicating whether location services are enabled on the
    /// device.
    ///
    public var isEnabled: Bool {
        return type(of: locationManager).locationServicesEnabled()
    }

    ///
    /// A value indicating whether the app is authorized to use location
    /// services.
    ///
    public var status: CLAuthorizationStatus {
        return type(of: locationManager).authorizationStatus()
    }

    #if os(iOS) || os(watchOS)
    ///
    /// Requests permission to use location services whenever the app is
    /// running.
    ///
    public func requestAlways() {
        locationManager.requestAlwaysAuthorization()
    }
    #endif

    #if os(iOS) || os(tvOS) || os(watchOS)
    ///
    /// Requests permission to use location services while the app is in the
    /// foreground.
    ///
    public func requestWhenInUse() {
        locationManager.requestWhenInUseAuthorization()
    }
    #endif

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: LocationManagerProtocol
    private let queue: OperationQueue

    private func handleDidChangeAuthorization(_ status: CLAuthorizationStatus) {
        handler(.didUpdate(.status(status)))
    }

    private func handleDidFail(_ error: Error) {
        handler(.didUpdate(.error(error)))
    }
}
