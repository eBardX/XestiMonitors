//
//  HeadingMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)

import CoreLocation

///
/// A `HeadingMonitor` instance monitors the device for changes to its current
/// heading.
///
public class HeadingMonitor: BaseMonitor {
    ///
    /// Encapsulates changes to the device’s current heading.
    ///
    public enum Event {
        ///
        /// The current heading has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates information associated with a heading monitor event.
    ///
    public enum Info {
        ///
        /// The error encountered in attempting to obtain the current heading.
        ///
        case error(Error)

        ///
        /// The latest heading data.
        ///
        case heading(CLHeading)
    }

    ///
    /// Initializes a new `HeadingMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when the current heading of the
    ///                 device changes.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue
        self.shouldDisplayCalibration = false

        super.init()

        self.adapter.didFail = { [unowned self] in
            self.handler(.didUpdate(.error($0)))
        }

        self.adapter.didUpdateHeading = { [unowned self] in
            self.handler(.didUpdate(.heading($0)))
        }

        self.adapter.shouldDisplayHeadingCalibration = { [unowned self] in
            return self.shouldDisplayCalibration
        }

        self.locationManager.delegate = self.adapter
    }

    ///
    /// The minimum angular change (measured in degrees) required to generate
    /// new heading updates.
    ///
    public var filter: CLLocationDegrees {
        get { return locationManager.headingFilter }
        set { locationManager.headingFilter = newValue }
    }

    ///
    /// The most recently reported heading.
    ///
    /// The value of this property is nil if heading updates have never been
    /// initiated.
    ///
    public var heading: CLHeading? {
        return locationManager.heading
    }

    ///
    /// A Boolean value indicating whether the device is able to generate
    /// heading updates.
    ///
    public var isAvailable: Bool {
        return type(of: locationManager).headingAvailable()
    }

    ///
    /// The device orientation to use when computing heading values.
    ///
    public var orientation: CLDeviceOrientation {
        get { return locationManager.headingOrientation }
        set { locationManager.headingOrientation = newValue }
    }

    ///
    /// A Boolean value indicating whether the heading calibration view should
    /// be displayed.
    ///
    public var shouldDisplayCalibration: Bool

    ///
    /// Dismisses the heading calibration view from the screen immediately.
    ///
    public func dismissCalibrationDisplay() {
        locationManager.dismissHeadingCalibrationDisplay()
    }

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: LocationManagerProtocol
    private let queue: OperationQueue

    override public func cleanupMonitor() {
        locationManager.stopUpdatingHeading()

        super.cleanupMonitor()
    }

    override public func configureMonitor() {
        super.configureMonitor()

        locationManager.startUpdatingHeading()
    }
}

#endif
