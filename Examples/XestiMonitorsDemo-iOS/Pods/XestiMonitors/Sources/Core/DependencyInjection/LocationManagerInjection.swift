//
//  LocationManagerInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-22.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation

internal protocol LocationManagerProtocol: class {
    #if os(iOS) || os(watchOS)
    @available(watchOS 4.0, *)
    var activityType: CLActivityType { get set }
    #endif

    #if os(iOS) || os(watchOS)
    @available(watchOS 4.0, *)
    var allowsBackgroundLocationUpdates: Bool { get set }
    #endif

    var delegate: CLLocationManagerDelegate? { get set }

    var desiredAccuracy: CLLocationAccuracy { get set }

    var distanceFilter: CLLocationDistance { get set }

    #if os(iOS)
    var heading: CLHeading? { get }
    #endif

    #if os(iOS)
    var headingFilter: CLLocationDegrees { get set }
    #endif

    #if os(iOS)
    var headingOrientation: CLDeviceOrientation { get set }
    #endif

    var location: CLLocation? { get }

    #if os(iOS) || os(macOS)
    var maximumRegionMonitoringDistance: CLLocationDistance { get }
    #endif

    #if os(iOS) || os(macOS)
    var monitoredRegions: Set<CLRegion> { get }
    #endif

    #if os(iOS)
    var pausesLocationUpdatesAutomatically: Bool { get set }
    #endif

    #if os(iOS)
    var rangedRegions: Set<CLRegion> { get }
    #endif

    #if os(iOS)
    @available(iOS 11.0, *)
    var showsBackgroundLocationIndicator: Bool { get set }
    #endif

    static func authorizationStatus() -> CLAuthorizationStatus

    #if os(iOS) || os(macOS)
    static func deferredLocationUpdatesAvailable() -> Bool
    #endif

    #if os(iOS)
    static func headingAvailable() -> Bool
    #endif

    #if os(iOS) || os(macOS)
    static func isMonitoringAvailable(for regionClass: AnyClass) -> Bool
    #endif

    #if os(iOS)
    static func isRangingAvailable() -> Bool
    #endif

    static func locationServicesEnabled() -> Bool

    #if os(iOS) || os(macOS)
    static func significantLocationChangeMonitoringAvailable() -> Bool
    #endif

    #if os(iOS)
    func allowDeferredLocationUpdates(untilTraveled distance: CLLocationDistance,
                                      timeout: TimeInterval)
    #endif

    #if os(iOS)
    func disallowDeferredLocationUpdates()
    #endif

    #if os(iOS)
    func dismissHeadingCalibrationDisplay()
    #endif

    #if os(iOS) || os(watchOS)
    func requestAlwaysAuthorization()
    #endif

    #if os(iOS) || os(tvOS) || os(watchOS)
    func requestLocation()
    #endif

    #if os(iOS) || os(macOS)
    func requestState(for region: CLRegion)
    #endif

    #if os(iOS) || os(tvOS) || os(watchOS)
    func requestWhenInUseAuthorization()
    #endif

    #if os(iOS) || os(macOS)
    func startMonitoring(for region: CLRegion)
    #endif

    #if os(iOS) || os(macOS)
    func startMonitoringSignificantLocationChanges()
    #endif

    #if os(iOS)
    func startMonitoringVisits()
    #endif

    #if os(iOS)
    func startRangingBeacons(in region: CLBeaconRegion)
    #endif

    #if os(iOS)
    func startUpdatingHeading()
    #endif

    #if os(iOS) || os(macOS) || os(watchOS)
    @available(watchOS 3.0, *)
    func startUpdatingLocation()
    #endif

    #if os(iOS) || os(macOS)
    func stopMonitoring(for region: CLRegion)
    #endif

    #if os(iOS) || os(macOS)
    func stopMonitoringSignificantLocationChanges()
    #endif

    #if os(iOS)
    func stopMonitoringVisits()
    #endif

    #if os(iOS)
    func stopRangingBeacons(in region: CLBeaconRegion)
    #endif

    #if os(iOS)
    func stopUpdatingHeading()
    #endif

    func stopUpdatingLocation()
}

extension CLLocationManager: LocationManagerProtocol {}

internal struct LocationManagerInjector {
    internal static var inject: () -> LocationManagerProtocol = { return CLLocationManager() }
}
