// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS)

import CoreLocation

/// A `HeadingMonitor` instance monitors the device for changes to its current
/// heading.
public final class HeadingMonitor: BaseMonitor {
    /// Encapsulates changes to the device’s current heading.
    public enum Event {
        /// The current heading has been updated.
        case didUpdate(Info)
    }

    /// Encapsulates information associated with a heading monitor event.
    public enum Info {
        /// The error encountered in attempting to obtain the current heading.
        case error(any Error)

        /// The latest heading data.
        case heading(CLHeading)
    }

    /// Initializes a new `HeadingMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the current heading of the
    ///                 device changes.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.adapter = .init()
        self.handler = handler
        self.locationManager = LocationManagerInjector.inject()
        self.queue = queue
        self.shouldDisplayCalibration = false

        super.init()

        self.adapter.didFail = handleDidFail
        self.adapter.didUpdateHeading = handleDidUpdateHeading
        self.adapter.shouldDisplayHeadingCalibration = handleShouldDisplayHeadingCalibration

        self.locationManager.delegate = self.adapter
    }

    /// The minimum angular change (measured in degrees) required to generate
    /// new heading updates.
    public var filter: CLLocationDegrees {
        get { locationManager.headingFilter }
        set { locationManager.headingFilter = newValue }
    }

    /// The most recently reported heading.
    /// The value of this property is nil if heading updates have never been
    /// initiated.
    public var heading: CLHeading? {
        locationManager.heading
    }

    /// A Boolean value indicating whether the device is able to generate
    /// heading updates.
    public var isAvailable: Bool {
        type(of: locationManager).headingAvailable()
    }

    /// The device orientation to use when computing heading values.
    public var orientation: CLDeviceOrientation {
        get { locationManager.headingOrientation }
        set { locationManager.headingOrientation = newValue }
    }

    /// A Boolean value indicating whether the heading calibration view should
    /// be displayed.
    public var shouldDisplayCalibration: Bool

    /// Dismisses the heading calibration view from the screen immediately.
    public func dismissCalibrationDisplay() {
        locationManager.dismissHeadingCalibrationDisplay()
    }

    private let adapter: LocationManagerDelegateAdapter
    private let handler: (Event) -> Void
    private let locationManager: any LocationManagerProtocol
    private let queue: OperationQueue

    private func handleDidFail(_ error: any Error) {
        handler(.didUpdate(.error(error)))
    }

    private func handleDidUpdateHeading(_ heading: CLHeading) {
        handler(.didUpdate(.heading(heading)))
    }

    private func handleShouldDisplayHeadingCalibration() -> Bool {
        shouldDisplayCalibration
    }

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
