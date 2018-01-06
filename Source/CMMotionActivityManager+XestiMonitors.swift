//
//  CMMotionActivityManager+XestiMonitors.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-30.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion

public protocol MotionActivityManager: class {
    static func isActivityAvailable() -> Bool

    func queryActivityStarting(from start: Date,
                               to end: Date,
                               to queue: OperationQueue,
                               withHandler handler: @escaping CMMotionActivityQueryHandler)

    func startActivityUpdates(to queue: OperationQueue,
                              withHandler handler: @escaping CMMotionActivityHandler)

    func stopActivityUpdates()
}

extension CMMotionActivityManager: MotionActivityManager {}
