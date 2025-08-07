// © 2017–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(watchOS)

import CoreMotion

internal protocol MotionActivityManagerProtocol {
    static func isActivityAvailable() -> Bool

    func queryActivityStarting(from start: Date,
                               to end: Date,
                               to queue: OperationQueue,
                               withHandler handler: @escaping CMMotionActivityQueryHandler)

    func startActivityUpdates(to queue: OperationQueue,
                              withHandler handler: @escaping CMMotionActivityHandler)

    func stopActivityUpdates()
}

// MARK: -

extension CMMotionActivityManager: MotionActivityManagerProtocol {}

// MARK: -

internal enum MotionActivityManagerInjector {
    internal static var inject: () -> any MotionActivityManagerProtocol = { CMMotionActivityManager() }
}

#endif
