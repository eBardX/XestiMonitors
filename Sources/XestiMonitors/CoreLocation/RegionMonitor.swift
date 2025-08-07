// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(macOS)

import CoreLocation

/// A `RegionMonitor` instance monitors a region for changes to its state
/// (which indicate boundary transitions). A region can be either a
/// geographical region or a Bluetooth low-energy beacon region.
/// - Note:
///   An authorization status of `authorizedAlways` is required.
public final class RegionMonitor: BaseMonitor {
    /// Encapsulates changes to the state of the region.
    public enum Event {
        /// The state of the region has been updated.
        case didUpdate(Info)
    }

    /// Encapsulates information associated with a region monitor event.
    public enum Info {
        /// The error encountered in attempting to determine the region state.
        case error(any Error, CLRegion)

        /// The current region state.
        case regionState(CLRegionState, CLRegion)
    }

    /// Initializes a new `RegionMonitor`.
    /// - Parameters:
    ///   - region:     The region to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the state of the region
    ///                 changes.
    public init(region: CLRegion,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue
        self.region = region

        super.init()

        self.adapter.didDetermineState = handleDidDetermineState
        self.adapter.didEnterRegion = handleDidEnterRegion
        self.adapter.didExitRegion = handleDidExitRegion
        self.adapter.didFail = handleDidFail
        self.adapter.didStartMonitoring = handleDidStartMonitoring
        self.adapter.monitoringDidFail = handleMonitoringDidFail

        self.locationManager.delegate = self.adapter
    }

    /// The region being monitored.
    public let region: CLRegion

    /// A Boolean value indicating whether the region is actively being
    /// monitored. There is a system-imposed, per-app limit to how many regions
    /// can be actively monitored.
    public var isActivelyMonitored: Bool {
        isMonitoring && locationManager.monitoredRegions.contains(region)
    }

    /// A Boolean value indicating whether the device supports monitoring the
    /// region.
    public var isAvailable: Bool {
        type(of: locationManager).isMonitoringAvailable(for: type(of: region))
    }

    /// The largest boundary distance that can be assigned to a region.
    public var maximumMonitoringDistance: CLLocationDistance {
        locationManager.maximumRegionMonitoringDistance
    }

    /// Requests the current state of the region.
    public func requestState() {
        locationManager.requestState(for: region)
    }

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: any LocationManagerProtocol
    private let queue: OperationQueue

    private func handleDidDetermineState(_ region: CLRegion,
                                         _ state: CLRegionState) {
        if self.region == region {
            handler(.didUpdate(.regionState(state, region)))
        }
    }

    private func handleDidEnterRegion(_ region: CLRegion) {
        if self.region == region {
            handler(.didUpdate(.regionState(.inside, region)))
        }
    }

    private func handleDidExitRegion(_ region: CLRegion) {
        if self.region == region {
            handler(.didUpdate(.regionState(.outside, region)))
        }
    }

    private func handleDidFail(_ error: any Error) {
        self.handler(.didUpdate(.error(error, region)))
    }

    private func handleDidStartMonitoring(_ region: CLRegion) {
        if self.region == region {
            handler(.didUpdate(.regionState(.unknown, region)))
        }
    }

    private func handleMonitoringDidFail(_ region: CLRegion?,
                                         _ error: any Error) {
        if let tmpRegion = region {
            if tmpRegion == self.region {
                handler(.didUpdate(.error(error, self.region)))
            }
        } else {
            handler(.didUpdate(.error(error, self.region)))
        }
    }

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
