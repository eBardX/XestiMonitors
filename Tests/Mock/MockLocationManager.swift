//
//  MockLocationManager.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-22.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
@testable import XestiMonitors

// swiftlint:disable file_length type_body_length

internal class MockLocationManager: LocationManagerProtocol {
    static func deferredLocationUpdatesAvailable() -> Bool {
        return mockDeferredLocationUpdatesAvailable
    }

    #if os(iOS)
    static func headingAvailable() -> Bool {
        return mockHeadingAvailable
    }
    #endif

    static func authorizationStatus() -> CLAuthorizationStatus {
        return mockAuthorizationStatus
    }

    #if os(iOS) || os(macOS)
    static func isMonitoringAvailable(for regionClass: AnyClass) -> Bool {
        if regionClass is CLRegion.Type {
            return mockRegionAvailable
        } else {
            return false
        }
    }
    #endif

    #if os(iOS)
    static func isRangingAvailable() -> Bool {
        return mockBeaconRangingAvailable
    }
    #endif

    static func locationServicesEnabled() -> Bool {
        return mockLocationServicesEnabled
    }

    #if os(iOS) || os(macOS)
    static func significantLocationChangeMonitoringAvailable() -> Bool {
        return mockSignificantLocationAvailable
    }
    #endif

    init() {
        #if os(iOS) || os(watchOS)
            self.activityType = .other
        #endif
        #if os(iOS) || os(watchOS)
            self.allowsBackgroundLocationUpdates = false
        #endif
        self.desiredAccuracy = kCLLocationAccuracyBest
        self.distanceFilter = kCLDistanceFilterNone
        #if os(iOS)
            self.heading = nil
        #endif
        #if os(iOS)
            self.headingFilter = 1
        #endif
        #if os(iOS)
            self.headingOrientation = .portrait
        #endif
        self.location = nil
        #if os(iOS) || os(macOS)
            self.maximumRegionMonitoringDistance = 1_000
        #endif
        self.mockAlwaysAuthorizationRequested = false
        self.mockLocationUpdatesDeferred = false
        self.mockHeadingCalibrationDisplayVisible = false
        self.mockHeadingRunning = false
        self.mockLocationRequested = false
        self.mockRegionStateRequested = nil
        self.mockSignificantLocationRunning = false
        self.mockStandardLocationRunning = false
        self.mockVisitRunning = false
        self.mockWhenInUseAuthorizationRequested = false
        #if os(iOS) || os(macOS)
            self.monitoredRegions = []
        #endif
        #if os(iOS)
            self.pausesLocationUpdatesAutomatically = false
        #endif
        #if os(iOS)
            self.rangedRegions = []
        #endif
        #if os(iOS)
            self.showsBackgroundLocationIndicator = false
        #endif
    }

    #if os(iOS) || os(watchOS)
    @available(watchOS 4.0, *)
    var activityType: CLActivityType
    #endif

    #if os(iOS) || os(watchOS)
    @available(watchOS 4.0, *)
    var allowsBackgroundLocationUpdates: Bool
    #endif

    weak var delegate: CLLocationManagerDelegate?

    var desiredAccuracy: CLLocationAccuracy

    var distanceFilter: CLLocationDistance

    #if os(iOS)
    var heading: CLHeading?
    #endif

    #if os(iOS)
    var headingFilter: CLLocationDegrees
    #endif

    #if os(iOS)
    var headingOrientation: CLDeviceOrientation
    #endif

    var location: CLLocation?

    #if os(iOS) || os(macOS)
    private(set) var maximumRegionMonitoringDistance: CLLocationDistance
    #endif

    #if os(iOS) || os(macOS)
    private(set) var monitoredRegions: Set<CLRegion>
    #endif

    #if os(iOS)
    var pausesLocationUpdatesAutomatically: Bool
    #endif

    #if os(iOS)
    private(set) var rangedRegions: Set<CLRegion>
    #endif

    #if os(iOS)
    var showsBackgroundLocationIndicator: Bool
    #endif

    #if os(iOS)
    func allowDeferredLocationUpdates(untilTraveled distance: CLLocationDistance,
                                      timeout: TimeInterval) {
        mockLocationUpdatesDeferred = true
    }
    #endif

    #if os(iOS)
    func disallowDeferredLocationUpdates() {
        mockLocationUpdatesDeferred = false
    }
    #endif

    #if os(iOS)
    func dismissHeadingCalibrationDisplay() {
        mockHeadingCalibrationDisplayVisible = false
    }
    #endif

    #if os(iOS) || os(watchOS)
    func requestAlwaysAuthorization() {
        mockAlwaysAuthorizationRequested = true
    }
    #endif

    #if os(iOS) || os(tvOS) || os(watchOS)
    func requestLocation() {
        mockLocationRequested = true
    }
    #endif

    #if os(iOS) || os(macOS)
    func requestState(for region: CLRegion) {
        mockRegionStateRequested = region
    }
    #endif

    #if os(iOS) || os(tvOS) || os(watchOS)
    func requestWhenInUseAuthorization() {
        mockWhenInUseAuthorizationRequested = true
    }
    #endif

