//
//  Formatters.swift
//  XestiMonitorsDemo-iOS
//
//  Created by J. G. Pusey on 2016-12-20.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import CoreMotion
import Foundation
import UIKit
import XestiMonitors

public func formatAcceleration(_ value: CMAcceleration) -> String {
    return "\(formatDecimal(value.x)), \(formatDecimal(value.y)), \(formatDecimal(value.z))"
}

public func formatAccessibilityElement(_ element: Any) -> String {
    if let accElem = element as? UIAccessibilityElement,
        let label = accElem.accessibilityLabel {
        return label
    }

    return "\(element)"
}

public func formatAssistiveTechnology(_ value: String) -> String {
    if UIAccessibilityNotificationSwitchControlIdentifier == value {
        return "Switch Control"
    }

    if UIAccessibilityNotificationVoiceOverIdentifier == value {
        return "VoiceOver"
    }

    return value
}

public func formatAttitude(_ value: CMAttitude) -> String {
    return "\(formatDecimal(value.roll)), \(formatDecimal(value.pitch)), \(formatDecimal(value.yaw))"
}

public func formatAuthorizationStatus(_ value: CLAuthorizationStatus) -> String {
    switch value {
    case .authorizedAlways:
        return "Authorized always"

    case .authorizedWhenInUse:
        return "Authorized when in use"

    case .denied:
        return "Denied"

    case .notDetermined:
        return "Not determined"

    case .restricted:
        return "Restricted"
    }
}

public func formatBackgroundRefreshStatus(_ value: UIBackgroundRefreshStatus) -> String {
    switch value {
    case .available:
        return "Available"

    case .denied:
        return "Denied"

    case .restricted:
        return "Restricted"
    }
}

public func formatBeaconValues(_ major: NSNumber,
                               _ minor: NSNumber) -> String {
    return "\(formatInteger(major)), \(formatInteger(minor))"
}

public func formatBool(_ value: Bool) -> String {
    return value ? "True" : "False"
}

public func formatCadence(_ value: NSNumber) -> String {
    return "\(formatDecimal(value)) steps/s"
}

public func formatDate(_ value: Date) -> String {
    return dateFormatter.string(from: value)
}

public func formatDecimal(_ value: Double,
                          minimumFractionDigits: Int = 0,
                          maximumFractionDigits: Int = 3) -> String {
    return formatDecimal(NSNumber(value: value),
                         minimumFractionDigits: minimumFractionDigits,
                         maximumFractionDigits: maximumFractionDigits)
}

public func formatDecimal(_ value: NSNumber,
                          minimumFractionDigits: Int = 0,
                          maximumFractionDigits: Int = 3) -> String {
    decimalFormatter.maximumFractionDigits = maximumFractionDigits
    decimalFormatter.minimumFractionDigits = minimumFractionDigits

    return decimalFormatter.string(from: value) ?? "\(value)"
}

public func formatDeviceBatteryStateAndLevel(_ state: UIDeviceBatteryState,
                                             _ level: Float) -> String {
    switch state {
    case .charging:
        return "Charging \(formatPercentage(level))"

    case .full:
        return "Full"

    case .unplugged:
        return "Unplugged \(formatPercentage(level))"

    case .unknown:
        return "Unknown"
    }
}

public func formatDeviceOrientation(_ value: UIDeviceOrientation) -> String {
    switch value {
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

    case .unknown:
        return "Unknown"
    }
}

public func formatDeviceProximityState(_ value: Bool?) -> String {
    if let value = value {
        return value ? "Close" : "Not close"
    } else {
        return "N/A"
    }
}

public func formatDistance(_ value: NSNumber) -> String {
    return "\(formatDecimal(value)) m"
}

public func formatFloor(_ value: CLFloor?) -> String {
    if let level = value?.level {
        if level > 0 {
            return "GL+\(formatInteger(level))"
        }

        if level < 0 {
            return "GL-\(formatInteger(abs(level)))"
        }

        return "Ground level"
    } else {
        return "N/A"
    }
}

public func formatHeadingComponentValues(_ x: CLHeadingComponentValue,
                                         _ y: CLHeadingComponentValue,
                                         _ z: CLHeadingComponentValue) -> String {
    return "\(formatDecimal(x)), \(formatDecimal(y)), \(formatDecimal(z))"
}

@available(iOS 10.0, *)
public func formatHearingDeviceEar(_ ear: UIAccessibilityHearingDeviceEar) -> String {
    switch ear {
    case [.both]:
        return "L+R"

    case [.left]:
        return "L"

    case [.right]:
        return "R"

    default :
        return "None"
    }
}

public func formatInteger(_ value: Int) -> String {
    return formatInteger(NSNumber(value: value))
}

public func formatInteger(_ value: NSNumber) -> String {
    return integerFormatter.string(from: value) ?? "\(value)"
}

public func formatInterfaceOrientation(_ value: UIInterfaceOrientation) -> String {
    switch value {
    case .landscapeLeft:
        return "Landscape left"

    case .landscapeRight:
        return "Landscape right"

    case .portrait:
        return "Portrait"

    case .portraitUpsideDown:
        return "Portrait upside down"

    case .unknown:
        return "Unknown"
    }
}

public func formatLocationAccuracy(_ value: CLLocationAccuracy) -> String {
    guard
        value >= 0
        else { return "Invalid" }

    return "\(formatDecimal(value)) m"
}

public func formatLocationCoordinate2D(_ value: CLLocationCoordinate2D) -> String {
    guard
        CLLocationCoordinate2DIsValid(value)
        else { return "Invalid" }

    return "\(formatLatitude(value.latitude)) \(formatLongitude(value.longitude))"
}

