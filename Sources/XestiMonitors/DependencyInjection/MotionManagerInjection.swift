// © 2016–2025 John Gary Pusey (see LICENSE.md)

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

// MARK: -

extension CMMotionManager: MotionManagerProtocol {}

// MARK: -

extension Dependencies {
    internal static let motionManagerInjected = {
        DependencyResolver.register(CMMotionManager() as any MotionManagerProtocol)
    }()
}

#endif
