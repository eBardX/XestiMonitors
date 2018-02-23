//
//  OtherDetailViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

public class OtherDetailViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Private Instance Properties

    @IBOutlet private weak var networkReachabilityLabel: UILabel!

    private lazy var networkReachabilityMonitor = NetworkReachabilityMonitor(queue: .main) { [unowned self] in
        self.displayNetworkReachability($0)
    }

    private lazy var monitors: [Monitor] = [self.networkReachabilityMonitor]

    // MARK: Private Instance Methods

    private func displayNetworkReachability(_ event: NetworkReachabilityMonitor.Event?) {
        if let event = event,
            case let .statusDidChange(status) = event {
            switch status {
            case .notReachable:
                networkReachabilityLabel.text = "Not reachable"

            case .reachableViaWiFi:
                networkReachabilityLabel.text = "Reachable via Wi-Fi"

            default :
                networkReachabilityLabel.text = "Unknown"
            }
        } else {
            networkReachabilityLabel.text = "Unknown"
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayNetworkReachability(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        monitors.forEach { $0.startMonitoring() }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        monitors.forEach { $0.stopMonitoring() }

        super.viewWillDisappear(animated)
    }
}
