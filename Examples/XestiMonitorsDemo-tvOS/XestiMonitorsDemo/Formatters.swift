//
//  Formatters.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

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
    if UIAccessibilityNotificationSwitchControlIdentifier == value {
        return "Switch Control"
    }

    if UIAccessibilityNotificationVoiceOverIdentifier == value {
        return "VoiceOver"
    }

    return value
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

public func formatInteger(_ value: Int) -> String {
    let number = NSNumber(value: value)

    return integerFormatter.string(from: number) ?? "\(value)"
}

public func formatInteger(_ value: NSNumber) -> String {
    return integerFormatter.string(from: value) ?? "\(value)"
}

public func formatPercentage(_ value: Float) -> String {
    let number = NSNumber(value: value)

    return percentageFormatter.string(from: number) ?? "\(value * 100.0)%"
}

public func formatRect(_ value: CGRect) -> String {
    return "\(value)"   // for now ...
}

public func formatRelativeAltitude(_ value: NSNumber) -> String {
    return "\(formatDecimal(value))m"
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
