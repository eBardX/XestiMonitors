//
//  UIKitOtherViewController.swift
//  XestiMonitorsDemo-iOS
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

public class UIKitOtherViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Private Instance Properties

    private let pasteboard: UIPasteboard = .general

    @IBOutlet private weak var keyboardActionLabel: UILabel!
    @IBOutlet private weak var keyboardAnimationCurveLabel: UILabel!
    @IBOutlet private weak var keyboardAnimationDurationLabel: UILabel!
    @IBOutlet private weak var keyboardFrameBeginLabel: UILabel!
    @IBOutlet private weak var keyboardFrameEndLabel: UILabel!
    @IBOutlet private weak var keyboardIsLocalLabel: UILabel!
    @IBOutlet private weak var keyboardTextField: UITextField!
    @IBOutlet private weak var pasteboardActionLabel: UILabel!
    @IBOutlet private weak var pasteboardTypesAddedLabel: UILabel!
    @IBOutlet private weak var pasteboardTypesRemovedLabel: UILabel!

    private lazy var keyboardMonitor = KeyboardMonitor(options: .all,
                                                       queue: .main) { [unowned self] in
                                                        self.displayKeyboard($0)
    }

    private lazy var pasteboardMonitor = PasteboardMonitor(pasteboard: pasteboard,
                                                           options: .all,
                                                           queue: .main) { [unowned self] in
                                                            self.displayPasteboard($0)
    }

    private lazy var monitors: [Monitor] = [keyboardMonitor,
                                            pasteboardMonitor]

    // MARK: Private Instance Methods

    private func displayKeyboard(_ event: KeyboardMonitor.Event?) {
        if let event = event {
            switch event {
            case let .didChangeFrame(info):
                displayKeyboard("Did change frame", info)

            case let .didHide(info):
                displayKeyboard("Did hide", info)

            case let .didShow(info):
                displayKeyboard("Did show", info)

            case let .willChangeFrame(info):
                displayKeyboard("Will change frame", info)

            case let .willHide(info):
                displayKeyboard("Will hide", info)

            case let .willShow(info):
                displayKeyboard("Will show", info)
            }
        } else {
            displayKeyboard(" ", nil)
        }
    }

    private func displayKeyboard(_ action: String,
                                 _ info: KeyboardMonitor.Info?) {
        if let info = info {
            keyboardAnimationCurveLabel.text = formatViewAnimationCurve(info.animationCurve)

            keyboardAnimationDurationLabel.text = formatTimeInterval(info.animationDuration)

            keyboardFrameBeginLabel.text = formatRect(info.frameBegin)

            keyboardFrameEndLabel.text = formatRect(info.frameEnd)

            keyboardIsLocalLabel.text = formatBool(info.isLocal)
        } else {
            keyboardAnimationCurveLabel.text = " "

            keyboardAnimationDurationLabel.text = " "

            keyboardFrameBeginLabel.text = " "

            keyboardFrameEndLabel.text = " "

            keyboardIsLocalLabel.text = " "
        }

        keyboardActionLabel.text = action
    }

    private func displayPasteboard(_ event: PasteboardMonitor.Event?) {
        if let event = event {
            switch event {
            case let .changed(_, changes):
                displayPasteboard("Changed", changes)

            case .removed:
                displayPasteboard("Removed")
            }
        } else {
            displayPasteboard(" ", nil)
        }
    }

    private func displayPasteboard(_ action: String,
                                   _ changes: PasteboardMonitor.Changes? = nil) {
        if let changes = changes {
            pasteboardTypesAddedLabel.text = changes.typesAdded.joined(separator: ", ")

            pasteboardTypesRemovedLabel.text = changes.typesRemoved.joined(separator: ", ")
        } else {
            pasteboardTypesRemovedLabel.text = " "

            pasteboardTypesAddedLabel.text = " "
        }

        pasteboardActionLabel.text = action
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        keyboardTextField.delegate = self

        displayKeyboard(nil)
        displayPasteboard(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        monitors.forEach { $0.startMonitoring() }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        monitors.forEach { $0.stopMonitoring() }

        super.viewWillDisappear(animated)
    }

    // MARK: - UITextFieldDelegate

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.text = ""

        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }

        return false
    }
}
