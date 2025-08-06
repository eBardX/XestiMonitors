// © 2017–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(watchOS)

import CoreMotion

internal protocol PedometerProtocol {
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

// MARK: -

extension CMPedometer: PedometerProtocol {}

// MARK: -

extension Dependencies {
    internal static let pedometerInjected = {
        DependencyResolver.register(CMPedometer() as any PedometerProtocol)
    }()
}

#endif
