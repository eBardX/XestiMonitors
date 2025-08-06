// © 2018–2025 John Gary Pusey (see LICENSE.md)

import CoreLocation

internal class LocationManagerDelegateAdapter: NSObject {
    internal var didChangeAuthorization: (() -> Void)?

#if os(iOS) || os(macOS)
    internal var didDetermineState: ((CLRegion, CLRegionState) -> Void)?
#endif

#if os(iOS) || os(macOS)
    internal var didEnterRegion: ((CLRegion) -> Void)?
#endif

#if os(iOS) || os(macOS)
    internal var didExitRegion: ((CLRegion) -> Void)?
#endif

    internal var didFail: ((any Error) -> Void)?

#if os(iOS) || os(macOS)
    internal var didFailRangingBeacons: ((CLBeaconIdentityConstraint, any Error) -> Void)?
#endif

#if os(iOS) || os(macOS)
    internal var didFinishDeferredUpdates: (((any Error)?) -> Void)?
#endif

#if os(iOS) || os(macOS)
    internal var didPauseLocationUpdates: (() -> Void)?
#endif

#if os(iOS) || os(macOS)
    internal var didRangeBeacons: (([CLBeacon], CLBeaconIdentityConstraint) -> Void)?
#endif

#if os(iOS) || os(macOS)
    internal var didResumeLocationUpdates: (() -> Void)?
#endif

#if os(iOS) || os(macOS)
    internal var didStartMonitoring: ((CLRegion) -> Void)?
#endif

#if os(iOS) || os(macOS) || os(watchOS)
    internal var didUpdateHeading: ((CLHeading) -> Void)?
#endif

    internal var didUpdateLocations: (([CLLocation]) -> Void)?

#if os(iOS) || os(macOS)
    internal var didVisit: ((CLVisit) -> Void)?
#endif

#if os(iOS) || os(macOS)
    internal var monitoringDidFail: ((CLRegion?, any Error) -> Void)?
#endif

#if os(iOS) || os(macOS) || os(watchOS)
    internal var shouldDisplayHeadingCalibration: (() -> Bool)?
#endif
}

extension LocationManagerDelegateAdapter: CLLocationManagerDelegate {
#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didDetermineState state: CLRegionState,
                                  for region: CLRegion) {
        didDetermineState?(region, state)
    }
#endif

#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didEnterRegion region: CLRegion) {
        didEnterRegion?(region)
    }
#endif

#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didExitRegion region: CLRegion) {
        didExitRegion?(region)
    }
#endif

#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint,
                                  error: any Error) {
        didFailRangingBeacons?(beaconConstraint, error)
    }
#endif

    internal func locationManager(_ manager: CLLocationManager,
                                  didFailWithError error: any Error) {
        didFail?(error)
    }

#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didFinishDeferredUpdatesWithError error: (any Error)?) {
        didFinishDeferredUpdates?(error)
    }
#endif

#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didRange beacons: [CLBeacon],
                                  satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        didRangeBeacons?(beacons, beaconConstraint)
    }
#endif

#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didStartMonitoringFor region: CLRegion) {
        didStartMonitoring?(region)
    }
#endif

#if os(iOS) || os(macOS) || os(watchOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didUpdateHeading newHeading: CLHeading) {
        didUpdateHeading?(newHeading)
    }
#endif

    internal func locationManager(_ manager: CLLocationManager,
                                  didUpdateLocations locations: [CLLocation]) {
        didUpdateLocations?(locations)
    }

#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  didVisit visit: CLVisit) {
        didVisit?(visit)
    }
#endif

#if os(iOS) || os(macOS)
    internal func locationManager(_ manager: CLLocationManager,
                                  monitoringDidFailFor region: CLRegion?,
                                  withError error: any Error) {
        monitoringDidFail?(region, error)
    }
#endif

    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        didChangeAuthorization?()
    }

#if os(iOS) || os(macOS)
    internal func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        didPauseLocationUpdates?()
    }
#endif

#if os(iOS) || os(macOS)
    internal func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        didResumeLocationUpdates?()
    }
#endif

#if os(iOS) || os(macOS) || os(watchOS)
    internal func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        shouldDisplayHeadingCalibration?() ?? false
    }
#endif
}
