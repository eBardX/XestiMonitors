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
    ///
    /// Encapsulates changes to the relative altitude.
    ///
    public enum Event {
        ///
        /// The relative altitude has been updated.
        ///
        case didUpdate(Info)
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
        case unknown
    }

    ///
    /// Initializes a new `AltimeterMonitor`.
    ///
    /// - Parameters:
    ///   - altimeter
    ///   - queue:      The operation queue on which the handler executes.
    ///   - handler:    The handler to call when new altitude data is
    ///                 available.
    ///
    public init(altimeter: Altimeter = CMAltimeter(),
                queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.altimeter = altimeter
        self.handler = handler
        self.queue = queue
    }

    ///
    /// A Boolean value indicating whether the device supports generating data
    /// for relative altitude changes.
    ///
    public var isAvailable: Bool {
        return type(of: altimeter).isRelativeAltitudeAvailable()
    }

    private let altimeter: Altimeter
    private let handler: (Event) -> Void
    private let queue: OperationQueue

    public override final func cleanupMonitor() {
        altimeter.stopRelativeAltitudeUpdates()

        super.cleanupMonitor()
    }

    public override final func configureMonitor() {
        super.configureMonitor()

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
    }
}
