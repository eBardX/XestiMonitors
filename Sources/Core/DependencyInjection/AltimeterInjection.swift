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

internal protocol AltimeterProtocol: AnyObject {
    static func isRelativeAltitudeAvailable() -> Bool

    func startRelativeAltitudeUpdates(to queue: OperationQueue,
                                      withHandler handler: @escaping CMAltitudeHandler)

    func stopRelativeAltitudeUpdates()
}

extension CMAltimeter: AltimeterProtocol {}

internal enum AltimeterInjector {
    internal static var inject: () -> AltimeterProtocol = { CMAltimeter() }
}

#endif
