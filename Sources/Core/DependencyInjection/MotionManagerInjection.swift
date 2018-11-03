//
//  MotionManagerInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-16.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(watchOS)

import CoreMotion

internal protocol MotionManagerProtocol: AnyObject {
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

internal enum MotionManagerInjector {
    internal static var inject: () -> MotionManagerProtocol = { shared }

    private static let shared: MotionManagerProtocol = CMMotionManager()
}

#endif
