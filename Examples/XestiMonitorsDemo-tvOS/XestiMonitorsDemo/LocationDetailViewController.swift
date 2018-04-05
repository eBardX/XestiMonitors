//
//  LocationDetailViewController.swift
//  XestiMonitorsDemo-tvOS
//
//  Created by J. G. Pusey on 2018-03-29.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import UIKit
import XestiMonitors

public class LocationDetailViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var locationAuthorizationStatusLabel: UILabel!
    @IBOutlet private weak var standardLocationAltitudeLabel: UILabel!
    @IBOutlet private weak var standardLocationCoordinateLabel: UILabel!
    @IBOutlet private weak var standardLocationFloorLabel: UILabel!
    @IBOutlet private weak var standardLocationHorizontalAccuracyLabel: UILabel!
    @IBOutlet private weak var standardLocationTimestampLabel: UILabel!
    @IBOutlet private weak var standardLocationVerticalAccuracyLabel: UILabel!

    private lazy var locationAuthorizationMonitor = LocationAuthorizationMonitor(queue: .main) { [unowned self] in
        self.displayLocationAuthorization($0)
    }

    private lazy var standardLocationMonitor = StandardLocationMonitor(queue: .main) { [unowned self] in
        self.displayStandardLocation($0)
    }

    private lazy var monitors: [Monitor] = [self.locationAuthorizationMonitor,
                                            self.standardLocationMonitor]

    // MARK: Private Instance Methods

    private func displayLocationAuthorization(_ event: LocationAuthorizationMonitor.Event?) {
        if !locationAuthorizationMonitor.isEnabled {
            displayLocationAuthorization(nil,
                                         altText: "Not enabled")
        } else if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .error(error):
                displayLocationAuthorization(nil,
                                             altText: error.localizedDescription)

            case let .status(status):
                displayLocationAuthorization(status,
                                             altText: "Unknown")
            }
        } else {
            displayLocationAuthorization(nil,
                                         altText: "Unknown")
        }
    }

    private func displayLocationAuthorization(_ status: CLAuthorizationStatus?,
                                              altText: String) {
        if let status = status {
            locationAuthorizationStatusLabel.text = formatAuthorizationStatus(status)
//            locationAuthorizationStatusLabel.textColor = defaultTextColor
        } else {
            locationAuthorizationStatusLabel.text = altText
//            locationAuthorizationStatusLabel.textColor = altColor
        }
    }

    private func displayStandardLocation(_ event: StandardLocationMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .error(error):
                displayStandardLocation(nil,
                                        altText: error.localizedDescription)

            case let .location(location):
                displayStandardLocation(location,
                                        altText: "Unknown")
            }
        } else {
            displayStandardLocation(nil,
                                    altText: "Unknown")
        }
    }

    private func displayStandardLocation(_ location: CLLocation?,
                                         altText: String) {
        if let location = location {
            standardLocationAltitudeLabel.text = formatLocationDistance(location.altitude)

            standardLocationCoordinateLabel.text = "\(formatLocationCoordinate2D(location.coordinate))"

            standardLocationFloorLabel.text = formatFloor(location.floor)

            standardLocationHorizontalAccuracyLabel.text = formatLocationAccuracy(location.horizontalAccuracy)

            standardLocationTimestampLabel.text = formatDate(location.timestamp)

            standardLocationVerticalAccuracyLabel.text = formatLocationAccuracy(location.verticalAccuracy)
        } else {
            standardLocationAltitudeLabel.text = " "

            standardLocationCoordinateLabel.text = " "

            standardLocationFloorLabel.text = " "

            standardLocationHorizontalAccuracyLabel.text = " "

            standardLocationTimestampLabel.text = altText

            standardLocationVerticalAccuracyLabel.text = " "
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayLocationAuthorization(nil)
        displayStandardLocation(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        monitors.forEach { $0.startMonitoring() }

        locationAuthorizationMonitor.requestWhenInUse()

        standardLocationMonitor.requestLocation()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        monitors.forEach { $0.stopMonitoring() }

        super.viewWillDisappear(animated)
    }
}