    #if os(iOS) || os(macOS)
    func startMonitoring(for region: CLRegion) {
        monitoredRegions.insert(region)
    }
    #endif

    #if os(iOS) || os(macOS)
    func startMonitoringSignificantLocationChanges() {
        mockSignificantLocationRunning = true
    }
    #endif

    #if os(iOS)
    func startMonitoringVisits() {
        mockVisitRunning = true
    }
    #endif

    #if os(iOS)
    func startRangingBeacons(in region: CLBeaconRegion) {
        rangedRegions.insert(region)
    }
    #endif

    #if os(iOS)
    func startUpdatingHeading() {
        mockHeadingRunning = true
    }
    #endif

    #if os(iOS) || os(macOS) || os(watchOS)
    @available(watchOS 3.0, *)
    func startUpdatingLocation() {
        mockStandardLocationRunning = true
    }
    #endif

    #if os(iOS) || os(macOS)
    func stopMonitoring(for region: CLRegion) {
        monitoredRegions.remove(region)
    }
    #endif

    #if os(iOS) || os(macOS)
    func stopMonitoringSignificantLocationChanges() {
        mockSignificantLocationRunning = false
    }
    #endif

    #if os(iOS)
    func stopMonitoringVisits() {
        mockVisitRunning = false
    }
    #endif

    #if os(iOS)
    func stopRangingBeacons(in region: CLBeaconRegion) {
        rangedRegions.remove(region)
    }
    #endif

    #if os(iOS)
    func stopUpdatingHeading() {
        mockHeadingRunning = false
    }
    #endif

    func stopUpdatingLocation() {
        mockStandardLocationRunning = false
    }

    private static var mockAuthorizationStatus = CLAuthorizationStatus.notDetermined
    private static var mockDeferredLocationUpdatesAvailable = false
    private static var mockBeaconRangingAvailable = false
    private static var mockHeadingAvailable = false
    private static var mockLocationServicesEnabled = false
    private static var mockRegionAvailable = false
    private static var mockSignificantLocationAvailable = false

    private var mockAlwaysAuthorizationRequested: Bool
    private var mockHeadingCalibrationDisplayVisible: Bool
    private var mockHeadingRunning: Bool
    private var mockLocationRequested: Bool
    private var mockLocationUpdatesDeferred: Bool
    private var mockRegionStateRequested: CLRegion?
    private var mockSignificantLocationRunning: Bool
    private var mockStandardLocationRunning: Bool
    private var mockVisitRunning: Bool
    private var mockWhenInUseAuthorizationRequested: Bool

    private var locationManager: CLLocationManager {
        return unsafeBitCast(self,
                             to: CLLocationManager.self)
    }

    // MARK: -

    #if os(iOS)
    var isHeadingCalibrationDisplayVisible: Bool {
        return mockHeadingCalibrationDisplayVisible
    }
    #endif

    #if os(iOS)
    var isLocationUpdatesDeferred: Bool {
        return mockLocationUpdatesDeferred
    }
    #endif

    #if os(iOS)
    func hideHeadingCalibrationDisplay() {
        mockHeadingCalibrationDisplayVisible = false
    }
    #endif

    #if os(iOS)
    func pauseStandardLocationUpdates() {
        guard
            mockStandardLocationRunning
            else { return }

        delegate?.locationManagerDidPauseLocationUpdates?(locationManager)
    }
    #endif

    #if os(iOS)
    func resumeStandardLocationUpdates() {
        guard
            mockStandardLocationRunning
            else { return }

        delegate?.locationManagerDidResumeLocationUpdates?(locationManager)
    }
    #endif

    #if os(iOS)
    func showHeadingCalibrationDisplay() {
        mockHeadingCalibrationDisplayVisible = delegate?.locationManagerShouldDisplayHeadingCalibration?(locationManager) ?? false
    }
    #endif

    func updateAuthorization(error: Error) {
        guard
            mockAlwaysAuthorizationRequested
                || mockWhenInUseAuthorizationRequested
            else { return }

        mockAlwaysAuthorizationRequested = false
        mockWhenInUseAuthorizationRequested = false

        delegate?.locationManager?(locationManager,
                                   didFailWithError: error)
    }

    func updateAuthorization(forceStatus: CLAuthorizationStatus) {
        type(of: self).mockAuthorizationStatus = forceStatus
    }

    func updateAuthorization(status: CLAuthorizationStatus) {
        guard
            mockAlwaysAuthorizationRequested
                || mockWhenInUseAuthorizationRequested
            else { return }

        mockAlwaysAuthorizationRequested = false
        mockWhenInUseAuthorizationRequested = false

        type(of: self).mockAuthorizationStatus = status

        delegate?.locationManager?(locationManager,
                                   didChangeAuthorization: status)
    }

    #if os(iOS)
    func updateBeaconRanging(available: Bool) {
        type(of: self).mockBeaconRangingAvailable = available
    }
    #endif

