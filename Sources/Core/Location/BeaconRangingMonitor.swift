//
//  BeaconRangingMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)

import CoreLocation

///
/// A `BeaconRangingMonitor` instance monitors a region for changes to the
/// ranges (*i.e.,* the relative proximity) to the Bluetooth low-energy beacons
/// within.
///
public class BeaconRangingMonitor: BaseMonitor {
    ///
    /// Encapsulates changes to the beacon ranges within a region.
    ///
    public enum Event {
        ///
        /// The beacon ranges have been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates information associated with a beacon ranging monitor
    /// event.
    ///
    public enum Info {
        ///
        /// The current beacon ranges.
        ///
        case beacons([CLBeacon], CLBeaconRegion)

        ///
        /// The error encountered in attempting to determine the beacon ranges
        /// within the region.
        ///
        case error(Error, CLBeaconRegion)
    }

    ///
    /// Initializes a new `BeaconRangingMonitor`.
    ///
    /// - Parameters:
    ///   - region:     The beacon region to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when a beacon range change is
    ///                 detected.
    ///
    public init(region: CLBeaconRegion,
                queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue
        self.region = region

        super.init()

        self.adapter.didFail = { [unowned self] in
            self.handler(.didUpdate(.error($0, self.region)))
        }

        self.adapter.didRangeBeacons = { [unowned self] in
            if self.region == $0 {
                self.handler(.didUpdate(.beacons($1, self.region)))
            }
        }

        self.adapter.rangingBeaconsDidFail = { [unowned self] in
            if self.region == $0 {
                self.handler(.didUpdate(.error($1, self.region)))
            }
        }

        self.locationManager.delegate = self.adapter
    }

    ///
    /// The beacon region being monitored.
    ///
    public let region: CLBeaconRegion

    ///
    /// A Boolean value indicating whether the region is actively being tracked
    /// using ranging. There is a system-imposed, per-app limit to how many
    /// regions can be actively ranged.
    ///
    public var isActivelyRanged: Bool {
        return isMonitoring
            && locationManager.rangedRegions.contains(region)
    }

    ///
    /// A Boolean value indicating whether the device supports the ranging of
    /// Bluetooth beacons.
    ///
    public var isAvailable: Bool {
        return type(of: locationManager).isRangingAvailable()
    }

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: LocationManagerProtocol
    private let queue: OperationQueue

    override public func cleanupMonitor() {
        locationManager.stopRangingBeacons(in: region)

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        locationManager.startRangingBeacons(in: region)
    }
}

#endif
