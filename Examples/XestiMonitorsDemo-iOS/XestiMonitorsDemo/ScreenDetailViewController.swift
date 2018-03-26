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

class ScreenDetailViewController: UITableViewController {

    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var brightnessAction: UILabel!

    @IBAction func changeBrightness(_ sender: UISlider) {
        mainScreen.brightness = CGFloat(sender.value)
    }
    
    private let mainScreen: UIScreen = .main
    
    private lazy var screenBrightnessMonitor =
        ScreenBrightnessMonitor(screen: mainScreen,
                                queue: .main){ [unowned self] in
                                    self.displayScreenBrightness($0)
    }
    
    private lazy var monitors: [Monitor] = [self.screenBrightnessMonitor]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        brightnessSlider.value = Float(mainScreen.brightness)

        displayScreenBrightness(nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        monitors.forEach {$0.startMonitoring() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        monitors.forEach { $0.stopMonitoring() }
    }
    
    private func displayScreenBrightness(_ event: ScreenBrightnessMonitor.Event?) {
        if let event = event,
            case let .didChange(screen) = event {
            brightnessAction.text = formatPercentage(Float(screen.brightness))
        } else {
            brightnessAction.text = formatPercentage(Float(mainScreen.brightness))
        }
    }
    }
