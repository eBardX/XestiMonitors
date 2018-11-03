//
//  PedometerInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-30.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(watchOS)

import CoreMotion

internal protocol PedometerProtocol: AnyObject {
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

extension CMPedometer: PedometerProtocol {}

internal enum PedometerInjector {
    internal static var inject: () -> PedometerProtocol = { CMPedometer() }
}

#endif
