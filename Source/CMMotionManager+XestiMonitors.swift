//
//  CMMotionManager+XestiMonitors.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-16.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion

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
