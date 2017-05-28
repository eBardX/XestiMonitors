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
    @IBOutlet weak var announcementStringValueLabel: UILabel!
    @IBOutlet weak var announcementWasSuccessfulLabel: UILabel!
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

    lazy var announcementMonitor: AccessibilityAnnouncementMonitor = AccessibilityAnnouncementMonitor { [unowned self] in

        self.displayAnnouncement($0)

    }

    lazy var elementMonitor: AccessibilityElementMonitor = AccessibilityElementMonitor { [unowned self] in

        self.displayElement($0)

    }

    lazy var statusMonitor: AccessibilityStatusMonitor = AccessibilityStatusMonitor { [unowned self] in

        self.displayStatus($0)

    }

    lazy var monitors: [Monitor] = [self.announcementMonitor,
                                    self.elementMonitor,
                                    self.statusMonitor]

    var announcementCount = 0

    // MARK: -

    private func displayAnnouncement(_ event: AccessibilityAnnouncementMonitor.Event?) {

        if let event = event, case let .didFinish(info) = event {

            announcementStringValueLabel.text = info.stringValue

            announcementWasSuccessfulLabel.text = formatBool(info.wasSuccessful)

        } else {

            announcementStringValueLabel.text = " "

            announcementWasSuccessfulLabel.text = " "

        }

    }

    private func displayElement(_ event: AccessibilityElementMonitor.Event?) {

        if let event = event, case let .didFocus(info) = event {

            if let element = info.focusedElement {
                elementFocusedLabel.text = formatAccessibilityElement(element)
            } else {
                elementFocusedLabel.text = " "
            }

            if let technology = info.assistiveTechnology {
                elementTechnologyLabel.text = formatAssistiveTechnology(technology)
            } else {
                elementTechnologyLabel.text = " "
            }

            if let element = info.unfocusedElement {
                elementUnfocusedLabel.text = formatAccessibilityElement(element)
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

    private func displayStatus(_ event: AccessibilityStatusMonitor.Event?) {

        if let event = event {

            switch event {

            case let .assistiveTouchStatusDidChange(value):
                statusAssistiveTouchLabel.text = formatBool(value)

            case let .boldTextStatusDidChange(value):
                statusBoldTextLabel.text = formatBool(value)

            case let .closedCaptioningStatusDidChange(value):
                statusClosedCaptioningLabel.text = formatBool(value)

            case let .darkenColorsStatusDidChange(value):
                statusDarkenColorsLabel.text = formatBool(value)

            case let .grayscaleStatusDidChange(value):
                statusGrayscaleLabel.text = formatBool(value)

            case let .guidedAccessStatusDidChange(value):
                statusGuidedAccessLabel.text = formatBool(value)

            case let .hearingDevicePairedEarDidChange(value):
                statusHearingDeviceLabel.text = formatHearingDeviceEar(value)

            case let .invertColorsStatusDidChange(value):
                statusInvertColorsLabel.text = formatBool(value)

            case let .monoAudioStatusDidChange(value):
                statusMonoAudioLabel.text = formatBool(value)

            case let .reduceMotionStatusDidChange(value):
                statusReduceMotionLabel.text = formatBool(value)

            case let .reduceTransparencyStatusDidChange(value):
                statusReduceTransparencyLabel.text = formatBool(value)

            case let .shakeToUndoStatusDidChange(value):
                statusShakeToUndoLabel.text = formatBool(value)

            case let .speakScreenStatusDidChange(value):
                statusSpeakScreenLabel.text = formatBool(value)

            case let .speakSelectionStatusDidChange(value):
                statusSpeakSelectionLabel.text = formatBool(value)

            case let .switchControlStatusDidChange(value):
                statusSwitchControlLabel.text = formatBool(value)

            case let .voiceOverStatusDidChange(value):
                statusVoiceOverLabel.text = formatBool(value)

            }

        } else {

            statusAssistiveTouchLabel.text = formatBool(statusMonitor.isAssistiveTouchEnabled)

            statusBoldTextLabel.text = formatBool(statusMonitor.isBoldTextEnabled)

            statusClosedCaptioningLabel.text = formatBool(statusMonitor.isClosedCaptioningEnabled)

            statusDarkenColorsLabel.text = formatBool(statusMonitor.isDarkenColorsEnabled)

            statusGrayscaleLabel.text = formatBool(statusMonitor.isGrayscaleEnabled)

            statusGuidedAccessLabel.text = formatBool(statusMonitor.isGuidedAccessEnabled)

            statusHearingDeviceLabel.text = formatHearingDeviceEar(statusMonitor.hearingDevicePairedEar)

            statusInvertColorsLabel.text = formatBool(statusMonitor.isInvertColorsEnabled)

            statusMonoAudioLabel.text = formatBool(statusMonitor.isMonoAudioEnabled)

            statusReduceMotionLabel.text = formatBool(statusMonitor.isReduceMotionEnabled)

            statusReduceTransparencyLabel.text = formatBool(statusMonitor.isReduceTransparencyEnabled)

            statusShakeToUndoLabel.text = formatBool(statusMonitor.isShakeToUndoEnabled)

            statusSpeakScreenLabel.text = formatBool(statusMonitor.isSpeakScreenEnabled)

            statusSpeakSelectionLabel.text = formatBool(statusMonitor.isSpeakSelectionEnabled)

            statusSwitchControlLabel.text = formatBool(statusMonitor.isSwitchControlEnabled)

            statusVoiceOverLabel.text = formatBool(statusMonitor.isVoiceOverEnabled)

        }

    }

    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length

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

        displayStatus(nil)

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
