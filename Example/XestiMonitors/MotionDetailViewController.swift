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
    @IBOutlet weak var deviceMotionAttitudeLabel: UILabel!
    @IBOutlet weak var deviceMotionGravityLabel: UILabel!
    @IBOutlet weak var deviceMotionMagneticFieldLabel: UILabel!
    @IBOutlet weak var deviceMotionRotationRateLabel: UILabel!
    @IBOutlet weak var deviceMotionTimestampLabel: UILabel!
    @IBOutlet weak var deviceMotionUserAccelerationLabel: UILabel!
    @IBOutlet weak var gyroRotationRateLabel: UILabel!
    @IBOutlet weak var gyroTimestampLabel: UILabel!
    @IBOutlet weak var magnetometerMagneticFieldLabel: UILabel!
    @IBOutlet weak var magnetometerTimestampLabel: UILabel!

    lazy var accelerometerMonitor: AccelerometerMonitor = AccelerometerMonitor(interval: 0.25) { [weak self] in

        self?.displayAccelerometer($0)

    }

    lazy var deviceMotionMonitor: DeviceMotionMonitor = DeviceMotionMonitor(interval: 0.25) { [weak self] in

        self?.displayDeviceMotion($0)

    }

    lazy var gyroMonitor: GyroMonitor = GyroMonitor(interval: 0.25) { [weak self] in

        self?.displayGyro($0)

    }

    lazy var magnetometerMonitor: MagnetometerMonitor = MagnetometerMonitor(interval: 0.25) { [weak self] in

        self?.displayMagnetometer($0)

    }

    lazy var monitors: [Monitor] = [self.accelerometerMonitor,
                                    self.deviceMotionMonitor,
                                    self.gyroMonitor,
                                    self.magnetometerMonitor]

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

    private func displayDeviceMotion(_ info: DeviceMotionMonitor.Info) {

        switch info {

        case .data(let data):
            deviceMotionAttitudeLabel.text = formatAttitude(data.attitude)

            deviceMotionGravityLabel.text = formatAcceleration(data.gravity)

            deviceMotionMagneticFieldLabel.text = formatMagneticField(data.magneticField)

            deviceMotionRotationRateLabel.text = formatRotationRate(data.rotationRate)

            deviceMotionTimestampLabel.text = formatTimeInterval(data.timestamp)
            deviceMotionTimestampLabel.textColor = UIColor.black

            deviceMotionUserAccelerationLabel.text = formatAcceleration(data.userAcceleration)

        case .error(let error):
            deviceMotionAttitudeLabel.text = " "

            deviceMotionGravityLabel.text = " "

            deviceMotionMagneticFieldLabel.text = " "

            deviceMotionRotationRateLabel.text = " "

            deviceMotionTimestampLabel.text = error.localizedDescription
            deviceMotionTimestampLabel.textColor = UIColor.red

            deviceMotionUserAccelerationLabel.text = " "

        case .unknown:
            deviceMotionAttitudeLabel.text = " "

            deviceMotionGravityLabel.text = " "

            deviceMotionMagneticFieldLabel.text = " "

            deviceMotionRotationRateLabel.text = " "

            deviceMotionTimestampLabel.text = "Unknown"
            deviceMotionTimestampLabel.textColor = UIColor.gray

            deviceMotionUserAccelerationLabel.text = " "

        }
    }

    private func displayGyro(_ info: GyroMonitor.Info) {

        switch info {

        case .data(let data):
            gyroRotationRateLabel.text = formatRotationRate(data.rotationRate)

            gyroTimestampLabel.text = formatTimeInterval(data.timestamp)
            gyroTimestampLabel.textColor = UIColor.black

        case .error(let error):
            gyroRotationRateLabel.text = " "

            gyroTimestampLabel.text = error.localizedDescription
            gyroTimestampLabel.textColor = UIColor.red

        case .unknown:
            gyroRotationRateLabel.text = " "

            gyroTimestampLabel.text = "Unknown"
            gyroTimestampLabel.textColor = UIColor.gray

        }
    }

    private func displayMagnetometer(_ info: MagnetometerMonitor.Info) {

        switch info {

        case .data(let data):
            magnetometerMagneticFieldLabel.text = formatMagneticField(data.magneticField)

            magnetometerTimestampLabel.text = formatTimeInterval(data.timestamp)
            magnetometerTimestampLabel.textColor = UIColor.black

        case .error(let error):
            magnetometerMagneticFieldLabel.text = " "

            magnetometerTimestampLabel.text = error.localizedDescription
            magnetometerTimestampLabel.textColor = UIColor.red

        case .unknown:
            magnetometerMagneticFieldLabel.text = " "

            magnetometerTimestampLabel.text = "Unknown"
            magnetometerTimestampLabel.textColor = UIColor.gray

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
