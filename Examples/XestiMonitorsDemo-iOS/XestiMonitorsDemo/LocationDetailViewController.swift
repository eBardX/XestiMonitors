//
//  LocationDetailViewController.swift
//  XestiMonitorsDemo-iOS
//
//  Created by J. G. Pusey on 2018-03-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import UIKit
import XestiMonitors

// swiftlint:disable type_body_length

public class LocationDetailViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var beaconRangingAccuracyLabel: UILabel!
    @IBOutlet private weak var beaconRangingMajorMinorLabel: UILabel!
    @IBOutlet private weak var beaconRangingProximityLabel: UILabel!
    @IBOutlet private weak var beaconRangingProximityUUIDLabel: UILabel!
    @IBOutlet private weak var beaconRangingRSSILabel: UILabel!
    @IBOutlet private weak var headingAccuracyLabel: UILabel!
    @IBOutlet private weak var headingGeomagnetismLabel: UILabel!
    @IBOutlet private weak var headingMagneticHeadingLabel: UILabel!
    @IBOutlet private weak var headingTimestampLabel: UILabel!
    @IBOutlet private weak var headingTrueHeadingLabel: UILabel!
    @IBOutlet private weak var locationAuthorizationStatusLabel: UILabel!
    @IBOutlet private weak var regionIdentifierLabel: UILabel!
    @IBOutlet private weak var regionStateLabel: UILabel!
    @IBOutlet private weak var significantLocationAltitudeLabel: UILabel!
    @IBOutlet private weak var significantLocationCoordinateLabel: UILabel!
    @IBOutlet private weak var significantLocationCourseLabel: UILabel!
    @IBOutlet private weak var significantLocationFloorLabel: UILabel!
    @IBOutlet private weak var significantLocationHorizontalAccuracyLabel: UILabel!
    @IBOutlet private weak var significantLocationSpeedLabel: UILabel!
    @IBOutlet private weak var significantLocationTimestampLabel: UILabel!
    @IBOutlet private weak var significantLocationVerticalAccuracyLabel: UILabel!
    @IBOutlet private weak var standardLocationAltitudeLabel: UILabel!
    @IBOutlet private weak var standardLocationCoordinateLabel: UILabel!
    @IBOutlet private weak var standardLocationCourseLabel: UILabel!
    @IBOutlet private weak var standardLocationFloorLabel: UILabel!
    @IBOutlet private weak var standardLocationHorizontalAccuracyLabel: UILabel!
    @IBOutlet private weak var standardLocationSpeedLabel: UILabel!
    @IBOutlet private weak var standardLocationTimestampLabel: UILabel!
    @IBOutlet private weak var standardLocationVerticalAccuracyLabel: UILabel!
    @IBOutlet private weak var visitArrivalDateLabel: UILabel!
    @IBOutlet private weak var visitCoordinateLabel: UILabel!
    @IBOutlet private weak var visitDepartureDateLabel: UILabel!
    @IBOutlet private weak var visitHorizontalAccuracyLabel: UILabel!

    private lazy var beaconRangingMonitor = BeaconRangingMonitor(region: beaconRegion,
                                                                 queue: .main) { [unowned self] in
                                                                    self.displayBeaconRanging($0)
    }

    private lazy var beaconRegion = CLBeaconRegion(proximityUUID: UUID(),
                                                   identifier: "Test Region")

    private lazy var headingMonitor = HeadingMonitor(queue: .main) { [unowned self] in
        self.displayHeading($0)
    }

    private lazy var locationAuthorizationMonitor = LocationAuthorizationMonitor(queue: .main) { [unowned self] in
        self.displayLocationAuthorization($0)
    }

    private lazy var regionMonitor = RegionMonitor(region: beaconRegion,
                                                   queue: .main) { [unowned self] in
                                                    self.displayRegion($0)
    }

    private lazy var significantLocationMonitor = SignificantLocationMonitor(queue: .main) { [unowned self] in
        self.displaySignificantLocation($0)
    }

    private lazy var standardLocationMonitor = StandardLocationMonitor(queue: .main) { [unowned self] in
        self.displayStandardLocation($0)
    }

    private lazy var visitMonitor = VisitMonitor(queue: .main) { [unowned self] in
        self.displayVisit($0)
    }

    private lazy var monitors: [Monitor] = [self.beaconRangingMonitor,
                                            self.headingMonitor,
                                            self.locationAuthorizationMonitor,
                                            self.regionMonitor,
                                            self.significantLocationMonitor,
                                            self.standardLocationMonitor,
                                            self.visitMonitor]

    // MARK: Private Instance Methods

    private func displayBeaconRanging(_ event: BeaconRangingMonitor.Event?) {
        if !beaconRangingMonitor.isAvailable {
            displayBeaconRanging(nil,
                                 altText: "Not available",
                                 altColor: .red)
        } else if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .beacons(beacons, region):
                displayBeaconRanging(beacons.first,
                                     altText: region.proximityUUID.uuidString,
                                     altColor: .gray)

            case let .error(error, region):
                displayBeaconRanging(nil,
                                     altText: region.proximityUUID.uuidString,
                                     altColor: .gray,
                                     altText2: error.localizedDescription,
                                     altColor2: .red)
            }
        } else {
            displayBeaconRanging(nil,
                                 altText: "Unknown",
                                 altColor: .gray)
        }
    }

    private func displayBeaconRanging(_ beacon: CLBeacon?,
                                      altText: String,
                                      altColor: UIColor,
                                      altText2: String = " ",
                                      altColor2: UIColor = .black) {
        if let beacon = beacon {
            beaconRangingAccuracyLabel.text = formatLocationAccuracy(beacon.accuracy)

            beaconRangingMajorMinorLabel.text = formatBeaconValues(beacon.major,
                                                                   beacon.minor)
            beaconRangingMajorMinorLabel.textColor = .black

            beaconRangingProximityLabel.text = formatProximity(beacon.proximity)

            beaconRangingProximityUUIDLabel.text = beacon.proximityUUID.uuidString
            beaconRangingProximityUUIDLabel.textColor = .black

            beaconRangingRSSILabel.text = formatRSSI(beacon.rssi)
        } else {
            beaconRangingAccuracyLabel.text = " "

            beaconRangingMajorMinorLabel.text = altText2
            beaconRangingMajorMinorLabel.textColor = altColor2

            beaconRangingProximityLabel.text = " "

            beaconRangingProximityUUIDLabel.text = altText
            beaconRangingProximityUUIDLabel.textColor = altColor

            beaconRangingRSSILabel.text = " "
        }
    }

    private func displayHeading(_ event: HeadingMonitor.Event?) {
        if !headingMonitor.isAvailable {
            displayHeading(nil,
                           altText: "Not available",
                           altColor: .red)
        } else if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .error(error):
                displayHeading(nil,
                               altText: error.localizedDescription,
                               altColor: .red)

            case let .heading(heading):
                displayHeading(heading,
                               altText: "Unknown",
                               altColor: .gray)
            }
        } else {
            displayHeading(nil,
                           altText: "Unknown",
                           altColor: .gray)
        }
    }

    private func displayHeading(_ heading: CLHeading?,
                                altText: String,
                                altColor: UIColor) {
        if let heading = heading {
            headingAccuracyLabel.text = formatLocationDirection(heading.headingAccuracy)

            headingGeomagnetismLabel.text = formatHeadingComponentValues(heading.x,
                                                                         heading.y,
                                                                         heading.z)

            headingMagneticHeadingLabel.text = formatLocationDirection(heading.magneticHeading)

            headingTimestampLabel.text = formatDate(heading.timestamp)
            headingTimestampLabel.textColor = .black

            headingTrueHeadingLabel.text = formatLocationDirection(heading.trueHeading)
        } else {
            headingAccuracyLabel.text = " "

            headingGeomagnetismLabel.text = " "

            headingMagneticHeadingLabel.text = " "

            headingTimestampLabel.text = altText
            headingTimestampLabel.textColor = altColor

            headingTrueHeadingLabel.text = " "
        }
    }

    private func displayLocationAuthorization(_ event: LocationAuthorizationMonitor.Event?) {
        if !locationAuthorizationMonitor.isEnabled {
            displayLocationAuthorization(nil,
                                         altText: "Not enabled",
                                         altColor: .red)
        } else if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .error(error):
                displayLocationAuthorization(nil,
                                             altText: error.localizedDescription,
                                             altColor: .red)

            case let .status(status):
                displayLocationAuthorization(status,
                                             altText: "Unknown",
                                             altColor: .gray)
            }
        } else {
            displayLocationAuthorization(nil,
                                         altText: "Unknown",
                                         altColor: .gray)
        }
    }

    private func displayLocationAuthorization(_ status: CLAuthorizationStatus?,
                                              altText: String,
                                              altColor: UIColor) {
        if let status = status {
            locationAuthorizationStatusLabel.text = formatAuthorizationStatus(status)
            locationAuthorizationStatusLabel.textColor = .black
        } else {
            locationAuthorizationStatusLabel.text = altText
            locationAuthorizationStatusLabel.textColor = altColor
        }
    }

    private func displayRegion(_ event: RegionMonitor.Event?) {
        if !regionMonitor.isAvailable {
            displayRegion(nil,
                          altText: "Not available",
                          altColor: .red)
        } else if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .error(error, region):
                displayRegion(nil,
                              altText: region.identifier,
                              altColor: .gray,
                              altText2: error.localizedDescription,
                              altColor2: .red)

            case let .regionState(state, region):
                displayRegion(region,
                              state: state,
                              altText: "Unknown",
                              altColor: .gray)
            }
        } else {
            displayRegion(nil,
                          altText: "Unknown",
                          altColor: .gray)
        }
    }

    private func displayRegion(_ region: CLRegion?,
                               state: CLRegionState = .unknown,
                               altText: String,
                               altColor: UIColor,
                               altText2: String = " ",
                               altColor2: UIColor = .black) {
        if let region = region {
            regionIdentifierLabel.text = region.identifier
            regionIdentifierLabel.textColor = .black

            regionStateLabel.text = formatRegionState(state)
            regionStateLabel.textColor = .black
        } else {
            regionIdentifierLabel.text = altText
            regionIdentifierLabel.textColor = altColor

            regionStateLabel.text = altText2
            regionStateLabel.textColor = altColor2
        }
    }

    private func displaySignificantLocation(_ event: SignificantLocationMonitor.Event?) {
        if !significantLocationMonitor.isAvailable {
            displaySignificantLocation(nil,
                                       altText: "Not available",
                                       altColor: .red)
        } else if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .error(error):
                displaySignificantLocation(nil,
                                           altText: error.localizedDescription,
                                           altColor: .red)

            case let .location(location):
                displaySignificantLocation(location,
                                           altText: "Unknown",
                                           altColor: .gray)
            }
        } else {
            displaySignificantLocation(nil,
                                       altText: "Unknown",
                                       altColor: .gray)
        }
    }

    private func displaySignificantLocation(_ location: CLLocation?,
                                            altText: String,
                                            altColor: UIColor) {
        if let location = location {
            significantLocationAltitudeLabel.text = formatLocationDistance(location.altitude)

            significantLocationCoordinateLabel.text = formatLocationCoordinate2D(location.coordinate)

            significantLocationCourseLabel.text = formatLocationDirection(location.course)

            significantLocationFloorLabel.text = formatFloor(location.floor)

            significantLocationHorizontalAccuracyLabel.text = formatLocationAccuracy(location.horizontalAccuracy)

            significantLocationSpeedLabel.text = formatLocationSpeed(location.speed)

            significantLocationTimestampLabel.text = formatDate(location.timestamp)
            significantLocationTimestampLabel.textColor = .black

            significantLocationVerticalAccuracyLabel.text = formatLocationAccuracy(location.verticalAccuracy)
        } else {
            significantLocationAltitudeLabel.text = " "

            significantLocationCoordinateLabel.text = " "

            significantLocationCourseLabel.text = " "

            significantLocationFloorLabel.text = " "

            significantLocationHorizontalAccuracyLabel.text = " "

            significantLocationSpeedLabel.text = " "

            significantLocationTimestampLabel.text = altText
            significantLocationTimestampLabel.textColor = altColor

            significantLocationVerticalAccuracyLabel.text = " "
        }
    }

    private func displayStandardLocation(_ event: StandardLocationMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .error(error):
                displayStandardLocation(nil,
                                        altText: error.localizedDescription,
                                        altColor: .red)

            case let .location(location):
                displayStandardLocation(location,
                                        altText: "Unknown",
                                        altColor: .gray)
            }
        } else {
            displayStandardLocation(nil,
                                    altText: "Unknown",
                                    altColor: .gray)
        }
    }

    private func displayStandardLocation(_ location: CLLocation?,
                                         altText: String,
                                         altColor: UIColor) {
        if let location = location {
            standardLocationAltitudeLabel.text = formatLocationDistance(location.altitude)

            standardLocationCoordinateLabel.text = "\(formatLocationCoordinate2D(location.coordinate))"

            standardLocationCourseLabel.text = formatLocationDirection(location.course)

            standardLocationFloorLabel.text = formatFloor(location.floor)

            standardLocationHorizontalAccuracyLabel.text = formatLocationAccuracy(location.horizontalAccuracy)

            standardLocationSpeedLabel.text = formatLocationSpeed(location.speed)

            standardLocationTimestampLabel.text = formatDate(location.timestamp)
            standardLocationTimestampLabel.textColor = .black

            standardLocationVerticalAccuracyLabel.text = formatLocationAccuracy(location.verticalAccuracy)
        } else {
            standardLocationAltitudeLabel.text = " "

            standardLocationCoordinateLabel.text = " "

            standardLocationCourseLabel.text = " "

            standardLocationFloorLabel.text = " "

            standardLocationHorizontalAccuracyLabel.text = " "

            standardLocationSpeedLabel.text = " "

            standardLocationTimestampLabel.text = altText
            standardLocationTimestampLabel.textColor = altColor

            standardLocationVerticalAccuracyLabel.text = " "
        }
    }

    private func displayVisit(_ event: VisitMonitor.Event?) {
        if let event = event,
            case let .didUpdate(info) = event {
            switch info {
            case let .error(error):
                displayVisit(nil,
                             altText: error.localizedDescription,
                             altColor: .red)

            case let .visit(visit):
                displayVisit(visit,
                             altText: "Unknown",
                             altColor: .gray)
            }
        } else {
            displayVisit(nil,
                         altText: "Unknown",
                         altColor: .gray)
        }
    }

    private func displayVisit(_ visit: CLVisit?,
                              altText: String,
                              altColor: UIColor) {
        if let visit = visit {
            visitArrivalDateLabel.text = formatDate(visit.arrivalDate)

            visitCoordinateLabel.text = "\(formatLocationCoordinate2D(visit.coordinate))"
            visitCoordinateLabel.textColor = .black

            visitDepartureDateLabel.text = formatDate(visit.departureDate)

            visitHorizontalAccuracyLabel.text = formatLocationAccuracy(visit.horizontalAccuracy)
        } else {
            visitArrivalDateLabel.text = " "

            visitCoordinateLabel.text = altText
            visitCoordinateLabel.textColor = altColor

            visitDepartureDateLabel.text = " "

            visitHorizontalAccuracyLabel.text = " "
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayBeaconRanging(nil)
        displayHeading(nil)
        displayLocationAuthorization(nil)
        displayRegion(nil)
        displaySignificantLocation(nil)
        displayStandardLocation(nil)
        displayVisit(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        monitors.forEach { $0.startMonitoring() }

        locationAuthorizationMonitor.requestAlways()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        monitors.forEach { $0.stopMonitoring() }

        super.viewWillDisappear(animated)
    }
}
