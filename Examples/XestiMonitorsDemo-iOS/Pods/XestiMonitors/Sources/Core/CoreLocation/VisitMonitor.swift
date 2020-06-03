//
//  VisitMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)

import CoreLocation

///
/// A `VisitMonitor` instance monitors for locations that the user stops at for
/// a “noteworthy” amount of time. This is considered to be a *visit*.
///
/// - Note:
///   An authorization status of `authorizedAlways` is required.
///
public class VisitMonitor: BaseMonitor {
    ///
    /// Encapsulates changes to the device’s current location that constitute
    /// a visit.
    ///
    public enum Event {
        ///
        /// A visit has been determined or updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates information associated with a visit monitor event.
    ///
    public enum Info {
        ///
        /// The error encountered in attempting to determine or update a visit.
        ///
        case error(Error)

        ///
        /// The latest visit data.
        ///
        case visit(CLVisit)
    }

    ///
    /// Initializes a new `VisitMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when a visit is determined or
    ///                 updated.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue

        super.init()

        self.adapter.didFail = handleDidFail
        self.adapter.didVisit = handleDidVisit

        self.locationManager.delegate = self.adapter
    }

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: LocationManagerProtocol
    private let queue: OperationQueue

    private func handleDidFail(_ error: Error) {
        handler(.didUpdate(.error(error)))
    }

    private func handleDidVisit(_ visit: CLVisit) {
        handler(.didUpdate(.visit(visit)))
    }

    override public func cleanupMonitor() {
        locationManager.stopMonitoringVisits()

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        locationManager.startMonitoringVisits()
    }
}

#endif
