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

internal class MockApplication: Application {
    init() {
        self.applicationState = .inactive
        self.backgroundRefreshStatus = .restricted
        self.statusBarFrame = .zero
        self.statusBarOrientation = .unknown
    }

    var applicationState: UIApplicationState
    var backgroundRefreshStatus: UIBackgroundRefreshStatus
    var statusBarFrame: CGRect
    var statusBarOrientation: UIInterfaceOrientation
}
