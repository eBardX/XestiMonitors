//
//  DeviceDetailViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

class DeviceDetailViewController: UITableViewController {

    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var orientationLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!

    lazy var batteryMonitor: BatteryMonitor = { BatteryMonitor { self.displayBattery($0) } }()

    lazy var orientationMonitor: OrientationMonitor = { OrientationMonitor { self.displayOrientation($0) } }()

    lazy var proximityMonitor: ProximityMonitor = { ProximityMonitor { self.displayProximity($0) } }()

    lazy var monitors: [Monitor] = { [self.batteryMonitor,
                                      self.orientationMonitor,
                                      self.proximityMonitor] }()

    // MARK: -

    private func displayBattery(_ event: BatteryMonitor.Event) {

        switch event {

        case let .levelDidChange(level):
            displayBattery(self.batteryMonitor.state, level)

        case let .stateDidChange(state):
            displayBattery(state, self.batteryMonitor.level)

        }

    }

    private func displayBattery(_ state: UIDeviceBatteryState,
                                _ level: Float) {

        var text: String

        switch state {

        case .charging:
            text = "Charging \(level * 100)%"

        case .full:
            text = "Full"

        case .unplugged:
            text = "Unplugged \(level * 100)%"

        default:
            text = "Unknown"

        }

        batteryLabel.text = text

    }

    private func displayOrientation(_ orientation: UIDeviceOrientation) {

        var text: String

        switch orientation {

        case .faceDown:
            text = "Face down"

        case .faceUp:
            text = "Face up"

        case .landscapeLeft:
            text = "Landscape left"

        case .landscapeRight:
            text = "Landscape right"

        case .portrait:
            text = "Portrait"

        case .portraitUpsideDown:
            text = "Portrait upside down"

        default:
            text = "Unknown"

        }

        orientationLabel.text = text

    }

    private func displayProximity(_ state: Bool) {

        proximityLabel.text = !ProximityMonitor.isAvailable ? "N/A" :
            state ? "Close" : "Not close"

    }

    // MARK: -

    override func viewDidLoad() {

        super.viewDidLoad()

        displayBattery(batteryMonitor.state,
                       batteryMonitor.level)

        displayOrientation(orientationMonitor.orientation)

        displayProximity(proximityMonitor.state)

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        monitors.forEach { $0.beginMonitoring() }

    }

    override func viewWillDisappear(_ animated: Bool) {

        monitors.forEach { $0.endMonitoring() }

        super.viewWillDisappear(animated)

    }

}
