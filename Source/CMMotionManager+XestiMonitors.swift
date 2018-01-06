//
//  CMMotionManager+XestiMonitors.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-16.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion

public protocol MotionManager: class {
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

extension CMMotionManager: MotionManager {}

public extension CMMotionManager {
    ///
    /// Returns the singleton motion manager instance.
    ///
    /// According to Apple:
    ///
    /// > An app should create only a single instance of the `CMMotionManager`
    /// > class. Multiple instances of this class can affect the rate at which
    /// > data is received from the accelerometer and gyroscope.
    ///
    /// By default, all motion monitor classes use this shared motion manager
    /// instance.
    ///
    static let shared = CMMotionManager()
}
