//
//  ApplicationInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-29.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import UIKit

internal protocol ApplicationProtocol: AnyObject {
    var applicationState: UIApplicationState { get }

    #if os(iOS)
    var backgroundRefreshStatus: UIBackgroundRefreshStatus { get }
    #endif

    var isProtectedDataAvailable: Bool { get }

    var preferredContentSizeCategory: UIContentSizeCategory { get }

    #if os(iOS)
    var statusBarFrame: CGRect { get }

    var statusBarOrientation: UIInterfaceOrientation { get }
    #endif
}

extension UIApplication: ApplicationProtocol {}

internal enum ApplicationInjector {
    internal static var inject: () -> ApplicationProtocol = { UIApplication.shared }
}

#endif
