// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    // MARK: Public Instance Properties
    
    public var window: UIWindow?
    
    // MARK: UIApplicationDelegate Methods
    
    public func app(_ app: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let svc = self.window?.rootViewController as? UISplitViewController
        else { return false }
        
        svc.delegate = self
        svc.preferredDisplayMode = .allVisible
        
        guard let nc = svc.viewControllers[svc.viewControllers.count - 1] as? UINavigationController
        else { return false }
        
        nc.topViewController?.navigationItem.leftBarButtonItem = svc.displayModeButtonItem
        
        return true
    }
    
    public func applicationDidBecomeActive(_ app: UIApplication) {
    }
    
    public func applicationDidEnterBackground(_ app: UIApplication) {
    }
    
    public func applicationWillEnterForeground(_ app: UIApplication) {
    }
    
    public func applicationWillResignActive(_ app: UIApplication) {
    }
    
    public func applicationWillTerminate(_ app: UIApplication) {
    }
    
    // MARK: UISplitViewControllerDelegate Methods
    
    public func targetDisplayModeForAction(in splitViewController: UISplitViewController) -> UISplitViewController.DisplayMode {
        return .allVisible
    }
}
