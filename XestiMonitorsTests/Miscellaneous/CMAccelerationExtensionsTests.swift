//
//  CMAccelerationExtensionsTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-01-05.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import XCTest
@testable import XestiMonitors

internal class CMAccelerationExtensionsTests: XCTestCase {

    func testDeviceOrientation() {

        let accelerations: [(CMAcceleration, UIDeviceOrientation)] = [
            (.init(x: 0.094, y: -0.401, z: 0.961), .faceDown),
            (.init(x: 0.014, y: -0.545, z: -0.872), .faceUp),
            (.init(x: -0.672, y: -0.007, z: -0.686), .landscapeLeft),
            (.init(x: 0.627, y: -0.029, z: -0.775), .landscapeRight),
            (.init(x: 0.017, y: -0.911, z: -0.565), .portrait),
            (.init(x: -0.058, y: 0.926, z: -0.352), .portraitUpsideDown),
            (.init(x: -0.722, y: -0.644, z: -0.409), .unknown)]

        accelerations.forEach {
            XCTAssertEqual($0.deviceOrientation, $1)
        }

    }

}
