//
//  AppDelegate.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import UIKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    public var window: UIWindow?

    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard
            let svc = self.window?.rootViewController as? UISplitViewController
            else { return false }

        svc.delegate = self
        svc.preferredDisplayMode = .allVisible

        guard
            let nc = svc.viewControllers[svc.viewControllers.count - 1] as? UINavigationController
            else { return false }

        nc.topViewController?.navigationItem.leftBarButtonItem = svc.displayModeButtonItem

        return true

    }

    public func applicationDidBecomeActive(_ application: UIApplication) {

    }

    public func applicationDidEnterBackground(_ application: UIApplication) {

    }

    public func applicationWillEnterForeground(_ application: UIApplication) {

    }

    public func applicationWillResignActive(_ application: UIApplication) {

    }

    public func applicationWillTerminate(_ application: UIApplication) {

    }

    // UISplitViewControllerDelegate Methods

    public func targetDisplayModeForAction(in splitViewController: UISplitViewController) -> UISplitViewControllerDisplayMode {

        return .allVisible

    }

}
