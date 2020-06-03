//
//  StandardLocationMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation

///
/// A `StandardLocationMonitor` instance monitors the device for changes to its
/// current location.
///
@available(watchOS 3.0, *)
public class StandardLocationMonitor: BaseMonitor {
    ///
    /// Encapsulates changes to the device’s current location.
    ///
    public enum Event {
        ///
        /// Location updates will no longer be deferred. The associated value,
        /// if non-`nil`, contains the reason deferred location updates could
        /// not be delivered.
        ///
        case didFinishDeferredUpdates(Error?)

        ///
        /// Location updates have been paused.
        ///
        case didPauseUpdates

        ///
        /// Location updates have been resumed.
        ///
        case didResumeUpdates

        ///
        /// The current location has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates information associated with a standard location monitor
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
    /// Initializes a new `StandardLocationMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when the current location of the
    ///                 device changes.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue

        super.init()

        self.adapter.didFail = handleDidFail

        #if os(iOS) || os(macOS)
        self.adapter.didFinishDeferredUpdates = handleDidFinishDeferredUpdates
        #endif

        #if os(iOS)
        self.adapter.didPauseLocationUpdates = handleDidPauseLocationUpdates
        #endif

        #if os(iOS)
        self.adapter.didResumeLocationUpdates = handleDidResumeLocationUpdates
        #endif

        self.adapter.didUpdateLocations = handleDidUpdateLocations

        self.locationManager.delegate = self.adapter
    }

    #if os(iOS) || os(watchOS)
    ///
    /// The type of user activity associated with the location updates.
    ///
    @available(watchOS 4.0, *)
    public var activityType: CLActivityType {
        get { return locationManager.activityType }
        set { locationManager.activityType = newValue }
    }
    #endif

    #if os(iOS) || os(watchOS)
    ///
    /// A Boolean value indicating whether the app should receive location
    /// updates when suspended.
    ///
    @available(watchOS 4.0, *)
    public var allowsBackgroundLocationUpdates: Bool {
        get { return locationManager.allowsBackgroundLocationUpdates }
        set { locationManager.allowsBackgroundLocationUpdates = newValue }
    }
    #endif

    #if os(iOS) || os(macOS)
    ///
    /// A Boolean value indicating whether the device supports deferred
    /// location updates.
    ///
    public var canDeferUpdates: Bool {
        return type(of: locationManager).deferredLocationUpdatesAvailable()
    }
    #endif

    ///
    /// The accuracy of the location data.
    ///
    public var desiredAccuracy: CLLocationAccuracy {
        get { return locationManager.desiredAccuracy }
        set { locationManager.desiredAccuracy = newValue }
    }

    ///
    /// The minimum distance (measured in meters) the device must move
    /// horizontally before a location update is generated.
    ///
    public var distanceFilter: CLLocationDistance {
        get { return locationManager.distanceFilter }
        set { locationManager.distanceFilter = newValue }
    }

    ///
    /// The most recently reported location.
    ///
    /// The value of this property is nil if location updates have never been
    /// initiated.
    ///
    public var location: CLLocation? {
        return locationManager.location
    }

    #if os(iOS)
    ///
    /// A Boolean value indicating whether location updates may be paused
    /// automatically.
    ///
    public var pausesLocationUpdatesAutomatically: Bool {
        get { return locationManager.pausesLocationUpdatesAutomatically }
        set { locationManager.pausesLocationUpdatesAutomatically = newValue }
    }
    #endif

    #if os(iOS)
    ///
    /// A Boolean indicating whether the status bar changes its appearance when
    /// location services are used in the background.
    ///
    @available(iOS 11.0, *)
    public var showsBackgroundLocationIndicator: Bool {
        get { return locationManager.showsBackgroundLocationIndicator }
        set { locationManager.showsBackgroundLocationIndicator = newValue }
    }
    #endif

    #if os(iOS)
    ///
    /// Defers the delivery of location updates until the specified criteria
    /// are met.
    ///
    /// - Parameters:
    ///   - distance:   The distance (in meters) from the current location that
    ///                 must be traveled before location update delivery
    ///                 resumes.
    ///   - timeout:    The amount of time (in seconds) from the current time
    ///                 that must pass before location update delivery resumes.
    ///
    public func allowDeferredUpdates(untilTraveled distance: CLLocationDistance,
                                     timeout: TimeInterval) {
        locationManager.allowDeferredLocationUpdates(untilTraveled: distance,
                                                     timeout: timeout)
    }
    #endif

    #if os(iOS)
    ///
    /// Cancels the deferral of location updates.
    ///
    public func disallowDeferredUpdates() {
        locationManager.disallowDeferredLocationUpdates()
    }
    #endif

    #if os(iOS) || os(tvOS) || os(watchOS)
    ///
    /// Requests the one-time delivery of the device’s current location.
    ///
    public func requestLocation() {
        locationManager.requestLocation()
    }
    #endif

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: LocationManagerProtocol
    private let queue: OperationQueue

    private func handleDidFail(_ error: Error) {
        handler(.didUpdate(.error(error)))
    }

    #if os(iOS) || os(macOS)
    private func handleDidFinishDeferredUpdates(_ error: Error?) {
        handler(.didFinishDeferredUpdates(error))
    }
    #endif

    #if os(iOS)
    private func handleDidPauseLocationUpdates() {
        handler(.didPauseUpdates)
    }
    #endif

    #if os(iOS)
    private func handleDidResumeLocationUpdates() {
        handler(.didResumeUpdates)
    }
    #endif

    private func handleDidUpdateLocations(_ locations: [CLLocation]) {
        if let location = locations.first {
            handler(.didUpdate(.location(location)))
        }
    }

    override public func cleanupMonitor() {
        locationManager.stopUpdatingLocation()

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        #if os(iOS) || os(macOS) || os(watchOS)
        locationManager.startUpdatingLocation()
        #endif
    }
}
