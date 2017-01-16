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
    @IBOutlet weak var settingsAssistiveTouchLabel: UILabel!
    @IBOutlet weak var settingsBoldTextLabel: UILabel!
    @IBOutlet weak var settingsClosedCaptioningLabel: UILabel!
    @IBOutlet weak var settingsDarkenColorsLabel: UILabel!
    @IBOutlet weak var settingsGrayscaleLabel: UILabel!
    @IBOutlet weak var settingsGuidedAccessLabel: UILabel!
    @IBOutlet weak var settingsHearingDeviceLabel: UILabel!
    @IBOutlet weak var settingsInvertColorsLabel: UILabel!
    @IBOutlet weak var settingsMonoAudioLabel: UILabel!
    @IBOutlet weak var settingsReduceMotionLabel: UILabel!
    @IBOutlet weak var settingsReduceTransparencyLabel: UILabel!
    @IBOutlet weak var settingsShakeToUndoLabel: UILabel!
    @IBOutlet weak var settingsSpeakScreenLabel: UILabel!
    @IBOutlet weak var settingsSpeakSelectionLabel: UILabel!
    @IBOutlet weak var settingsSwitchControlLabel: UILabel!
    @IBOutlet weak var settingsVoiceOverLabel: UILabel!

    lazy var announcementMonitor: AccessibilityAnnouncementMonitor = AccessibilityAnnouncementMonitor { [weak self] in

        self?.displayAnnouncement($0)

    }

    lazy var settingsMonitor: AccessibilitySettingsMonitor = AccessibilitySettingsMonitor { [weak self] in

        self?.displaySettings($0)

    }

    lazy var monitors: [Monitor] = [self.announcementMonitor,
                                    self.settingsMonitor]

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

    // swiftlint:disable cyclomatic_complexity

    private func displaySettings(_ event: AccessibilitySettingsMonitor.Event) {

        switch event {

        case let .assistiveTouchStatusDidChange(value):
            settingsAssistiveTouchLabel.text = "\(value)"

        case let .boldTextStatusDidChange(value):
            settingsBoldTextLabel.text = "\(value)"

        case let .closedCaptioningStatusDidChange(value):
            settingsClosedCaptioningLabel.text = "\(value)"

        case let .darkenColorsStatusDidChange(value):
            settingsDarkenColorsLabel.text = "\(value)"

        case let .grayscaleStatusDidChange(value):
            settingsGrayscaleLabel.text = "\(value)"

        case let .guidedAccessStatusDidChange(value):
            settingsGuidedAccessLabel.text = "\(value)"

        case let .hearingDevicePairedEarDidChange(value):
            settingsHearingDeviceLabel.text = formatHearingDeviceEar(value)

        case let .invertColorsStatusDidChange(value):
            settingsInvertColorsLabel.text = "\(value)"

        case let .monoAudioStatusDidChange(value):
            settingsMonoAudioLabel.text = "\(value)"

        case let .reduceMotionStatusDidChange(value):
            settingsReduceMotionLabel.text = "\(value)"

        case let .reduceTransparencyStatusDidChange(value):
            settingsReduceTransparencyLabel.text = "\(value)"

        case let .shakeToUndoStatusDidChange(value):
            settingsShakeToUndoLabel.text = "\(value)"

        case let .speakScreenStatusDidChange(value):
            settingsSpeakScreenLabel.text = "\(value)"

        case let .speakSelectionStatusDidChange(value):
            settingsSpeakSelectionLabel.text = "\(value)"

        case let .switchControlStatusDidChange(value):
            settingsSwitchControlLabel.text = "\(value)"

        case let .voiceOverStatusDidChange(value):
            settingsVoiceOverLabel.text = "\(value)"

        }

    }

    // swiftlint:enable cyclomatic_complexity

    private func displaySettings() {

        settingsAssistiveTouchLabel.text = "\(settingsMonitor.isAssistiveTouchRunning)"

        settingsBoldTextLabel.text = "\(settingsMonitor.isBoldTextEnabled)"

        settingsClosedCaptioningLabel.text = "\(settingsMonitor.isClosedCaptioningEnabled)"

        settingsDarkenColorsLabel.text = "\(settingsMonitor.isDarkenColorsEnabled)"

        settingsGrayscaleLabel.text = "\(settingsMonitor.isGrayscaleEnabled)"

        settingsGuidedAccessLabel.text = "\(settingsMonitor.isGuidedAccessEnabled)"

        settingsHearingDeviceLabel.text = formatHearingDeviceEar(settingsMonitor.hearingDevicePairedEar)

        settingsInvertColorsLabel.text = "\(settingsMonitor.isInvertColorsEnabled)"

        settingsMonoAudioLabel.text = "\(settingsMonitor.isMonoAudioEnabled)"

        settingsReduceMotionLabel.text = "\(settingsMonitor.isReduceMotionEnabled)"

        settingsReduceTransparencyLabel.text = "\(settingsMonitor.isReduceTransparencyEnabled)"

        settingsShakeToUndoLabel.text = "\(settingsMonitor.isShakeToUndoEnabled)"

        settingsSpeakScreenLabel.text = "\(settingsMonitor.isSpeakScreenEnabled)"

        settingsSpeakSelectionLabel.text = "\(settingsMonitor.isSpeakSelectionEnabled)"

        settingsSwitchControlLabel.text = "\(settingsMonitor.isSwitchControlRunning)"

        settingsVoiceOverLabel.text = "\(settingsMonitor.isVoiceOverRunning)"

    }

    private func formatHearingDeviceEar(_ ear: AccessibilitySettingsMonitor.HearingDeviceEar) -> String {

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

        displaySettings()

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
