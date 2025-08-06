// © 2018–2025 John Gary Pusey (see LICENSE.md)

import CoreMotion
@testable import XestiMonitors

internal class MockMotionActivityManager: MotionActivityManagerProtocol {
    static func isActivityAvailable() -> Bool {
        motionActivityAvailable
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
        Self.motionActivityAvailable = available
    }

    func updateMotionActivity(data: CMMotionActivity?) {
        motionActivityHandler?(data)
    }

    func updateMotionActivity(queryData: [CMMotionActivity]?) {
        if let handler = motionActivityQueryHandler {
            motionActivityQueryHandler = nil
            handler(queryData, nil)
        }
    }

    func updateMotionActivity(queryError: any Error) {
        if let handler = motionActivityQueryHandler {
            motionActivityQueryHandler = nil
            handler(nil, queryError)
        }
    }
}
