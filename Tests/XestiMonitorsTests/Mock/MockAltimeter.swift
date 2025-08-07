// © 2018–2025 John Gary Pusey (see LICENSE.md)

import CoreMotion
@testable import XestiMonitors

internal class MockAltimeter: AltimeterProtocol {
    static func isRelativeAltitudeAvailable() -> Bool {
        altimeterAvailable
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
        Self.altimeterAvailable = available
    }

    func updateAltimeter(data: CMAltitudeData?) {
        altimeterHandler?(data, nil)
    }

    func updateAltimeter(error: any Error) {
        altimeterHandler?(nil, error)
    }
}
