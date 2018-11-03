//
//  UIKitAccessibilityViewController.swift
//  XestiMonitorsDemo-tvOS
//
//  Created by J. G. Pusey on 2018-01-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

public class UIKitAccessibilityViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var announcementButton: UIButton!
    @IBOutlet private weak var announcementStringValueLabel: UILabel!
    @IBOutlet private weak var announcementWasSuccessfulLabel: UILabel!
    @IBOutlet private weak var elementFocusedLabel: UILabel!
    @IBOutlet private weak var elementTechnologyLabel: UILabel!
    @IBOutlet private weak var elementUnfocusedLabel: UILabel!
    @IBOutlet private weak var statusAssistiveTouchLabel: UILabel!
    @IBOutlet private weak var statusBoldTextLabel: UILabel!
    @IBOutlet private weak var statusClosedCaptioningLabel: UILabel!
    @IBOutlet private weak var statusDarkenColorsLabel: UILabel!
    @IBOutlet private weak var statusGrayscaleLabel: UILabel!
    @IBOutlet private weak var statusGuidedAccessLabel: UILabel!
    @IBOutlet private weak var statusInvertColorsLabel: UILabel!
    @IBOutlet private weak var statusMonoAudioLabel: UILabel!
    @IBOutlet private weak var statusReduceMotionLabel: UILabel!
    @IBOutlet private weak var statusReduceTransparencyLabel: UILabel!
    @IBOutlet private weak var statusShakeToUndoLabel: UILabel!
    @IBOutlet private weak var statusSpeakScreenLabel: UILabel!
    @IBOutlet private weak var statusSpeakSelectionLabel: UILabel!
    @IBOutlet private weak var statusSwitchControlLabel: UILabel!
    @IBOutlet private weak var statusVoiceOverLabel: UILabel!

    private lazy var announcementMonitor = AccessibilityAnnouncementMonitor(queue: .main) { [unowned self] in
        self.displayAnnouncement($0)
    }

    private lazy var elementMonitor = AccessibilityElementMonitor(queue: .main) { [unowned self] in
        self.displayElement($0)
    }

    private lazy var statusMonitor = AccessibilityStatusMonitor(options: .all,
                                                                queue: .main) { [unowned self] in
        self.displayStatus($0)
    }

    private lazy var monitors: [Monitor] = [announcementMonitor,
                                            elementMonitor,
                                            statusMonitor]

    private var announcementCount = 0

    // MARK: Private Instance Methods

    private func displayAnnouncement(_ event: AccessibilityAnnouncementMonitor.Event?) {
        if let event = event,
            case let .didFinish(info) = event {
            announcementStringValueLabel.text = info.stringValue

            announcementWasSuccessfulLabel.text = formatBool(info.wasSuccessful)
        } else {
            announcementStringValueLabel.text = " "

            announcementWasSuccessfulLabel.text = " "
        }
    }

    private func displayElement(_ event: AccessibilityElementMonitor.Event?) {
        if let event = event,
            case let .didFocus(info) = event {
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
            if #available(tvOS 10.0, *) {
                statusAssistiveTouchLabel.text = formatBool(statusMonitor.isAssistiveTouchEnabled)
            } else {
                statusAssistiveTouchLabel.text = " "
            }

            statusBoldTextLabel.text = formatBool(statusMonitor.isBoldTextEnabled)

            statusClosedCaptioningLabel.text = formatBool(statusMonitor.isClosedCaptioningEnabled)

            statusDarkenColorsLabel.text = formatBool(statusMonitor.isDarkenColorsEnabled)

            statusGrayscaleLabel.text = formatBool(statusMonitor.isGrayscaleEnabled)

            statusGuidedAccessLabel.text = formatBool(statusMonitor.isGuidedAccessEnabled)

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

    @IBAction private func announcementButtonPressed() {
        announcementCount += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIAccessibility.post(notification: UIAccessibility.Notification.announcement,
                                            argument: "Announcement #\(self.announcementCount)")
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayAnnouncement(nil)
        displayElement(nil)
        displayStatus(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        monitors.forEach { $0.startMonitoring() }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        monitors.forEach { $0.stopMonitoring() }

        super.viewWillDisappear(animated)
    }

    // MARK: - UITableViewDelegate

    override public func tableView(_ tableView: UITableView,
                                   canFocusRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath),
            let abSuperview = announcementButton?.superview,
            cell.contentView == abSuperview {
            return false
        }

        return true
    }
}
