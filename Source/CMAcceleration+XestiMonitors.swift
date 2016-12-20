//
//  CMAccelerometerData+XestiMonitors.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-16.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import UIKit

///
///
///
extension CMAcceleration {

    ///
    ///
    ///
    public var deviceOrientation: UIDeviceOrientation {

        if z > 0.8 {
            return .faceDown
        }

        if z < -0.8 {
            return .faceUp
        }

        let angle = atan2(y, -x)

        if (angle >= -2.0) && (angle <= -1.0) {
            return .portrait
        }

        if (angle >= -0.5) && (angle <= 0.5) {
            return .landscapeLeft
        }

        if (angle >= 1.0) && (angle <= 2.0) {
            return .portraitUpsideDown
        }

        if (angle <= -2.5) || (angle >= 2.5) {
            return .landscapeRight
        }

        return .unknown;

    }

}
