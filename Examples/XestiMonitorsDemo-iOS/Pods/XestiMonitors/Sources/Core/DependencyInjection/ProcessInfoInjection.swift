//
//  ProcessInfoInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

internal protocol ProcessInfoProtocol: class {
    #if os(iOS) || os(tvOS) || os(watchOS)
    var isLowPowerModeEnabled: Bool { get }
    #endif

    @available(iOS 11.0, OSX 10.10.3, tvOS 11.0, watchOS 4.0, *)
    var thermalState: ProcessInfo.ThermalState { get }
}

extension ProcessInfo: ProcessInfoProtocol {}

internal struct ProcessInfoInjector {
    internal static var inject: () -> ProcessInfoProtocol = { return ProcessInfo.processInfo }
}
