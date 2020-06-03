//
//  MotionActivityManagerInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-30.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(watchOS)

    import CoreMotion

    internal protocol MotionActivityManagerProtocol: class {
        static func isActivityAvailable() -> Bool

        func queryActivityStarting(from start: Date,
                                   to end: Date,
                                   to queue: OperationQueue,
                                   withHandler handler: @escaping CMMotionActivityQueryHandler)

        func startActivityUpdates(to queue: OperationQueue,
                                  withHandler handler: @escaping CMMotionActivityHandler)

        func stopActivityUpdates()
    }

    extension CMMotionActivityManager: MotionActivityManagerProtocol {}

    internal protocol MotionActivityManagerInjected {}

    internal struct MotionActivityManagerInjector {
        static var motionActivityManager: MotionActivityManagerProtocol = CMMotionActivityManager()
    }

    internal extension MotionActivityManagerInjected {
        var motionActivityManager: MotionActivityManagerProtocol { return MotionActivityManagerInjector.motionActivityManager }
    }

#endif
