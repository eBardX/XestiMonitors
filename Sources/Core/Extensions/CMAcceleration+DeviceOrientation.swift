//
//  CMAccelerometerData+DeviceOrientation.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-16.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)
    
    import CoreMotion
    import UIKit
    
    public extension CMAcceleration {
        ///
        /// Returns the device orientation as calculated from the 3-axis
        /// acceleration data.
        ///
        /// This property allows you to determine the physical orientation of the
        /// device from an acceleration measurement provided by an
        /// `AccelerometerMonitor` instance. There is one important case where you
        /// might choose to use this technique rather than directly monitor device
        /// orientation changes with an `OrientationMonitor` instance—when rotation
        /// is locked on the device.
        ///
        var deviceOrientation: UIDeviceOrientation {
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
            
            return .unknown
        }
    }
    
#endif
