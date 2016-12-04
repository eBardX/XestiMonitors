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
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let svc = self.window!.rootViewController as? UISplitViewController else { return false }

        svc.delegate = self
        svc.preferredDisplayMode = .allVisible

        guard let nc = svc.viewControllers[svc.viewControllers.count - 1] as? UINavigationController else { return false }

        nc.topViewController!.navigationItem.leftBarButtonItem = svc.displayModeButtonItem

        return true

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

    // UISplitViewControllerDelegate Methods

    //func splitViewController(_ splitViewController: UISplitViewController,
    //                         collapseSecondary secondaryViewController: UIViewController,
    //                         onto primaryViewController: UIViewController) -> Bool {
    //
    //    guard let nc = secondaryViewController as? UINavigationController else { return false }
    //    guard let vc = nc.topViewController as? DetailViewController else { return false }
    //
    //    if vc.detailItem == nil {
    //        return true
    //    }
    //
    //    return false
    //
    //}

    func targetDisplayModeForAction(in splitViewController: UISplitViewController) -> UISplitViewControllerDisplayMode {

        return .allVisible

    }

}
