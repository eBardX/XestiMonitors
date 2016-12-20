//
//  MotionDetailViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-18.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import UIKit
import XestiMonitors

class MotionDetailViewController: UITableViewController {

    @IBOutlet weak var accelerometerAccelerationLabel: UILabel!
    @IBOutlet weak var accelerometerOrientationLabel: UILabel!
    @IBOutlet weak var accelerometerTimestampLabel: UILabel!

    lazy var accelerometerMonitor: AccelerometerMonitor = AccelerometerMonitor(updateInterval: 0.25) { [weak self] in

        self?.displayAccelerometer($0)

    }

    lazy var monitors: [Monitor] = [self.accelerometerMonitor]

    // MARK: -

    private func displayAccelerometer(_ info: AccelerometerMonitor.Info) {

        switch info {

        case .data(let data):
            accelerometerAccelerationLabel.text = formatAcceleration(data.acceleration)

            accelerometerOrientationLabel.text = formatDeviceOrientation(data.acceleration.deviceOrientation)

            accelerometerTimestampLabel.text = formatTimeInterval(data.timestamp)
            accelerometerTimestampLabel.textColor = UIColor.black

        case .error(let error):
            accelerometerAccelerationLabel.text = " "

            accelerometerOrientationLabel.text = " "

            accelerometerTimestampLabel.text = error.localizedDescription
            accelerometerTimestampLabel.textColor = UIColor.red

        case .unknown:
            accelerometerAccelerationLabel.text = " "

            accelerometerOrientationLabel.text = " "

            accelerometerTimestampLabel.text = "Unknown"
            accelerometerTimestampLabel.textColor = UIColor.gray

        }
    }

    // MARK: -

    override func viewDidLoad() {

        super.viewDidLoad()

        displayAccelerometer(.unknown)

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
