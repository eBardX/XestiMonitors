// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(macOS)

import CoreLocation

/// A `SignificantLocationMonitor` instance monitors the device for
/// *significant* changes to its current location.
/// - Note:
///   An authorization status of `authorizedAlways` is required.
public final class SignificantLocationMonitor: BaseMonitor {
    /// Encapsulates changes to the device’s current location.
    public enum Event {
        /// The current location has been updated.
        case didUpdate(Info)
    }

    /// Encapsulates information associated with a significant location monitor
    /// event.
    public enum Info {
        /// The error encountered in attempting to obtain the current location.
        case error(any Error)

        /// The latest location data.
        case location(CLLocation)
    }

    /// Initializes a new `SignificantLocationMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the current location of the
    ///                 device changes significantly.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.queue = queue

        super.init()

        self.adapter.didFail = handleDidFail
        self.adapter.didUpdateLocations = handleDidUpdateLocations

        self.locationManager.delegate = self.adapter
    }

    /// A Boolean value indicating whether the significant-change location
    /// service is available.
    /// 
    public var isAvailable: Bool {
        type(of: locationManager).significantLocationChangeMonitoringAvailable()
    }

    @Inject private var locationManager: any LocationManagerProtocol

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let queue: OperationQueue

    private func handleDidFail(_ error: any Error) {
        handler(.didUpdate(.error(error)))
    }

    private func handleDidUpdateLocations(_ locations: [CLLocation]) {
        if let location = locations.first {
            handler(.didUpdate(.location(location)))
        }
    }

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
