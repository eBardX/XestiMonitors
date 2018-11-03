//
//  AppDelegate.swift
//  XestiMonitorsDemo-tvOS
//
//  Created by J. G. Pusey on 2018-01-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    // MARK: Public Instance Properties

    public var window: UIWindow?

    // MARK: UIApplicationDelegate Methods

    public func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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

    // MARK: UISplitViewControllerDelegate Methods

    public func targetDisplayModeForAction(in splitViewController: UISplitViewController) -> UISplitViewController.DisplayMode {
        return .allVisible
    }
}
