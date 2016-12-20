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

func formatAcceleration(_ value: CMAcceleration) -> String {

    return "\(formatDecimal(value.x)), \(formatDecimal(value.y)), \(formatDecimal(value.z))"

}

func formatBackgroundRefreshStatus(_ value: UIBackgroundRefreshStatus) -> String {

    switch value {

    case .available:
        return "Available"

    case .denied:
        return "Denied"

    case .restricted:
        return "Restricted"

    }

}

func formatDecimal (_ value: Double) -> String {

    let number = NSNumber(value: value)

    return decimalFormatter.string(from: number) ?? "\(value)"

}

func formatDeviceBatteryStateAndLevel(_ state: UIDeviceBatteryState,
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

func formatDeviceOrientation(_ value: UIDeviceOrientation) -> String {

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

func formatInterfaceOrientation(_ value: UIInterfaceOrientation) -> String {

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

func formatPercentage (_ value: Float) -> String {

    let number = NSNumber(value: value)

    return percentageFormatter.string(from: number) ?? "\(value * 100.0)%"

}

func formatTimeInterval (_ value: TimeInterval) -> String {

    return timeIntervalFormatter.string(from: value) ?? "\(value)"

}

func formatViewAnimationCurve(_ value: UIViewAnimationCurve) -> String {

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

private var decimalFormatter: NumberFormatter = {

    var formatter = NumberFormatter()

    formatter.maximumFractionDigits = 3
    formatter.minimumFractionDigits = 3
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = true

    return formatter

} ()

private var percentageFormatter: NumberFormatter = {

    var formatter = NumberFormatter()

    formatter.maximumFractionDigits = 1
    formatter.numberStyle = .percent
    formatter.usesGroupingSeparator = true

    return formatter

} ()

private var timeIntervalFormatter: DateComponentsFormatter = {

    var formatter = DateComponentsFormatter()

    formatter.allowedUnits = [.day, .hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad

    return formatter

} ()
