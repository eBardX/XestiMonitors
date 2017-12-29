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

    init(applicationState: UIApplicationState = .active,
         backgroundRefreshStatus: UIBackgroundRefreshStatus = .restricted,
         statusBarFrame: CGRect = .zero,
         statusBarOrientation: UIInterfaceOrientation = .unknown) {

        self.applicationState = applicationState
        self.backgroundRefreshStatus = backgroundRefreshStatus
        self.statusBarFrame = statusBarFrame
        self.statusBarOrientation = statusBarOrientation

    }

    var applicationState: UIApplicationState
    var backgroundRefreshStatus: UIBackgroundRefreshStatus
    var statusBarFrame: CGRect
    var statusBarOrientation: UIInterfaceOrientation

}
