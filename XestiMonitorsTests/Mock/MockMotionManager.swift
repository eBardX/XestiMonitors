//
//  MockMotionManager.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-31.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
@testable import XestiMonitors

internal class MockMotionManager: MotionManager {

    init() {

        self.accelerometerUpdateInterval = 0
        self.deviceMotionUpdateInterval = 0
        self.gyroUpdateInterval = 0
        self.isAccelerometerAvailable = false
        self.isDeviceMotionAvailable = false
        self.isGyroAvailable = false
        self.isMagnetometerAvailable = false
        self.magnetometerUpdateInterval = 0

    }

    var accelerometerUpdateInterval: TimeInterval
    var deviceMotionUpdateInterval: TimeInterval
    var gyroUpdateInterval: TimeInterval
    var magnetometerUpdateInterval: TimeInterval

    private(set) var accelerometerData: CMAccelerometerData?
    private(set) var deviceMotion: CMDeviceMotion?
    private(set) var gyroData: CMGyroData?
    private(set) var isAccelerometerAvailable: Bool
    private(set) var isDeviceMotionAvailable: Bool
    private(set) var isGyroAvailable: Bool
    private(set) var isMagnetometerAvailable: Bool
    private(set) var magnetometerData: CMMagnetometerData?

    var isAccelerometerActive: Bool {
        return accelerometerHandler != nil
    }

    var isDeviceMotionActive: Bool {
        return deviceMotionHandler != nil
    }

    var isGyroActive: Bool {
        return gyroscopeHandler != nil
    }

    var isMagnetometerActive: Bool {
        return magnetometerHandler != nil
    }

    func startAccelerometerUpdates(to queue: OperationQueue,
                                   withHandler handler: @escaping CMAccelerometerHandler) {

        accelerometerHandler = handler

    }

    func startDeviceMotionUpdates(using referenceFrame: CMAttitudeReferenceFrame,
                                  to queue: OperationQueue,
                                  withHandler handler: @escaping CMDeviceMotionHandler) {

        deviceMotionHandler = handler

    }

    func startGyroUpdates(to queue: OperationQueue,
                          withHandler handler: @escaping CMGyroHandler) {

        gyroscopeHandler = handler

    }

    func startMagnetometerUpdates(to queue: OperationQueue,
                                  withHandler handler: @escaping CMMagnetometerHandler) {

        magnetometerHandler = handler

    }

    func stopAccelerometerUpdates() {

        accelerometerHandler = nil

    }

    func stopDeviceMotionUpdates() {

        deviceMotionHandler = nil

    }

    func stopGyroUpdates() {

        gyroscopeHandler = nil

    }

    func stopMagnetometerUpdates() {

        magnetometerHandler = nil

    }

    private var accelerometerHandler: CMAccelerometerHandler?
    private var deviceMotionHandler: CMDeviceMotionHandler?
    private var gyroscopeHandler: CMGyroHandler?
    private var magnetometerHandler: CMMagnetometerHandler?

    // MARK: -

    func updateAccelerometer(available: Bool) {

        isAccelerometerAvailable = available

    }

    func updateAccelerometer(data: CMAccelerometerData?) {

        accelerometerData = data

        if let handler = accelerometerHandler {
            handler(data, nil)
        }

    }

    func updateAccelerometer(error: Error) {

        accelerometerData = nil

        if let handler = accelerometerHandler {
            handler(nil, error)
        }

    }

    func updateDeviceMotion(available: Bool) {

        isDeviceMotionAvailable = available

    }

    func updateDeviceMotion(data: CMDeviceMotion?) {

        deviceMotion = data

        if let handler = deviceMotionHandler {
            handler(data, nil)
        }

    }

    func updateDeviceMotion(error: Error) {

        deviceMotion = nil

        if let handler = deviceMotionHandler {
            handler(nil, error)
        }

    }

    func updateGyroscope(available: Bool) {

        isGyroAvailable = available

    }

    func updateGyroscope(data: CMGyroData?) {

        gyroData = data

        if let handler = gyroscopeHandler {
            handler(data, nil)
        }

    }

    func updateGyroscope(error: Error) {

        gyroData = nil

        if let handler = gyroscopeHandler {
            handler(nil, error)
        }

    }

    func updateMagnetometer(available: Bool) {

        isMagnetometerAvailable = available

    }

    func updateMagnetometer(data: CMMagnetometerData?) {

        magnetometerData = data

        if let handler = magnetometerHandler {
            handler(data, nil)
        }

    }

    func updateMagnetometer(error: Error) {

        magnetometerData = nil

        if let handler = magnetometerHandler {
            handler(nil, error)
        }

    }

}
