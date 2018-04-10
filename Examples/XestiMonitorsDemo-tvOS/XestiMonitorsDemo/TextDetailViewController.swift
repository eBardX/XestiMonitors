//
//  TextDetailViewController.swift
//  XestiMonitorsDemo-tvOS
//
//  Created by J. G. Pusey on 2018-04-08.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

public class TextDetailViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textFieldTextActionLabel: UILabel!
    @IBOutlet private weak var textInputModePrimaryLanguageLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewTextActionLabel: UILabel!

    private lazy var textFieldTextMonitor = TextFieldTextMonitor(textField: textField,
                                                                 options: .all,
                                                                 queue: .main) { [unowned self] in
                                                                    self.displayTextFieldText($0)
    }

    private lazy var textInputModeMonitor = TextInputModeMonitor(queue: .main) { [unowned self] in
        self.displayTextInputMode($0)
    }

    private lazy var textViewTextMonitor = TextViewTextMonitor(textView: textView,
                                                               options: .all,
                                                               queue: .main) { [unowned self] in
                                                                self.displayTextViewText($0)
    }

    private lazy var monitors: [Monitor] = [textFieldTextMonitor,
                                            textInputModeMonitor,
                                            textViewTextMonitor]

    // MARK: Private Instance Methods

    private func determineTextInputMode() -> UITextInputMode? {
        if textField.isFirstResponder {
            return textField.textInputMode
        }

        if textView.isFirstResponder {
            return textView.textInputMode
        }

        return nil
    }

    private func displayTextFieldText(_ event: TextFieldTextMonitor.Event?) {
        if let event = event {
            switch event {
            case let .didBeginEditing(tf):
                if tf == textField {
                    textFieldTextActionLabel.text = "Did begin editing"
                }

            case let .didChange(tf):
                if tf == textField {
                    textFieldTextActionLabel.text = "Did change"
                }

            case let .didEndEditing(tf):
                if tf == textField {
                    textFieldTextActionLabel.text = "Did end editing"
                }
            }
        } else {
            textFieldTextActionLabel.text = " "
        }
    }

    private func displayTextInputMode(_ event: TextInputModeMonitor.Event?) {
        if let event = event,
            case let .didChange(textInputMode) = event {
            let mode = textInputMode ?? determineTextInputMode()

            textInputModePrimaryLanguageLabel.text = mode?.primaryLanguage ?? "Unknown"
        } else {
            textInputModePrimaryLanguageLabel.text = "Unknown"
        }
    }

    private func displayTextViewText(_ event: TextViewTextMonitor.Event?) {
        if let event = event {
            switch event {
            case let .didBeginEditing(tv):
                if tv == textView {
                    textViewTextActionLabel.text = "Did begin editing"
                }

            case let .didChange(tv):
                if tv == textView {
                    textViewTextActionLabel.text = "Did change"
                }

            case let .didEndEditing(tv):
                if tv == textView {
                    textViewTextActionLabel.text = "Did end editing"
                }
            }
        } else {
            textViewTextActionLabel.text = " "
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        textView.isSelectable = true

        displayTextFieldText(nil)
        displayTextInputMode(nil)
        displayTextViewText(nil)
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
            let tfSuperview = textField?.superview,
            let tvSuperview = textView?.superview,
            (cell.contentView == tfSuperview
                || cell.contentView == tvSuperview) {
            return false
        }

        return true
    }
}
