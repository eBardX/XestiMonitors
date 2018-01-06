//
//  ApplicationInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-29.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit

internal protocol Application: class {
    var applicationState: UIApplicationState { get }

    var backgroundRefreshStatus: UIBackgroundRefreshStatus { get }

    var isProtectedDataAvailable: Bool { get }

    var statusBarFrame: CGRect { get }

    var statusBarOrientation: UIInterfaceOrientation { get }
}

extension UIApplication: Application {}

internal protocol ApplicationInjected {}

internal struct ApplicationInjector {
    static var application: Application = UIApplication.shared
}

internal extension ApplicationInjected {
    var application: Application { return ApplicationInjector.application }
}
