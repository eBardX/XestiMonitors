//
//  Formatters.swift
//  XestiMonitorsDemo-tvOS
//
//  Created by J. G. Pusey on 2018-01-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import Foundation
import UIKit
import XestiMonitors

public func formatAccessibilityElement(_ element: Any) -> String {
    if let accElem = element as? UIAccessibilityElement,
        let label = accElem.accessibilityLabel {
        return label
    }

    return "\(element)"
}

public func formatAssistiveTechnology(_ value: String) -> String {
    if UIAccessibility.AssistiveTechnologyIdentifier.notificationSwitchControl.rawValue == value {
        return "Switch Control"
    }

    if UIAccessibility.AssistiveTechnologyIdentifier.notificationVoiceOver.rawValue == value {
        return "VoiceOver"
    }

    return value
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

public func formatBool(_ value: Bool) -> String {
    return value ? "True" : "False"
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

public func formatFocusHeading(_ value: UIFocusHeading) -> String {
    var headings: [String] = []

    if value.contains(.down) {
        headings.append("Down")
    }

    if value.contains(.left) {
        headings.append("Left")
    }

    if value.contains(.next) {
        headings.append("Next")
    }

    if value.contains(.previous) {
        headings.append("Previous")
    }

    if value.contains(.right) {
        headings.append("Right")
    }

    if value.contains(.up) {
        headings.append("Up")
    }

    if headings.isEmpty {
        return "Unknown"
    }

    return headings.joined(separator: ", ")
}

@available(tvOS 10.0, *)
public func formatFocusItem(_ item: UIFocusItem) -> String {
    if let object = item as? NSObject {
        return String(format: "%1$@:%2$p",
                      NSStringFromClass(type(of: item)),
                      object)
    } else {
        return NSStringFromClass(type(of: item))
    }
}

public func formatHeadingComponentValues(_ x: CLHeadingComponentValue,
                                         _ y: CLHeadingComponentValue,
                                         _ z: CLHeadingComponentValue) -> String {
    return "\(formatDecimal(x)), \(formatDecimal(y)), \(formatDecimal(z))"
}

public func formatInteger(_ value: Int) -> String {
    return formatInteger(NSNumber(value: value))
}

public func formatInteger(_ value: NSNumber) -> String {
    return integerFormatter.string(from: value) ?? "\(value)"
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

public func formatLocationDistance(_ value: CLLocationDistance) -> String {
    return "\(formatDecimal(value)) m"
}

public func formatPercentage(_ value: Float) -> String {
    return formatPercentage(NSNumber(value: value))
}

public func formatPercentage(_ value: NSNumber) -> String {
    return percentageFormatter.string(from: value) ?? "\(value.floatValue * 100.0)%"
}

public func formatRect(_ value: CGRect) -> String {
    return "\(value)"   // for now ...
}

public func formatTimeInterval(_ value: TimeInterval) -> String {
    return timeIntervalFormatter.string(from: value) ?? "\(value)"
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
