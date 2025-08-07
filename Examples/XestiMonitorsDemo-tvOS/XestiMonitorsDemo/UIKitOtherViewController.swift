// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XestiMonitors

public class UIKitOtherViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Private Instance Properties

    @IBOutlet private weak var focusActionLabel: UILabel!
    @IBOutlet private weak var focusHeadingLabel: UILabel!
    @IBOutlet private weak var focusNextItemLabel: UILabel!
    @IBOutlet private weak var focusPrevItemLabel: UILabel!

    private lazy var focusMonitor = FocusMonitor { [unowned self] in
        self.displayFocus($0)
    }

    private lazy var monitors: [Monitor] = [focusMonitor]

    // MARK: Private Instance Methods

    private func displayFocus(_ event: FocusMonitor.Event?) {
        if let event = event {
            switch event {
            case let .didUpdate(info):
                displayFocus("Did update", info)

            case let .movementDidFail(info):
                displayFocus("Movement did fail", info)
            }
        } else {
            displayFocus(" ", nil)
        }
    }

    private func displayFocus(_ action: String,
                              _ info: FocusMonitor.Info?) {
        focusActionLabel.text = action

        if let info = info {
            let context = info.context

            focusHeadingLabel.text = formatFocusHeading(context.focusHeading)

            if let item = context.nextFocusedItem {
                focusNextItemLabel.text = formatFocusItem(item)
            } else {
                focusNextItemLabel.text = " "
            }

            if let item = context.previouslyFocusedItem {
                focusPrevItemLabel.text = formatFocusItem(item)
            } else {
                focusPrevItemLabel.text = " "
            }
        } else {
            focusHeadingLabel.text = " "

            focusNextItemLabel.text = " "

            focusPrevItemLabel.text = " "
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayFocus(nil)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        monitors.forEach { $0.startMonitoring() }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        monitors.forEach { $0.stopMonitoring() }

        super.viewWillDisappear(animated)
    }
}
