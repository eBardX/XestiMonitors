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
    @IBOutlet weak var gyroscopeRotationRateLabel: UILabel!
    @IBOutlet weak var gyroscopeTimestampLabel: UILabel!
    @IBOutlet weak var magnetometerMagneticFieldLabel: UILabel!
    @IBOutlet weak var magnetometerTimestampLabel: UILabel!

    lazy var accelerometerMonitor: AccelerometerMonitor = AccelerometerMonitor(queue: .main,
                                                                               interval: 0.5) { [unowned self] in

                                                                                self.displayAccelerometer($0)

    }

    lazy var deviceMotionMonitor: DeviceMotionMonitor = DeviceMotionMonitor(queue: .main,
                                                                            interval: 0.5,
                                                                            using: .xArbitraryZVertical) { [unowned self] in

                                                                                self.displayDeviceMotion($0)

    }

    lazy var gyroscopeMonitor: GyroscopeMonitor = GyroscopeMonitor(queue: .main,
                                                                   interval: 0.5) { [unowned self] in

                                                                    self.displayGyroscope($0)

    }

    lazy var magnetometerMonitor: MagnetometerMonitor = MagnetometerMonitor(queue: .main,
                                                                            interval: 0.5) { [unowned self] in

                                                                                self.displayMagnetometer($0)

    }

    lazy var monitors: [Monitor] = [self.accelerometerMonitor,
                                    self.deviceMotionMonitor,
                                    self.gyroscopeMonitor,
                                    self.magnetometerMonitor]

    // MARK: -

    private func displayAccelerometer(_ event: AccelerometerMonitor.Event?) {

        if let event = event, case let .didUpdate(info) = event {
            displayAccelerometer(info)
        } else {
            displayAccelerometer(.unknown)
        }

    }

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

    private func displayDeviceMotion(_ event: DeviceMotionMonitor.Event?) {

        if let event = event, case let .didUpdate(info) = event {
            displayDeviceMotion(info)
        } else {
            displayDeviceMotion(.unknown)
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

    private func displayGyroscope(_ event: GyroscopeMonitor.Event?) {

        if let event = event, case let .didUpdate(info) = event {
            displayGyroscope(info)
        } else {
            displayGyroscope(.unknown)
        }

    }

    private func displayGyroscope(_ info: GyroscopeMonitor.Info) {

        switch info {

        case .data(let data):
            gyroscopeRotationRateLabel.text = formatRotationRate(data.rotationRate)

            gyroscopeTimestampLabel.text = formatTimeInterval(data.timestamp)
            gyroscopeTimestampLabel.textColor = UIColor.black

        case .error(let error):
            gyroscopeRotationRateLabel.text = " "

            gyroscopeTimestampLabel.text = error.localizedDescription
            gyroscopeTimestampLabel.textColor = UIColor.red

        case .unknown:
            gyroscopeRotationRateLabel.text = " "

            gyroscopeTimestampLabel.text = "Unknown"
            gyroscopeTimestampLabel.textColor = UIColor.gray

        }
    }

    private func displayMagnetometer(_ event: MagnetometerMonitor.Event?) {

        if let event = event, case let .didUpdate(info) = event {
            displayMagnetometer(info)
        } else {
            displayMagnetometer(.unknown)
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

        displayAccelerometer(nil)

        displayDeviceMotion(nil)

        displayGyroscope(nil)

        displayMagnetometer(nil)

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
