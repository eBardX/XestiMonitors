//
//  MockAltimeter.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-01-01.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
@testable import XestiMonitors

internal class MockAltimeter: AltimeterProtocol {
    static func isRelativeAltitudeAvailable() -> Bool {
        return altimeterAvailable
    }

    func startRelativeAltitudeUpdates(to queue: OperationQueue,
                                      withHandler handler: @escaping CMAltitudeHandler) {
        altimeterHandler = handler
    }

    func stopRelativeAltitudeUpdates() {
        altimeterHandler = nil
    }

    private static var altimeterAvailable = false

    private var altimeterHandler: CMAltitudeHandler?

    // MARK: -

    func updateAltimeter(available: Bool) {
        type(of: self).altimeterAvailable = available
    }

    func updateAltimeter(data: CMAltitudeData?) {
        altimeterHandler?(data, nil)
    }

    func updateAltimeter(error: Error) {
        altimeterHandler?(nil, error)
    }
}
