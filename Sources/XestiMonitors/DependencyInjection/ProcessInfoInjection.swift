// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

internal protocol ProcessInfoProtocol {
    var isLowPowerModeEnabled: Bool { get }

    var thermalState: ProcessInfo.ThermalState { get }
}

// MARK: -

extension ProcessInfo: ProcessInfoProtocol {}

// MARK: -

extension Dependencies {
    internal static let processInfoInjected = {
        DependencyResolver.register(ProcessInfo.processInfo as any ProcessInfoProtocol)
    }()
}
