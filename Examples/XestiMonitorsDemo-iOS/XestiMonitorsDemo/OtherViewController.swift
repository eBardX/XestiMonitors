//
//  OtherViewController.swift
//  XestiMonitorsDemo-iOS
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import XestiMonitors

public class OtherViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var networkReachabilityLabel: UILabel!

    private lazy var networkReachabilityMonitor = NetworkReachabilityMonitor(queue: .main) { [unowned self] in
        self.displayNetworkReachability($0)
    }

    private lazy var monitors: [Monitor] = [networkReachabilityMonitor]

    // MARK: Private Instance Methods

    private func displayNetworkReachability(_ event: NetworkReachabilityMonitor.Event?) {
        if let event = event,
            case let .statusDidChange(status) = event {
            switch status {
            case .notReachable:
                networkReachabilityLabel.text = "Not reachable"

            case .reachableViaWiFi:
                networkReachabilityLabel.text = "Reachable via Wi-Fi"

            case .reachableViaWWAN:
                networkReachabilityLabel.text = "Reachable via WWAN"

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

    // MARK: - UITextFieldDelegate

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = ""

        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }

        return false
    }
}
