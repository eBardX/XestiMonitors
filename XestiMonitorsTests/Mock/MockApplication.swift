//
//  MockApplication.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit

internal class MockApplication: UIApplication {

    init(applicationState: UIApplicationState = .active,
         backgroundRefreshStatus: UIBackgroundRefreshStatus = .available,
         statusBarFrame: CGRect = .zero,
         statusBarOrientation: UIInterfaceOrientation = .unknown) {

        self.mockApplicationState = applicationState
        self.mockBackgroundRefreshStatus = backgroundRefreshStatus
        self.mockStatusBarFrame = statusBarFrame
        self.mockStatusBarOrientation = statusBarOrientation

    }

    private var mockApplicationState: UIApplicationState
    private var mockBackgroundRefreshStatus: UIBackgroundRefreshStatus
    private var mockStatusBarFrame: CGRect
    private var mockStatusBarOrientation: UIInterfaceOrientation

    override var applicationState: UIApplicationState {
        get { return mockApplicationState }
        set { mockApplicationState = newValue }
    }

    override var backgroundRefreshStatus: UIBackgroundRefreshStatus {
        get { return mockBackgroundRefreshStatus }
        set { mockBackgroundRefreshStatus = newValue }
    }

    override var statusBarFrame: CGRect {
        get { return mockStatusBarFrame }
        set { mockStatusBarFrame = newValue }
    }

    override var statusBarOrientation: UIInterfaceOrientation {
        get { return mockStatusBarOrientation }
        set { mockStatusBarOrientation = newValue }
    }

}
