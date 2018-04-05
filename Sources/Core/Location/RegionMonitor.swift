//
//  RegionMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(macOS)

import CoreLocation

///
/// A `RegionMonitor` instance monitors a region for changes to its state
/// (which indicate boundary transitions). A region can be either a
/// geographical region or a Bluetooth low-energy beacon region.
///
/// - Note:
///   An authorization status of `authorizedAlways` is required.
///
public class RegionMonitor: BaseMonitor {
    ///
    /// Encapsulates changes to the state of the region.
    ///
    public enum Event {
        ///
        /// The state of the region has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates information associated with a region monitor event.
    ///
    public enum Info {
        ///
        /// The error encountered in attempting to determine the region state.
        ///
        case error(Error, CLRegion)

        ///
        /// The current region state.
        ///
        case regionState(CLRegionState, CLRegion)
    }

    ///
    /// Initializes a new `RegionMonitor`.
    ///
    /// - Parameters:
    ///   - region:     The region to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when the state of the region
    ///                 changes.
    ///
    public init(region: CLRegion,
                queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue
        self.region = region

        super.init()

        self.adapter.didDetermineState = { [unowned self] in
            if self.region == $0 {
                self.handler(.didUpdate(.regionState($1, self.region)))
            }
        }

        self.adapter.didEnterRegion = { [unowned self] in
            if self.region == $0 {
                self.handler(.didUpdate(.regionState(.inside, self.region)))
            }
        }

        self.adapter.didExitRegion = { [unowned self] in
            if self.region == $0 {
                self.handler(.didUpdate(.regionState(.outside, self.region)))
            }
        }

        self.adapter.didFail = { [unowned self] in
            self.handler(.didUpdate(.error($0, self.region)))
        }

        self.adapter.didStartMonitoring = { [unowned self] in
            if self.region == $0 {
                self.handler(.didUpdate(.regionState(.unknown, self.region)))
            }
        }

        self.adapter.monitoringDidFail = { [unowned self] in
            if let tmpRegion = $0 {
                if tmpRegion == self.region {
                    self.handler(.didUpdate(.error($1, self.region)))
                }
            } else {
                self.handler(.didUpdate(.error($1, self.region)))
            }
        }

        self.locationManager.delegate = self.adapter
    }

    ///
    /// The region being monitored.
    ///
    public let region: CLRegion

    ///
    /// A Boolean value indicating whether the region is actively being
    /// monitored. There is a system-imposed, per-app limit to how many regions
    /// can be actively monitored.
    ///
    public var isActivelyMonitored: Bool {
        return isMonitoring
            &&  locationManager.monitoredRegions.contains(region)
    }

    ///
    /// A Boolean value indicating whether the device supports monitoring the
    /// region.
    ///
    public var isAvailable: Bool {
        return type(of: locationManager).isMonitoringAvailable(for: type(of: region))
    }

    ///
    /// The largest boundary distance that can be assigned to a region.
    ///
    public var maximumMonitoringDistance: CLLocationDistance {
        return locationManager.maximumRegionMonitoringDistance
    }

    ///
    /// Requests the current state of the region.
    ///
    public func requestState() {
        locationManager.requestState(for: region)
    }

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: LocationManagerProtocol
    private let queue: OperationQueue

    override public func cleanupMonitor() {
        locationManager.stopMonitoring(for: region)

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        locationManager.startMonitoring(for: region)
    }
}

#endif
