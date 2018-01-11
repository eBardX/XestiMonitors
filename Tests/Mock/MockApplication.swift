//
//  MockApplication.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
@testable import XestiMonitors

internal class MockApplication: ApplicationProtocol {
    init() {
        self.applicationState = .inactive
        #if os(iOS)
            self.backgroundRefreshStatus = .restricted
        #endif
        self.isProtectedDataAvailable = false
        #if os(iOS)
            self.statusBarFrame = .zero
            self.statusBarOrientation = .unknown
        #endif
    }

    var applicationState: UIApplicationState
    #if os(iOS)
    var backgroundRefreshStatus: UIBackgroundRefreshStatus
    #endif
    var isProtectedDataAvailable: Bool
    #if os(iOS)
    var statusBarFrame: CGRect
    var statusBarOrientation: UIInterfaceOrientation
    #endif
}