public func formatLocationDirection(_ value: CLLocationDirection) -> String {
    guard
        value >= 0
        else { return "Invalid" }

    let rawDegrees = formatDecimal(value.seconds,
                                   maximumFractionDigits: 1)

    return "\(rawDegrees)°"
}

public func formatLocationDistance(_ value: CLLocationDistance) -> String {
    return "\(formatDecimal(value)) m"
}

public func formatLocationSpeed(_ value: CLLocationSpeed) -> String {
    guard
        value >= 0
        else { return "Invalid" }

    return "\(formatDecimal(value)) m/s"
}

public func formatMagneticField(_ value: CMCalibratedMagneticField) -> String {
    return "\(formatMagneticField(value.field)) \(formatMagneticFieldCalibrationAccuracy(value.accuracy))"
}

public func formatMagneticField(_ value: CMMagneticField) -> String {
    return "\(formatDecimal(value.x)), \(formatDecimal(value.y)), \(formatDecimal(value.z))"
}

public func formatMagneticFieldCalibrationAccuracy(_ value: CMMagneticFieldCalibrationAccuracy) -> String {
    switch value {
    case .high:
        return "High"

    case .low:
        return "Low"

    case .medium:
        return "Medium"

    case .uncalibrated:
        return "Uncalibrated"
    }
}

public func formatMotionActivityConfidence(_ value: CMMotionActivityConfidence) -> String {
    switch value {
    case .high:
        return "High"

    case .low:
        return "Low"

    case .medium:
        return "Medium"
    }
}

public func formatPace(_ value: NSNumber) -> String {
    return "\(formatDecimal(value)) s/m"
}

public func formatPercentage(_ value: Float) -> String {
    return formatPercentage(NSNumber(value: value))
}

public func formatPercentage(_ value: NSNumber) -> String {
    return percentageFormatter.string(from: value) ?? "\(value.floatValue * 100.0)%"
}

public func formatPressure(_ value: NSNumber) -> String {
    return "\(formatDecimal(value)) kPa"
}

public func formatProximity(_ value: CLProximity) -> String {
    switch value {
    case .far:
        return "Far"

    case .immediate:
        return "Immediate"

    case .near:
        return "Near"

    case .unknown:
        return "Unknown"
    }
}

public func formatRect(_ value: CGRect) -> String {
    return "\(value)"   // for now ...
}

public func formatRegionState(_ value: CLRegionState) -> String {
    switch value {
    case .inside:
        return "Inside"

    case .outside:
        return "Outside"

    case .unknown:
        return "Unknown"
    }
}

public func formatRelativeAltitude(_ value: NSNumber) -> String {
    return "\(formatDecimal(value)) m"
}

public func formatRotationRate(_ value: CMRotationRate) -> String {
    return "\(formatDecimal(value.x)), \(formatDecimal(value.y)), \(formatDecimal(value.z))"
}

public func formatRSSI(_ value: Int) -> String {
    return "\(formatInteger(value)) dB"
}

public func formatTimeInterval(_ value: TimeInterval) -> String {
    return timeIntervalFormatter.string(from: value) ?? "\(value)"
}

public func formatViewAnimationCurve(_ value: UIViewAnimationCurve) -> String {
    switch value {
    case .easeIn:
        return "Ease in"

    case .easeInOut:
        return "Ease in/out"

    case .easeOut:
        return "Ease out"

    case .linear:
        return "Linear"
    }
}

// MARK: -

private var dateFormatter: DateFormatter = {
    var formatter = DateFormatter()

    formatter.dateStyle = .medium
    formatter.timeStyle = .medium

    return formatter
}()

private var decimalFormatter: NumberFormatter = {
    var formatter = NumberFormatter()

    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = true

    return formatter
}()

private var integerFormatter: NumberFormatter = {
    var formatter = NumberFormatter()

    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 0
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = true

    return formatter
}()

private var percentageFormatter: NumberFormatter = {
    var formatter = NumberFormatter()

    formatter.maximumFractionDigits = 1
    formatter.minimumFractionDigits = 0
    formatter.numberStyle = .percent
    formatter.usesGroupingSeparator = true

    return formatter
}()

private var timeIntervalFormatter: DateComponentsFormatter = {
    var formatter = DateComponentsFormatter()

    formatter.allowedUnits = [.day, .hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad

    return formatter
}()

private func formatLatitude(_ value: CLLocationDegrees) -> String {
    return formatLocationDegrees(value,
                                 directions: (pos: "N", neg: "S"))
}

private func formatLongitude(_ value: CLLocationDegrees) -> String {
    return formatLocationDegrees(value,
                                 directions: (pos: "E", neg: "W"))
}

private func formatLocationDegrees(_ value: CLLocationDegrees,
                                   directions: (pos: String, neg: String)) -> String {
    let rawDegrees = value.degrees
    let degrees = formatInteger(abs(rawDegrees))
    let minutes = formatInteger(value.minutes)
    let seconds = formatDecimal(value.seconds,
                                maximumFractionDigits: 1)
    let direction = rawDegrees > 0
        ? directions.pos
        : rawDegrees < 0
        ? directions.neg
        : ""

    return "\(degrees)° \(minutes)′ \(seconds)″ \(direction)"
}

private extension CLLocationDegrees {
    var degrees: Int {
        return Int(rounded(.towardZero))
    }

    var minutes: Int {
        return Int((abs(self) * 60).modulo(60).rounded(.towardZero))
    }

    var seconds: Double {
        return (abs(self) * 3_600).modulo(60)
    }

    private func modulo(_ mod: CLLocationDegrees) -> CLLocationDegrees {
        return self - (mod * (self / mod).rounded(.towardZero))
    }
}
