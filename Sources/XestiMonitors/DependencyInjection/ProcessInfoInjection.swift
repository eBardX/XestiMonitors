// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

internal protocol ProcessInfoProtocol {
    var isLowPowerModeEnabled: Bool { get }

    var thermalState: ProcessInfo.ThermalState { get }
}

// MARK: -

extension ProcessInfo: ProcessInfoProtocol {}

// MARK: -

internal enum ProcessInfoInjector {
    internal static var inject: () -> any ProcessInfoProtocol = { ProcessInfo.processInfo }
}
