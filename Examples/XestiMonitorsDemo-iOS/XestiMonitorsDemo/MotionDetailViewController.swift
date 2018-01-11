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

// swiftlint:disable type_body_length
public class MotionDetailViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var accelerometerAccelerationLabel: UILabel!
    @IBOutlet private weak var accelerometerOrientationLabel: UILabel!
    @IBOutlet private weak var accelerometerTimestampLabel: UILabel!
    @IBOutlet private weak var altimeterPressureLabel: UILabel!
    @IBOutlet private weak var altimeterRelativeAltitudeLabel: UILabel!
    @IBOutlet private weak var deviceMotionAttitudeLabel: UILabel!
    @IBOutlet private weak var deviceMotionGravityLabel: UILabel!
    @IBOutlet private weak var deviceMotionMagneticFieldLabel: UILabel!
    @IBOutlet private weak var deviceMotionRotationRateLabel: UILabel!
    @IBOutlet private weak var deviceMotionTimestampLabel: UILabel!
    @IBOutlet private weak var deviceMotionUserAccelerationLabel: UILabel!
    @IBOutlet private weak var gyroscopeRotationRateLabel: UILabel!
    @IBOutlet private weak var gyroscopeTimestampLabel: UILabel!
    @IBOutlet private weak var magnetometerMagneticFieldLabel: UILabel!
    @IBOutlet private weak var magnetometerTimestampLabel: UILabel!
    @IBOutlet private weak var motionActivityAutomotiveLabel: UILabel!
    @IBOutlet private weak var motionActivityConfidenceLabel: UILabel!
    @IBOutlet private weak var motionActivityCyclingLabel: UILabel!
    @IBOutlet private weak var motionActivityRunningLabel: UILabel!
    @IBOutlet private weak var motionActivityStartDateLabel: UILabel!
    @IBOutlet private weak var motionActivityStationaryLabel: UILabel!
    @IBOutlet private weak var motionActivityTimestampLabel: UILabel!
    @IBOutlet private weak var motionActivityUnknownLabel: UILabel!
    @IBOutlet private weak var motionActivityWalkingLabel: UILabel!
    @IBOutlet private weak var pedometerAverageActivePaceLabel: UILabel!
    @IBOutlet private weak var pedometerCurrentCadenceLabel: UILabel!
    @IBOutlet private weak var pedometerCurrentPaceLabel: UILabel!
    @IBOutlet private weak var pedometerDistanceLabel: UILabel!
    @IBOutlet private weak var pedometerEndDateLabel: UILabel!
    @IBOutlet private weak var pedometerFloorsAscendedLabel: UILabel!
    @IBOutlet private weak var pedometerFloorsDescendedLabel: UILabel!
    @IBOutlet private weak var pedometerNumberOfStepsLabel: UILabel!
    @IBOutlet private weak var pedometerStartDateLabel: UILabel!

    private lazy var accelerometerMonitor = AccelerometerMonitor(queue: .main,
                                                                 interval: 1) { [unowned self] in
                                                                    self.displayAccelerometer($0)
    }

    private lazy var altimeterMonitor = AltimeterMonitor(queue: .main) { [unowned self] in
        self.displayAltimeter($0)
    }

    private lazy var deviceMotionMonitor = DeviceMotionMonitor(queue: .main,
                                                               interval: 1,
                                                               using: .xArbitraryZVertical) { [unowned self] in
                                                                self.displayDeviceMotion($0)
    }

    private lazy var gyroscopeMonitor = GyroscopeMonitor(queue: .main,
                                                         interval: 0.5) { [unowned self] in
                                                            self.displayGyroscope($0)
    }

    private lazy var magnetometerMonitor = MagnetometerMonitor(queue: .main,
                                                               interval: 1) { [unowned self] in
                                                                self.displayMagnetometer($0)
    }

    private lazy var motionActivityMonitor = MotionActivityMonitor(queue: .main) { [unowned self] in
        self.displayMotionActivity($0)
    }

    private lazy var pedometerMonitor = PedometerMonitor(queue: .main) { [unowned self] in
        self.displayPedometer($0)
    }

    private lazy var monitors: [Monitor] = [self.accelerometerMonitor,
                                            self.altimeterMonitor,
                                            self.deviceMotionMonitor,
                                            self.gyroscopeMonitor,
                                            self.magnetometerMonitor,
                                            self.motionActivityMonitor,
                                            self.pedometerMonitor]

    // MARK: Private Instance Methods

    private func displayAccelerometer(_ event: AccelerometerMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
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
            accelerometerTimestampLabel.textColor = .black

        case .error(let error):
            accelerometerAccelerationLabel.text = " "

            accelerometerOrientationLabel.text = " "

            accelerometerTimestampLabel.text = error.localizedDescription
            accelerometerTimestampLabel.textColor = .red

        case .unknown:
            accelerometerAccelerationLabel.text = " "

            accelerometerOrientationLabel.text = " "

            accelerometerTimestampLabel.text = "Unknown"
            accelerometerTimestampLabel.textColor = .gray
        }
    }

    private func displayAltimeter(_ event: AltimeterMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
            displayAltimeter(info)
        } else {
            displayAltimeter(.unknown)
        }
    }

    private func displayAltimeter(_ info: AltimeterMonitor.Info) {
        switch info {
        case .data(let data):
            altimeterPressureLabel.text = formatPressure(data.pressure)

            altimeterRelativeAltitudeLabel.text = formatRelativeAltitude(data.relativeAltitude)
            altimeterRelativeAltitudeLabel.textColor = .black

        case .error(let error):
            altimeterPressureLabel.text = " "

            altimeterRelativeAltitudeLabel.text = error.localizedDescription
            altimeterRelativeAltitudeLabel.textColor = .red

        case .unknown:
            altimeterPressureLabel.text = " "

            altimeterRelativeAltitudeLabel.text = "Unknown"
            altimeterRelativeAltitudeLabel.textColor = .gray
        }
    }

    private func displayDeviceMotion(_ event: DeviceMotionMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
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
            deviceMotionTimestampLabel.textColor = .black

            deviceMotionUserAccelerationLabel.text = formatAcceleration(data.userAcceleration)

        case .error(let error):
            deviceMotionAttitudeLabel.text = " "

            deviceMotionGravityLabel.text = " "

            deviceMotionMagneticFieldLabel.text = " "

            deviceMotionRotationRateLabel.text = " "

            deviceMotionTimestampLabel.text = error.localizedDescription
            deviceMotionTimestampLabel.textColor = .red

            deviceMotionUserAccelerationLabel.text = " "

        case .unknown:
            deviceMotionAttitudeLabel.text = " "

            deviceMotionGravityLabel.text = " "

            deviceMotionMagneticFieldLabel.text = " "

            deviceMotionRotationRateLabel.text = " "

            deviceMotionTimestampLabel.text = "Unknown"
            deviceMotionTimestampLabel.textColor = .gray

            deviceMotionUserAccelerationLabel.text = " "
        }
    }

    private func displayGyroscope(_ event: GyroscopeMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
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
            gyroscopeTimestampLabel.textColor = .black

        case .error(let error):
            gyroscopeRotationRateLabel.text = " "

            gyroscopeTimestampLabel.text = error.localizedDescription
            gyroscopeTimestampLabel.textColor = .red

        case .unknown:
            gyroscopeRotationRateLabel.text = " "

            gyroscopeTimestampLabel.text = "Unknown"
            gyroscopeTimestampLabel.textColor = .gray
        }
    }

    private func displayMagnetometer(_ event: MagnetometerMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
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
            magnetometerTimestampLabel.textColor = .black

        case .error(let error):
            magnetometerMagneticFieldLabel.text = " "

            magnetometerTimestampLabel.text = error.localizedDescription
            magnetometerTimestampLabel.textColor = .red

        case .unknown:
            magnetometerMagneticFieldLabel.text = " "

            magnetometerTimestampLabel.text = "Unknown"
            magnetometerTimestampLabel.textColor = .gray
        }
    }

    private func displayMotionActivity(_ event: MotionActivityMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
            displayMotionActivity(info)
        } else {
            displayMotionActivity(.unknown)
        }
    }

    private func displayMotionActivity(_ info: MotionActivityMonitor.Info) {
        switch info {
        case .activity(let activity):
            motionActivityAutomotiveLabel.text = formatBool(activity.automotive)

            motionActivityConfidenceLabel.text = formatMotionActivityConfidence(activity.confidence)

            motionActivityCyclingLabel.text = formatBool(activity.cycling)

            motionActivityRunningLabel.text = formatBool(activity.running)

            motionActivityStartDateLabel.text = formatDate(activity.startDate)

            motionActivityStationaryLabel.text = formatBool(activity.stationary)

            motionActivityTimestampLabel.text = formatTimeInterval(activity.timestamp)
            motionActivityTimestampLabel.textColor = .black

            motionActivityUnknownLabel.text = formatBool(activity.unknown)

            motionActivityWalkingLabel.text = formatBool(activity.walking)

        case .error(let error):
            motionActivityAutomotiveLabel.text = " "

            motionActivityConfidenceLabel.text = " "

            motionActivityCyclingLabel.text = " "

            motionActivityRunningLabel.text = " "

            motionActivityStartDateLabel.text = " "

            motionActivityStationaryLabel.text = " "

            motionActivityTimestampLabel.text = error.localizedDescription
            motionActivityTimestampLabel.textColor = .red

            motionActivityUnknownLabel.text = " "

            motionActivityWalkingLabel.text = " "

        case .unknown:
            motionActivityAutomotiveLabel.text = " "

            motionActivityConfidenceLabel.text = " "

            motionActivityCyclingLabel.text = " "

            motionActivityRunningLabel.text = " "

            motionActivityStartDateLabel.text = " "

            motionActivityStationaryLabel.text = " "

            motionActivityTimestampLabel.text = "Unknown"
            motionActivityTimestampLabel.textColor = .gray

            motionActivityUnknownLabel.text = " "

            motionActivityWalkingLabel.text = " "

        default:
            break
        }
    }

    private func displayPedometer(_ event: PedometerMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
            displayPedometer(info)
        } else {
            displayPedometer(.unknown)
        }
    }

    private func displayPedometer(_ info: PedometerMonitor.Info) {
        switch info {
        case .data(let data):
            if #available(iOS 10.0, *) {
                if let value = data.averageActivePace {
                    pedometerAverageActivePaceLabel.text = formatPace(value)
                } else {
                    pedometerAverageActivePaceLabel.text = " "
                }
            } else {
                pedometerAverageActivePaceLabel.text = " "
            }

            if let value = data.currentCadence {
                pedometerCurrentCadenceLabel.text = formatCadence(value)
            } else {
                pedometerCurrentCadenceLabel.text = " "
            }

            if let value = data.currentPace {
                pedometerCurrentPaceLabel.text = formatPace(value)
            } else {
                pedometerCurrentPaceLabel.text = " "
            }

            if let value = data.distance {
                pedometerDistanceLabel.text = formatDistance(value)
            } else {
                pedometerDistanceLabel.text = " "
            }

            pedometerEndDateLabel.text = formatDate(data.endDate)

            if let value = data.floorsAscended {
                pedometerFloorsAscendedLabel.text = formatDecimal(value)
            } else {
                pedometerFloorsAscendedLabel.text = " "
            }

            if let value = data.floorsDescended {
                pedometerFloorsDescendedLabel.text = formatDecimal(value)
            } else {
                pedometerFloorsDescendedLabel.text = " "
            }

            pedometerNumberOfStepsLabel.text = formatInteger(data.numberOfSteps)

            pedometerStartDateLabel.text = formatDate(data.startDate)
            pedometerStartDateLabel.textColor = .black

        case .error(let error):
            pedometerAverageActivePaceLabel.text = " "

            pedometerCurrentCadenceLabel.text = " "

            pedometerCurrentPaceLabel.text = " "

            pedometerDistanceLabel.text = " "

            pedometerEndDateLabel.text = " "

            pedometerFloorsAscendedLabel.text = " "

            pedometerFloorsDescendedLabel.text = " "

            pedometerNumberOfStepsLabel.text = " "

            pedometerStartDateLabel.text = error.localizedDescription
            pedometerStartDateLabel.textColor = .red

        case .unknown:
            pedometerAverageActivePaceLabel.text = " "

            pedometerCurrentCadenceLabel.text = " "

            pedometerCurrentPaceLabel.text = " "

            pedometerDistanceLabel.text = " "

            pedometerEndDateLabel.text = " "

            pedometerFloorsAscendedLabel.text = " "

            pedometerFloorsDescendedLabel.text = " "

            pedometerNumberOfStepsLabel.text = " "

            pedometerStartDateLabel.text = "Unknown"
            pedometerStartDateLabel.textColor = .gray
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayAccelerometer(nil)
        displayAltimeter(nil)
        displayDeviceMotion(nil)
        displayGyroscope(nil)
        displayMagnetometer(nil)
        displayMotionActivity(nil)
        displayPedometer(nil)
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
