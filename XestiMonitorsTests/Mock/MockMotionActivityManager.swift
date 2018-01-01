//
//  MockMotionActivityManager.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-01-01.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
@testable import XestiMonitors

internal class MockMotionActivityManager: MotionActivityManager {

    static func isActivityAvailable() -> Bool {

        return motionActivityAvailable

    }

    func queryActivityStarting(from start: Date,
                               to end: Date,
                               to queue: OperationQueue,
                               withHandler handler: @escaping CMMotionActivityQueryHandler) {

        motionActivityQueryHandler = handler

    }

    func startActivityUpdates(to queue: OperationQueue,
                              withHandler handler: @escaping CMMotionActivityHandler) {

        motionActivityHandler = handler

    }

    func stopActivityUpdates() {

        motionActivityHandler = nil

    }

    private static var motionActivityAvailable = false

    private var motionActivityHandler: CMMotionActivityHandler?
    private var motionActivityQueryHandler: CMMotionActivityQueryHandler?

    // MARK: -

    func updateMotionActivity(available: Bool) {

        type(of: self).motionActivityAvailable = available

    }

    func updateMotionActivity(data: CMMotionActivity?) {

        if let handler = motionActivityHandler {
            handler(data)
        }

    }

    func updateMotionActivity(queryData: [CMMotionActivity]?) {

        if let handler = motionActivityQueryHandler {
            motionActivityQueryHandler = nil
            handler(queryData, nil)
        }

    }

    func updateMotionActivity(queryError: Error) {

        if let handler = motionActivityQueryHandler {
            motionActivityQueryHandler = nil
            handler(nil, queryError)
        }

    }

}
