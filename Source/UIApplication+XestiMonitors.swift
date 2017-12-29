//
//  UIApplication+XestiMonitors.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-29.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit

public protocol Application {

    var applicationState: UIApplicationState { get }

    var backgroundRefreshStatus: UIBackgroundRefreshStatus { get }

    var statusBarFrame: CGRect { get }

    var statusBarOrientation: UIInterfaceOrientation { get }

}

extension UIApplication: Application {}
