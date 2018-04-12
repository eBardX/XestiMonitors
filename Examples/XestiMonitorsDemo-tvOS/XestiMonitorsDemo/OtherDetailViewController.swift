//
//  OtherDetailViewController.swift
//  XestiMonitorsDemo-tvOS
//
//  Created by J. G. Pusey on 2018-01-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

public class OtherDetailViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Private Instance Properties

    @IBOutlet private weak var focusActionLabel: UILabel!
    @IBOutlet private weak var focusHeadingLabel: UILabel!
    @IBOutlet private weak var focusNextItemLabel: UILabel!
    @IBOutlet private weak var focusPrevItemLabel: UILabel!
    @IBOutlet private weak var networkReachabilityLabel: UILabel!

    @available(tvOS 11.0, *)
    private lazy var focusMonitor = FocusMonitor(queue: .main) { [unowned self] in
        self.displayFocus($0)
    }

    private lazy var networkReachabilityMonitor = NetworkReachabilityMonitor(queue: .main) { [unowned self] in
        self.displayNetworkReachability($0)
    }

    @available(tvOS 11.0, *)
    private lazy var monitors: [Monitor] = [focusMonitor,
                                            networkReachabilityMonitor]

    private lazy var oldMonitors: [Monitor] = [networkReachabilityMonitor]

    // MARK: Private Instance Methods

    @available(tvOS 11.0, *)
    private func displayFocus(_ event: FocusMonitor.Event?) {
        if let event = event {
            switch event {
            case let .didUpdate(info):
                displayFocus("Did update", info)

            case let .movementDidFail(info):
                displayFocus("Movement did fail", info)
            }
        } else {
            displayFocus(" ", nil)
        }
    }

    @available(tvOS 11.0, *)
    private func displayFocus(_ action: String,
                              _ info: FocusMonitor.Info?) {
        focusActionLabel.text = action

        if let info = info {
            let context = info.updateContext

            focusHeadingLabel.text = formatFocusHeading(context.focusHeading)

            if let item = context.nextFocusedItem {
                focusNextItemLabel.text = formatFocusItem(item)
            } else {
                focusNextItemLabel.text = " "
            }

            if let item = context.previouslyFocusedItem {
                focusPrevItemLabel.text = formatFocusItem(item)
            } else {
                focusPrevItemLabel.text = " "
            }
        } else {
            focusHeadingLabel.text = " "

            focusNextItemLabel.text = " "

            focusPrevItemLabel.text = " "
        }
    }

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

        if #available(tvOS 11.0, *) {
            displayFocus(nil)
        }

        displayNetworkReachability(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(tvOS 11.0, *) {
            monitors.forEach { $0.startMonitoring() }
        } else {
            oldMonitors.forEach { $0.startMonitoring() }
        }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        if #available(tvOS 11.0, *) {
            monitors.forEach { $0.stopMonitoring() }
        } else {
            oldMonitors.forEach { $0.stopMonitoring() }
        }

        super.viewWillDisappear(animated)
    }
}
