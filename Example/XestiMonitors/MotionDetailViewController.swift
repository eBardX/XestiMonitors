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

    lazy var accelerometerMonitor: AccelerometerMonitor = AccelerometerMonitor(updateInterval: 0.2) { [weak self] in

        self?.displayAccelerometer($0)

    }

    lazy var monitors: [Monitor] = [self.accelerometerMonitor]

    // MARK: -

    private func displayAccelerometer(_ info: AccelerometerMonitor.Info) {

        switch info {

        case let .data(data):
            accelerometerAccelerationLabel.text = "[\(data.acceleration.x), \(data.acceleration.y), \(data.acceleration.z)]"

            accelerometerOrientationLabel.text = formatDeviceOrientation(data.acceleration.deviceOrientation)

            accelerometerTimestampLabel.text = "\(data.timestamp)"
            accelerometerTimestampLabel.textColor = UIColor.black

        case let .error(error):
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

    private func formatDeviceOrientation(_ orientation: UIDeviceOrientation) -> String {

        switch orientation {

        case .faceDown:
            return "Face down"

        case .faceUp:
            return "Face up"

        case .landscapeLeft:
            return "Landscape left"

        case .landscapeRight:
            return "Landscape right"

        case .portrait:
            return "Portrait"

        case .portraitUpsideDown:
            return "Portrait upside down"

        default:
            return "Unknown"

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
