// © 2018–2025 John Gary Pusey (see LICENSE.md)

import CoreMotion
@testable import XestiMonitors

internal class MockPedometer: PedometerProtocol {
    static func isCadenceAvailable() -> Bool {
        cadenceAvailable
    }

    static func isDistanceAvailable() -> Bool {
        distanceAvailable
    }

    static func isFloorCountingAvailable() -> Bool {
        floorCountingAvailable
    }

    static func isPaceAvailable() -> Bool {
        paceAvailable
    }

    static func isStepCountingAvailable() -> Bool {
        stepCountingAvailable
    }

    func queryPedometerData(from start: Date,
                            to end: Date,
                            withHandler handler: @escaping CMPedometerHandler) {
        pedometerQueryHandler = handler
    }

    func startUpdates(from start: Date,
                      withHandler handler: @escaping CMPedometerHandler) {
        pedometerHandler = handler
    }

    func stopUpdates() {
        pedometerHandler = nil
    }

    private static var cadenceAvailable = false
    private static var distanceAvailable = false
    private static var floorCountingAvailable = false
    private static var paceAvailable = false
    private static var stepCountingAvailable = false

    private var pedometerHandler: CMPedometerHandler?
    private var pedometerQueryHandler: CMPedometerHandler?

    // MARK: -

    func updatePedometer(cadenceAvailable: Bool) {
        Self.cadenceAvailable = cadenceAvailable
    }

    func updatePedometer(data: CMPedometerData?) {
        pedometerHandler?(data, nil)
    }

    func updatePedometer(distanceAvailable: Bool) {
        Self.distanceAvailable = distanceAvailable
    }

    func updatePedometer(error: any Error) {
        pedometerHandler?(nil, error)
    }

    func updatePedometer(floorCountingAvailable: Bool) {
        Self.floorCountingAvailable = floorCountingAvailable
    }

    func updatePedometer(paceAvailable: Bool) {
        Self.paceAvailable = paceAvailable
    }

    func updatePedometer(queryData: CMPedometerData?) {
        if let handler = pedometerQueryHandler {
            pedometerQueryHandler = nil
            handler(queryData, nil)
        }
    }

    func updatePedometer(queryError: any Error) {
        if let handler = pedometerQueryHandler {
            pedometerQueryHandler = nil
            handler(nil, queryError)
        }
    }

    func updatePedometer(stepCountingAvailable: Bool) {
        Self.stepCountingAvailable = stepCountingAvailable
    }
}
