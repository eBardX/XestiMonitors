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
/// An `AltimeterMonitor` instance monitors the device for changes in relative
/// altitude.
///
public class AltimeterMonitor: BaseMonitor {

    // Public Nested Types

    ///
    /// Encapsulates changes to the relative altitude.
    ///
    public enum Event {
        ///
        /// The relative altitude has changed.
        ///
        case didChange(Info)
    }

    ///
    /// Encapsulates the relative change in altitude.
    ///
    public enum Info {

        ///
        /// The relative change in altitude data.
        ///
        case data(CMAltitudeData)

        ///
        /// The error encountered in attempting to obtain the relative change
        /// in altitude.
        ///
        case error(Error)

        ///
        /// No altitude data is available.
        ///
        case unknown    // ELIMINATE???

    }

    // Public Initializers

    ///
    /// Initializes a new `AltimeterMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when new altitude data is
    ///                 available.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {

        self.altimeter = CMAltimeter()
        self.handler = handler
        self.queue = queue

    }

    // Public Instance Properties

    ///
    /// A Boolean value indicating whether the device supports generating data
    /// for relative altitude changes.
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

                                                self.handler(.didChange(info))

        }

        return true

    }

}
