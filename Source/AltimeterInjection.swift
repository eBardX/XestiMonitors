//
//  AltimeterInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-30.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion

internal protocol Altimeter: class {
    static func isRelativeAltitudeAvailable() -> Bool

    func startRelativeAltitudeUpdates(to queue: OperationQueue,
                                      withHandler handler: @escaping CMAltitudeHandler)

    func stopRelativeAltitudeUpdates()
}

extension CMAltimeter: Altimeter {}

internal protocol AltimeterInjected {}

internal struct AltimeterInjector {
    static var altimeter: Altimeter = CMAltimeter()
}

internal extension AltimeterInjected {
    var altimeter: Altimeter { return AltimeterInjector.altimeter }
}
