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
    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var brightnessLevel: UILabel!

    @IBAction private func changeBrightness(_ sender: UISlider) {
        mainScreen.brightness = CGFloat(sender.value)
    }

    private let mainScreen: UIScreen = .main

    private lazy var screenBrightnessMonitor =
        ScreenBrightnessMonitor(screen: mainScreen,
                                queue: .main) { [unowned self] in
                                self.displayScreenBrightness($0)
        }

    private lazy var monitors: [Monitor] = [self.screenBrightnessMonitor]

    override public func viewDidLoad() {
        super.viewDidLoad()

        brightnessSlider.value = Float(mainScreen.brightness)

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

    private func displayScreenBrightness(_ event: ScreenBrightnessMonitor.Event?) {
        if let event = event,
            case let .didChange(screen) = event {
            brightnessLevel.text = formatPercentage(Float(screen.brightness))

            brightnessSlider.value = Float(screen.brightness)
        } else {
            brightnessLevel.text = formatPercentage(Float(mainScreen.brightness))
        }
    }
    }
