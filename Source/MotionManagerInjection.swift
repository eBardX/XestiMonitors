//
//  MotionManagerInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-16.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion

internal protocol MotionManagerProtocol: class {
    var accelerometerData: CMAccelerometerData? { get }

    var accelerometerUpdateInterval: TimeInterval { get set }

    var deviceMotion: CMDeviceMotion? { get }

    var deviceMotionUpdateInterval: TimeInterval { get set }

    var gyroData: CMGyroData? { get }

    var gyroUpdateInterval: TimeInterval { get set }

    var isAccelerometerAvailable: Bool { get }

    var isDeviceMotionAvailable: Bool { get }

    var isGyroAvailable: Bool { get }

    var isMagnetometerAvailable: Bool { get }

    var magnetometerData: CMMagnetometerData? { get }

    var magnetometerUpdateInterval: TimeInterval { get set }

    func startAccelerometerUpdates(to queue: OperationQueue,
                                   withHandler handler: @escaping CMAccelerometerHandler)

    func startDeviceMotionUpdates(using referenceFrame: CMAttitudeReferenceFrame,
                                  to queue: OperationQueue,
                                  withHandler handler: @escaping CMDeviceMotionHandler)

    func startGyroUpdates(to queue: OperationQueue,
                          withHandler handler: @escaping CMGyroHandler)

    func startMagnetometerUpdates(to queue: OperationQueue,
                                  withHandler handler: @escaping CMMagnetometerHandler)

    func stopAccelerometerUpdates()

    func stopDeviceMotionUpdates()

    func stopGyroUpdates()

    func stopMagnetometerUpdates()
}

extension CMMotionManager: MotionManagerProtocol {}

internal protocol MotionManagerInjected {}

internal struct MotionManagerInjector {
    static var motionManager: MotionManagerProtocol = CMMotionManager()
}

internal extension MotionManagerInjected {
    var motionManager: MotionManagerProtocol { return MotionManagerInjector.motionManager }
}
