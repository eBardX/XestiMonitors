//
//  PedometerInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-30.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion

internal protocol Pedometer: class {
    static func isCadenceAvailable() -> Bool

    static func isDistanceAvailable() -> Bool

    static func isFloorCountingAvailable() -> Bool

    static func isPaceAvailable() -> Bool

    static func isStepCountingAvailable() -> Bool

    func queryPedometerData(from start: Date,
                            to end: Date,
                            withHandler handler: @escaping CMPedometerHandler)

    func startUpdates(from start: Date,
                      withHandler handler: @escaping CMPedometerHandler)

    func stopUpdates()
}

extension CMPedometer: Pedometer {}

internal protocol PedometerInjected {}

internal struct PedometerInjector {
    static var pedometer: Pedometer = CMPedometer()
}

internal extension PedometerInjected {
    var pedometer: Pedometer { return PedometerInjector.pedometer }
}
