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
        if #available(iOS 10.0, tvOS 10.0, *) {
            self.preferredContentSizeCategory = .unspecified
        } else {
            self.preferredContentSizeCategory = .medium
        }
        #if os(iOS)
        self.statusBarFrame = .zero
        self.statusBarOrientation = .unknown
        #endif
    }

    var applicationState: UIApplication.State
    #if os(iOS)
    var backgroundRefreshStatus: UIBackgroundRefreshStatus
    #endif
    var isProtectedDataAvailable: Bool
    var preferredContentSizeCategory: UIContentSizeCategory
    #if os(iOS)
    var statusBarFrame: CGRect
    var statusBarOrientation: UIInterfaceOrientation
    #endif
}
