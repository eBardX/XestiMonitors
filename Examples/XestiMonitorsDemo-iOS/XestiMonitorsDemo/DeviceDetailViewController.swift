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

public class DeviceDetailViewController: UITableViewController {
    @IBOutlet private weak var batteryLabel: UILabel!
    @IBOutlet private weak var orientationLabel: UILabel!
    @IBOutlet private weak var proximityLabel: UILabel!

    private lazy var batteryMonitor = BatteryMonitor(options: .all,
                                                     queue: .main) { [unowned self] in
        self.displayBattery($0)
    }

    private lazy var orientationMonitor = OrientationMonitor(queue: .main) { [unowned self] in
        self.displayOrientation($0)
    }

    private lazy var proximityMonitor = ProximityMonitor(queue: .main) { [unowned self] in
        self.displayProximity($0)
    }

    private lazy var monitors: [Monitor] = [self.batteryMonitor,
                                            self.orientationMonitor,
                                            self.proximityMonitor]

    // MARK: Private Instance Methods

    private func displayBattery(_ event: BatteryMonitor.Event?) {
        if let event = event {
            switch event {
            case let .levelDidChange(level):
                batteryLabel.text = formatDeviceBatteryStateAndLevel(batteryMonitor.state,
                                                                     level)

            case let .stateDidChange(state):
                batteryLabel.text = formatDeviceBatteryStateAndLevel(state,
                                                                     batteryMonitor.level)
            }
        } else {
            batteryLabel.text = formatDeviceBatteryStateAndLevel(batteryMonitor.state,
                                                                 batteryMonitor.level)
        }
    }

    private func displayOrientation(_ event: OrientationMonitor.Event?) {
        if let event = event,
            case let .didChange(orientation) = event {
            orientationLabel.text = formatDeviceOrientation(orientation)
        } else {
            orientationLabel.text = formatDeviceOrientation(orientationMonitor.orientation)
        }
    }

    private func displayProximity(_ event: ProximityMonitor.Event?) {
        if !proximityMonitor.isAvailable {
            proximityLabel.text = formatDeviceProximityState(nil)
        } else if let event = event,
            case let .stateDidChange(state) = event {
            proximityLabel.text = formatDeviceProximityState(state)
        } else {
            proximityLabel.text = formatDeviceProximityState(proximityMonitor.state)
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayBattery(nil)
        displayOrientation(nil)
        displayProximity(nil)
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
