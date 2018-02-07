//
//  AltimeterInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-30.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(watchOS)

    import CoreMotion

    internal protocol AltimeterProtocol: class {
        static func isRelativeAltitudeAvailable() -> Bool

        func startRelativeAltitudeUpdates(to queue: OperationQueue,
                                          withHandler handler: @escaping CMAltitudeHandler)

        func stopRelativeAltitudeUpdates()
    }

    extension CMAltimeter: AltimeterProtocol {}

    internal struct AltimeterInjector {
        internal static var inject: () -> AltimeterProtocol = { return CMAltimeter() }
    }

#endif
