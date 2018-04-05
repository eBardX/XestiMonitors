//
//  MockPedometer.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-01-01.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
@testable import XestiMonitors

internal class MockPedometer: PedometerProtocol {
    static func isCadenceAvailable() -> Bool {
        return cadenceAvailable
    }

    static func isDistanceAvailable() -> Bool {
        return distanceAvailable
    }

    static func isFloorCountingAvailable() -> Bool {
        return floorCountingAvailable
    }

    static func isPaceAvailable() -> Bool {
        return paceAvailable
    }

    static func isStepCountingAvailable() -> Bool {
        return stepCountingAvailable
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
        type(of: self).cadenceAvailable = cadenceAvailable
    }

    func updatePedometer(data: CMPedometerData?) {
        pedometerHandler?(data, nil)
    }

    func updatePedometer(distanceAvailable: Bool) {
        type(of: self).distanceAvailable = distanceAvailable
    }

    func updatePedometer(error: Error) {
        pedometerHandler?(nil, error)
    }

    func updatePedometer(floorCountingAvailable: Bool) {
        type(of: self).floorCountingAvailable = floorCountingAvailable
    }

    func updatePedometer(paceAvailable: Bool) {
        type(of: self).paceAvailable = paceAvailable
    }

    func updatePedometer(queryData: CMPedometerData?) {
        if let handler = pedometerQueryHandler {
            pedometerQueryHandler = nil
            handler(queryData, nil)
        }
    }

    func updatePedometer(queryError: Error) {
        if let handler = pedometerQueryHandler {
            pedometerQueryHandler = nil
            handler(nil, queryError)
        }
    }

    func updatePedometer(stepCountingAvailable: Bool) {
        type(of: self).stepCountingAvailable = stepCountingAvailable
    }
}
