//
//  LocationManagerDelegateAdapter.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-23.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation

internal class LocationManagerDelegateAdapter: NSObject {
    public var didChangeAuthorization: ((CLAuthorizationStatus) -> Void)?

    #if os(iOS) || os(macOS)
    public var didDetermineState: ((CLRegion, CLRegionState) -> Void)?
    #endif

    #if os(iOS) || os(macOS)
    public var didEnterRegion: ((CLRegion) -> Void)?
    #endif

    #if os(iOS) || os(macOS)
    public var didExitRegion: ((CLRegion) -> Void)?
    #endif

    public var didFail: ((Error) -> Void)?

    #if os(iOS) || os(macOS)
    public var didFinishDeferredUpdates: ((Error?) -> Void)?
    #endif

    #if os(iOS)
    public var didPauseLocationUpdates: (() -> Void)?
    #endif

    #if os(iOS)
    public var didRangeBeacons: ((CLBeaconRegion, [CLBeacon]) -> Void)?
    #endif

    #if os(iOS)
    public var didResumeLocationUpdates: (() -> Void)?
    #endif

    #if os(iOS) || os(macOS)
    public var didStartMonitoring: ((CLRegion) -> Void)?
    #endif

    #if os(iOS)
    public var didUpdateHeading: ((CLHeading) -> Void)?
    #endif

    public var didUpdateLocations: (([CLLocation]) -> Void)?

    #if os(iOS)
    public var didVisit: ((CLVisit) -> Void)?
    #endif

    #if os(iOS) || os(macOS)
    public var monitoringDidFail: ((CLRegion?, Error) -> Void)?
    #endif

    #if os(iOS)
    public var rangingBeaconsDidFail: ((CLBeaconRegion, Error) -> Void)?
    #endif

    #if os(iOS)
    public var shouldDisplayHeadingCalibration: (() -> Bool)?
    #endif
}

extension LocationManagerDelegateAdapter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuthorization?(status)
    }

    #if os(iOS) || os(macOS)
    func locationManager(_ manager: CLLocationManager,
                         didDetermineState state: CLRegionState,
                         for region: CLRegion) {
        didDetermineState?(region, state)
    }
    #endif

    #if os(iOS) || os(macOS)
    func locationManager(_ manager: CLLocationManager,
                         didEnterRegion region: CLRegion) {
        didEnterRegion?(region)
    }
    #endif

    #if os(iOS) || os(macOS)
    func locationManager(_ manager: CLLocationManager,
                         didExitRegion region: CLRegion) {
        didExitRegion?(region)
    }
    #endif

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        didFail?(error)
    }

    #if os(iOS) || os(macOS)
    func locationManager(_ manager: CLLocationManager,
                         didFinishDeferredUpdatesWithError error: Error?) {
        didFinishDeferredUpdates?(error)
    }
    #endif

    #if os(iOS)
    func locationManager(_ manager: CLLocationManager,
                         didRangeBeacons beacons: [CLBeacon],
                         in region: CLBeaconRegion) {
        didRangeBeacons?(region, beacons)
    }
    #endif

    #if os(iOS) || os(macOS)
    func locationManager(_ manager: CLLocationManager,
                         didStartMonitoringFor region: CLRegion) {
        didStartMonitoring?(region)
    }
    #endif

    #if os(iOS)
    func locationManager(_ manager: CLLocationManager,
                         didUpdateHeading newHeading: CLHeading) {
        didUpdateHeading?(newHeading)
    }
    #endif

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        didUpdateLocations?(locations)
    }

    #if os(iOS)
    func locationManager(_ manager: CLLocationManager,
                         didVisit visit: CLVisit) {
        didVisit?(visit)
    }
    #endif

    #if os(iOS) || os(macOS)
    func locationManager(_ manager: CLLocationManager,
                         monitoringDidFailFor region: CLRegion?,
                         withError error: Error) {
        monitoringDidFail?(region, error)
    }
    #endif

    #if os(iOS)
    func locationManager(_ manager: CLLocationManager,
                         rangingBeaconsDidFailFor region: CLBeaconRegion,
                         withError error: Error) {
        rangingBeaconsDidFail?(region, error)
    }
    #endif

    #if os(iOS)
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        didPauseLocationUpdates?()
    }
    #endif

    #if os(iOS)
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        didResumeLocationUpdates?()
    }
    #endif

    #if os(iOS)
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return shouldDisplayHeadingCalibration?() ?? false
    }
    #endif
}
