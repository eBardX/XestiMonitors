//
//  MockProcessInfo.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
@testable import XestiMonitors

@available(iOS 11.0, OSX 10.10.3, tvOS 11.0, watchOS 4.0, *)
internal class MockProcessInfo: ProcessInfoProtocol {
    init() {
        self.thermalState = .nominal
    }

    var thermalState: ProcessInfo.ThermalState
}
