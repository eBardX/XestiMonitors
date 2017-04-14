//
//  AltimeterMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-04-14.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import Foundation

///
/// An `AltimeterMonitor` object monitors ...
///
public class AltimeterMonitor: BaseMonitor {

    // Public Nested Types

    ///
    /// Encapsulates updates to the measurement of device motion.
    ///
    public enum Event {
        ///
        /// The device motion measurement has been updated.
        ///
        case didUpdate(Info)
    }

    ///
    /// Encapsulates the measurement of device motion.
    ///
    public enum Info {

        ///
        /// The device motion measurement at a moment of time.
        ///
        case data(CMAltitudeData)

        ///
        /// The error encountered in attempting to obtain the device motion
        /// measurement.
        ///
        case error(Error)

        ///
        /// No device motion measurement is available.
        ///
        case unknown

    }

    // Public Initializers

    ///
    /// Initializes a new `AltimeterMonitor`.
    ///
    /// - Parameters:
    ///   - queue:          The operation queue on which the handler executes.
    ///                     Because the events might arrive at a high rate,
    ///                     using the main operation queue is not recommended.
    ///   - handler:        The handler to call periodically when a new device
    ///                     motion measurement is available.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {

        self.altimeter = CMAltimeter()
        self.handler = handler
        self.queue = queue

    }

    // Public Instance Properties

    ///
    /// A Boolean value indicating whether device motion measuring is available
    /// on the device.
    ///
    public var isAvailable: Bool {

        return CMAltimeter.isRelativeAltitudeAvailable()

    }

    // Private Instance Properties

    private let altimeter: CMAltimeter
    private let handler: (Event) -> Void
    private let queue: OperationQueue

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        altimeter.stopRelativeAltitudeUpdates()

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor()
            else { return false }

        altimeter.startRelativeAltitudeUpdates(to: .main) { [unowned self] data, error in

                                                var info: Info

                                                if let error = error {
                                                    info = .error(error)
                                                } else if let data = data {
                                                    info = .data(data)
                                                } else {
                                                    info = .unknown
                                                }

                                                self.handler(.didUpdate(info))

        }

        return true

    }

}
