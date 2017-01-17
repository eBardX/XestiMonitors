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

    @IBOutlet weak var announcementButton: UIButton!
    @IBOutlet weak var announcementDidSucceedLabel: UILabel!
    @IBOutlet weak var announcementTextLabel: UILabel!
    @IBOutlet weak var elementFocusedLabel: UILabel!
    @IBOutlet weak var elementTechnologyLabel: UILabel!
    @IBOutlet weak var elementUnfocusedLabel: UILabel!
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

    lazy var announcementMonitor: AccessibilityAnnouncementMonitor = AccessibilityAnnouncementMonitor { [weak self] in

        self?.displayAnnouncement($0)

    }

    lazy var elementMonitor: AccessibilityElementMonitor = AccessibilityElementMonitor { [weak self] in

        self?.displayElement($0)

    }

    lazy var statusMonitor: AccessibilityStatusMonitor = AccessibilityStatusMonitor { [weak self] in

        self?.displaySettings($0)

    }

    lazy var monitors: [Monitor] = [self.announcementMonitor,
                                    self.elementMonitor,
                                    self.statusMonitor]

    var announcementCount = 0

    // MARK: -

    private func displayAnnouncement(_ info: AccessibilityAnnouncementMonitor.Info?) {

        if let info = info {

            announcementDidSucceedLabel.text = "\(info.didSucceed)"

            announcementTextLabel.text = info.text

        } else {

            announcementDidSucceedLabel.text = " "

            announcementTextLabel.text = " "

        }

    }

    private func displayElement(_ info: AccessibilityElementMonitor.Info?) {

        if let info = info {

            if let element = info.focusedElement {
                elementFocusedLabel.text = formatElement(element)
            } else {
                elementFocusedLabel.text = " "
            }

            if let technology = info.assistiveTechnology {
                elementTechnologyLabel.text = formatAssistiveTechnology(technology)
            } else {
                elementTechnologyLabel.text = " "
            }

            if let element = info.unfocusedElement {
                elementUnfocusedLabel.text = formatElement(element)
            } else {
                elementUnfocusedLabel.text = " "
            }

        } else {

            elementFocusedLabel.text = " "

            elementTechnologyLabel.text = " "

            elementUnfocusedLabel.text = " "

        }

    }

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length

    private func displaySettings(_ event: AccessibilityStatusMonitor.Event?) {

        if let event = event {

            switch event {

            case let .assistiveTouchStatusDidChange(value):
                statusAssistiveTouchLabel.text = "\(value)"

            case let .boldTextStatusDidChange(value):
                statusBoldTextLabel.text = "\(value)"

            case let .closedCaptioningStatusDidChange(value):
                statusClosedCaptioningLabel.text = "\(value)"

            case let .darkenColorsStatusDidChange(value):
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

        } else {

            statusAssistiveTouchLabel.text = "\(statusMonitor.isAssistiveTouchRunning)"

            statusBoldTextLabel.text = "\(statusMonitor.isBoldTextEnabled)"

            statusClosedCaptioningLabel.text = "\(statusMonitor.isClosedCaptioningEnabled)"

            statusDarkenColorsLabel.text = "\(statusMonitor.isDarkenColorsEnabled)"

            statusGrayscaleLabel.text = "\(statusMonitor.isGrayscaleEnabled)"

            statusGuidedAccessLabel.text = "\(statusMonitor.isGuidedAccessEnabled)"

            statusHearingDeviceLabel.text = formatHearingDeviceEar(statusMonitor.hearingDevicePairedEar)

            statusInvertColorsLabel.text = "\(statusMonitor.isInvertColorsEnabled)"

            statusMonoAudioLabel.text = "\(statusMonitor.isMonoAudioEnabled)"

            statusReduceMotionLabel.text = "\(statusMonitor.isReduceMotionEnabled)"

            statusReduceTransparencyLabel.text = "\(statusMonitor.isReduceTransparencyEnabled)"

            statusShakeToUndoLabel.text = "\(statusMonitor.isShakeToUndoEnabled)"

            statusSpeakScreenLabel.text = "\(statusMonitor.isSpeakScreenEnabled)"

            statusSpeakSelectionLabel.text = "\(statusMonitor.isSpeakSelectionEnabled)"

            statusSwitchControlLabel.text = "\(statusMonitor.isSwitchControlRunning)"

            statusVoiceOverLabel.text = "\(statusMonitor.isVoiceOverRunning)"

        }

    }

    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length

    private func formatElement(_ element: Any) -> String {

        if let accelem = element as? UIAccessibilityElement,
            let label = accelem.accessibilityLabel {
            return label
        }

        return "\(element)"

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

    @IBAction private func announcementButtonTapped() {

        announcementCount += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,
                                            "Announcement #\(self.announcementCount)")

        }

    }

    // MARK: -

    override func viewDidLoad() {

        super.viewDidLoad()

        displayAnnouncement(nil)

        displayElement(nil)

        displaySettings(nil)

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
