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

    lazy var batteryMonitor: BatteryMonitor = BatteryMonitor { [weak self] in

        self?.displayBattery($0)

    }

    lazy var orientationMonitor: OrientationMonitor = OrientationMonitor { [weak self] in

        self?.displayOrientation($0)

    }

    lazy var proximityMonitor: ProximityMonitor = ProximityMonitor { [weak self] in

        self?.displayProximity($0)

    }

    lazy var monitors: [Monitor] = [self.batteryMonitor,
                                    self.orientationMonitor,
                                    self.proximityMonitor]

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

        batteryLabel.text = formatDeviceBatteryStateAndLevel(state, level)

    }

    private func displayOrientation(_ orientation: UIDeviceOrientation) {

        orientationLabel.text = formatDeviceOrientation(orientation)

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

        monitors.forEach { $0.startMonitoring() }

    }

    override func viewWillDisappear(_ animated: Bool) {

        monitors.forEach { $0.stopMonitoring() }

        super.viewWillDisappear(animated)

    }

}
