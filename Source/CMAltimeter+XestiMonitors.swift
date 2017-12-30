//
//  CMAltimeter+XestiMonitors.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-30.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion

public protocol Altimeter: class {

    static func isRelativeAltitudeAvailable() -> Bool

    func startRelativeAltitudeUpdates(to queue: OperationQueue,
                                      withHandler handler: @escaping CMAltitudeHandler)

    func stopRelativeAltitudeUpdates()

}

extension CMAltimeter: Altimeter {}
