//
//  Formatters.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-20.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

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

    if #available(iOS 9.0, *),
        UIAccessibilityNotificationVoiceOverIdentifier == value {
        return "VoiceOver"
    }

    return value

}

public func formatAttitude(_ value: CMAttitude) -> String {

    return "\(formatDecimal(value.roll)), \(formatDecimal(value.pitch)), \(formatDecimal(value.yaw))"

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

public func formatBool(_ value: Bool) -> String {

    return value ? "True" : "False"

}

public func formatCadence(_ value: NSNumber) -> String {

    return "\(formatDecimal(value)) steps/s"

}

public func formatDate(_ value: Date) -> String {

    return dateFormatter.string(from: value)

}

public func formatDecimal(_ value: Double) -> String {

    let number = NSNumber(value: value)

    return decimalFormatter.string(from: number) ?? "\(value)"

}

public func formatDecimal(_ value: NSNumber) -> String {

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

    return "\(formatDecimal(value))m"

}

public func formatHearingDeviceEar(_ ear: AccessibilityStatusMonitor.HearingDeviceEar) -> String {

    switch ear {

    case [.both]:
        return "L+R"

    case [.left]:
        return "L"

    case [.right]:
        return "R"

    default :
        return "none"

    }

}

public func formatInteger(_ value: Int) -> String {

    let number = NSNumber(value: value)

    return integerFormatter.string(from: number) ?? "\(value)"

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

    return "\(formatDecimal(value))s/m"

}

public func formatPercentage(_ value: Float) -> String {

    let number = NSNumber(value: value)

    return percentageFormatter.string(from: number) ?? "\(value * 100.0)%"

}

public func formatPressure(_ value: NSNumber) -> String {

    return "\(formatDecimal(value))kPa"

}

public func formatRect(_ value: CGRect) -> String {

    return "\(value)"   // for now ...

}

public func formatRelativeAltitude(_ value: NSNumber) -> String {

    return "\(formatDecimal(value))m"

}

public func formatRotationRate(_ value: CMRotationRate) -> String {

    return "\(formatDecimal(value.x)), \(formatDecimal(value.y)), \(formatDecimal(value.z))"

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

    formatter.maximumFractionDigits = 3
    formatter.minimumFractionDigits = 3
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
