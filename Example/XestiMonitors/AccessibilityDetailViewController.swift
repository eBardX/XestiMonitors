//
//  AccessibilityDetailViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

class AccessibilityDetailViewController: UITableViewController {

    @IBOutlet weak var statusAssistiveTouchLabel: UILabel!
    @IBOutlet weak var statusBoldTextLabel: UILabel!
    @IBOutlet weak var statusClosedCaptioningLabel: UILabel!
    @IBOutlet weak var statusDarkenColorsLabel: UILabel!
    @IBOutlet weak var statusGrayscaleLabel: UILabel!
    @IBOutlet weak var statusGuidedAccessLabel: UILabel!
    @IBOutlet weak var statusHearingDeviceLabel: UILabel!
    @IBOutlet weak var statusInvertColorsLabel: UILabel!
    @IBOutlet weak var statusMonoAudioLabel: UILabel!
    @IBOutlet weak var statusReduceMotionLabel: UILabel!
    @IBOutlet weak var statusReduceTransparencyLabel: UILabel!
    @IBOutlet weak var statusShakeToUndoLabel: UILabel!
    @IBOutlet weak var statusSpeakScreenLabel: UILabel!
    @IBOutlet weak var statusSpeakSelectionLabel: UILabel!
    @IBOutlet weak var statusSwitchControlLabel: UILabel!
    @IBOutlet weak var statusVoiceOverLabel: UILabel!

    lazy var accessibilityStatusMonitor: AccessibilityStatusMonitor = AccessibilityStatusMonitor { [weak self] in

        self?.displayAccessibilityStatus($0)

    }

    lazy var monitors: [Monitor] = [self.accessibilityStatusMonitor]

    // MARK: -

    // swiftlint:disable cyclomatic_complexity

    private func displayAccessibilityStatus(_ event: AccessibilityStatusMonitor.Event) {

            switch event {

            case let .assistiveTouchStatusDidChange(value):
                statusAssistiveTouchLabel.text = "\(value)"

            case let .boldTextStatusDidChange(value):
                statusBoldTextLabel.text = "\(value)"

            case let .closedCaptioningStatusDidChange(value):
                statusClosedCaptioningLabel.text = "\(value)"

            case let .darkenSystemColorsStatusDidChange(value):
                statusDarkenColorsLabel.text = "\(value)"

            case let .grayscaleStatusDidChange(value):
                statusGrayscaleLabel.text = "\(value)"

            case let .guidedAccessStatusDidChange(value):
                statusGuidedAccessLabel.text = "\(value)"

            case let .hearingDevicePairedEarDidChange(value):
                statusHearingDeviceLabel.text = formatHearingDeviceEar(value)

            case let .invertColorsStatusDidChange(value):
                statusInvertColorsLabel.text = "\(value)"

            case let .monoAudioStatusDidChange(value):
                statusMonoAudioLabel.text = "\(value)"

            case let .reduceMotionStatusDidChange(value):
                statusReduceMotionLabel.text = "\(value)"

            case let .reduceTransparencyStatusDidChange(value):
                statusReduceTransparencyLabel.text = "\(value)"

            case let .shakeToUndoStatusDidChange(value):
                statusShakeToUndoLabel.text = "\(value)"

            case let .speakScreenStatusDidChange(value):
                statusSpeakScreenLabel.text = "\(value)"

            case let .speakSelectionStatusDidChange(value):
                statusSpeakSelectionLabel.text = "\(value)"

            case let .switchControlStatusDidChange(value):
                statusSwitchControlLabel.text = "\(value)"

            case let .voiceOverStatusDidChange(value):
                statusVoiceOverLabel.text = "\(value)"

            }

    }

    // swiftlint:enable cyclomatic_complexity

    private func displayAccessibilityStatus() {

        statusAssistiveTouchLabel.text = "\(accessibilityStatusMonitor.isAssistiveTouchRunning)"

        statusBoldTextLabel.text = "\(accessibilityStatusMonitor.isBoldTextEnabled)"

        statusClosedCaptioningLabel.text = "\(accessibilityStatusMonitor.isClosedCaptioningEnabled)"

        statusDarkenColorsLabel.text = "\(accessibilityStatusMonitor.isDarkenColorsEnabled)"

        statusGrayscaleLabel.text = "\(accessibilityStatusMonitor.isGrayscaleEnabled)"

        statusGuidedAccessLabel.text = "\(accessibilityStatusMonitor.isGuidedAccessEnabled)"

        statusHearingDeviceLabel.text = formatHearingDeviceEar(accessibilityStatusMonitor.hearingDevicePairedEar)

        statusInvertColorsLabel.text = "\(accessibilityStatusMonitor.isInvertColorsEnabled)"

        statusMonoAudioLabel.text = "\(accessibilityStatusMonitor.isMonoAudioEnabled)"

        statusReduceMotionLabel.text = "\(accessibilityStatusMonitor.isReduceMotionEnabled)"

        statusReduceTransparencyLabel.text = "\(accessibilityStatusMonitor.isReduceTransparencyEnabled)"

        statusShakeToUndoLabel.text = "\(accessibilityStatusMonitor.isShakeToUndoEnabled)"

        statusSpeakScreenLabel.text = "\(accessibilityStatusMonitor.isSpeakScreenEnabled)"

        statusSpeakSelectionLabel.text = "\(accessibilityStatusMonitor.isSpeakSelectionEnabled)"

        statusSwitchControlLabel.text = "\(accessibilityStatusMonitor.isSwitchControlRunning)"

        statusVoiceOverLabel.text = "\(accessibilityStatusMonitor.isVoiceOverRunning)"

    }

    private func formatHearingDeviceEar(_ ear: AccessibilityStatusMonitor.HearingDeviceEar) -> String {

        switch ear {

        case [.both]:
            return "Both"

        case [.left]:
            return "Left"

        case [.right]:
            return "Right"

        default :
            return "None"

        }

    }

    // MARK: -

    override func viewDidLoad() {

        super.viewDidLoad()

        displayAccessibilityStatus()

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