    #if os(iOS)
    func updateBeaconRanging(error: Error) {
        guard
            !rangedRegions.isEmpty
            else { return }

        delegate?.locationManager?(locationManager,
                                   didFailWithError: error)
    }
    #endif

    #if os(iOS)
    func updateBeaconRanging(error: Error,
                             for region: CLBeaconRegion) {
        guard
            rangedRegions.contains(region)
            else { return }

        delegate?.locationManager?(locationManager,
                                   rangingBeaconsDidFailFor: region,
                                   withError: error)
    }
    #endif

    #if os(iOS)
    func updateBeaconRanging(beacons: [CLBeacon],
                             in region: CLBeaconRegion) {
        guard
            rangedRegions.contains(region)
            else { return }

        delegate?.locationManager?(locationManager,
                                   didRangeBeacons: beacons,
                                   in: region)
    }
    #endif

    #if os(iOS)
    func updateHeading(_ heading: CLHeading) {
        guard
            mockHeadingRunning
            else { return }

        delegate?.locationManager?(locationManager,
                                   didUpdateHeading: heading)
    }
    #endif

    #if os(iOS)
    func updateHeading(available: Bool) {
        type(of: self).mockHeadingAvailable = available
    }
    #endif

    #if os(iOS)
    func updateHeading(error: Error) {
        guard
            mockHeadingRunning
            else { return }

        delegate?.locationManager?(locationManager,
                                   didFailWithError: error)
    }
    #endif

    #if os(iOS)
    func updateHeading(forceHeading: CLHeading?) {
        heading = forceHeading
    }
    #endif

    func updateLocationServices(enabled: Bool) {
        type(of: self).mockLocationServicesEnabled = enabled
    }

    #if os(iOS) || os(macOS)
    func updateRegion(_ region: CLRegion?,
                      error: Error) {
        if let region = region {
            guard
                monitoredRegions.contains(region)
                else { return }
        }

        delegate?.locationManager?(locationManager,
                                   monitoringDidFailFor: region,
                                   withError: error)
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateRegion(available: Bool) {
        type(of: self).mockRegionAvailable = available
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateRegion(enter region: CLRegion) {
        guard
            monitoredRegions.contains(region)
            else { return }

        delegate?.locationManager?(locationManager,
                                   didEnterRegion: region)
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateRegion(error: Error) {
        guard
            !monitoredRegions.isEmpty
            else { return }

        delegate?.locationManager?(locationManager,
                                   didFailWithError: error)
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateRegion(exit region: CLRegion) {
        guard
            monitoredRegions.contains(region)
            else { return }

        delegate?.locationManager?(locationManager,
                                   didExitRegion: region)
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateRegion(state: CLRegionState) {
        guard
            let region = mockRegionStateRequested
            else { return }

        delegate?.locationManager?(locationManager,
                                   didDetermineState: state,
                                   for: region)
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateRegion(start region: CLRegion) {
        guard
            monitoredRegions.contains(region)
            else { return }

        delegate?.locationManager?(locationManager,
                                   didStartMonitoringFor: region)
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateSignificantLocation(_ location: CLLocation) {
        guard
            mockSignificantLocationRunning
            else { return }

        delegate?.locationManager?(locationManager,
                                   didUpdateLocations: [location])
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateSignificantLocation(available: Bool) {
        type(of: self).mockSignificantLocationAvailable = available
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateSignificantLocation(error: Error) {
        guard
            mockSignificantLocationRunning
            else { return }

        delegate?.locationManager?(locationManager,
                                   didFailWithError: error)
    }
    #endif

    func updateStandardLocation(_ location: CLLocation) {
        guard
            mockLocationRequested
                || mockStandardLocationRunning
            else { return }

        mockLocationRequested = false

        delegate?.locationManager?(locationManager,
                                   didUpdateLocations: [location])
    }

    #if os(iOS) || os(macOS)
    func updateStandardLocation(canDeferUpdates: Bool) {
        type(of: self).mockDeferredLocationUpdatesAvailable = canDeferUpdates
    }
    #endif

    #if os(iOS) || os(macOS)
    func updateStandardLocation(deferredError: Error?) {
        guard
            mockStandardLocationRunning
            else { return }

        delegate?.locationManager?(locationManager,
                                   didFinishDeferredUpdatesWithError: deferredError)
    }
    #endif

    func updateStandardLocation(error: Error) {
        guard
            mockStandardLocationRunning
            else { return }

        delegate?.locationManager?(locationManager,
                                   didFailWithError: error)
    }

    func updateStandardLocation(forceLocation: CLLocation?) {
        location = forceLocation
    }

    #if os(iOS)
    func updateVisit(_ visit: CLVisit) {
        guard
            mockVisitRunning
            else { return }

        delegate?.locationManager?(locationManager,
                                   didVisit: visit)
    }
    #endif

    #if os(iOS)
    func updateVisit(error: Error) {
        guard
            mockVisitRunning
            else { return }

        delegate?.locationManager?(locationManager,
                                   didFailWithError: error)
    }
    #endif
}

// swiftlint:enable file_length type_body_length
