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

internal class MockProcessInfo: ProcessInfoProtocol {
    init() {
        self.rawThermalState = 0
    }

    @available(iOS 11.0, OSX 10.10.3, tvOS 11.0, watchOS 4.0, *)
    var thermalState: ProcessInfo.ThermalState {
        guard
            let state = ProcessInfo.ThermalState(rawValue: rawThermalState)
            else { return .nominal }

        return state
    }

    // MARK: -

    var rawThermalState: Int
}
