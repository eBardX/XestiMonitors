// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import XestiMonitors

internal class MockProcessInfo: ProcessInfoProtocol {
    init() {
        self.isLowPowerModeEnabled = false
        self.rawThermalState = 0
    }

    var isLowPowerModeEnabled: Bool

    var thermalState: ProcessInfo.ThermalState {
        guard let state = ProcessInfo.ThermalState(rawValue: rawThermalState)
        else { return .nominal }

        return state
    }

    // MARK: -

    var rawThermalState: Int
}
