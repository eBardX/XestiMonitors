//
//  ScreenDetailViewController.swift
//  XestiMonitorsDemo
//
//  Created by Paul Nyondo on 2018-03-23.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

import UIKit
import XestiMonitors

public class ScreenDetailViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var brightnessLevelLabel: UILabel!

    private lazy var screenBrightnessMonitor =
        ScreenBrightnessMonitor(screen: .main,
                                queue: .main) { [unowned self] in
                                    self.displayScreenBrightness($0)
    }

    private lazy var monitors: [Monitor] = [self.screenBrightnessMonitor]

    // MARK: Private Instance Methods

    private func displayScreenBrightness(_ event: ScreenBrightnessMonitor.Event?) {
        if let event = event,
            case let .didChange(screen) = event {
            brightnessLevelLabel.text = formatPercentage(Float(screen.brightness))
        } else {
            brightnessLevelLabel.text = formatPercentage(Float(UIScreen.main.brightness))
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayScreenBrightness(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        monitors.forEach { $0.startMonitoring() }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        monitors.forEach { $0.stopMonitoring() }
    }
}
