// © 2018–2025 John Gary Pusey (see LICENSE.md).

import UIKit
import XestiMonitors

public class UIKitScreenViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var brightnessLevelLabel: UILabel!

    private lazy var screenBrightnessMonitor = ScreenMonitor(screen: .main) { [unowned self] in
        self.displayScreenBrightness($0)
    }

    private lazy var monitors: [Monitor] = [screenBrightnessMonitor]

    // MARK: Private Instance Methods

    private func displayScreenBrightness(_ event: ScreenMonitor.Event?) {
        if let event = event,
           case let .brightnessDidChange(screen) = event {
            brightnessLevelLabel.text = formatPercentage(Float(screen.brightness))
        } else {
            brightnessLevelLabel.text = formatPercentage(Float(UIScreen.main.brightness))
        }
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayScreenBrightness(nil)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        monitors.forEach { $0.startMonitoring() }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        monitors.forEach { $0.stopMonitoring() }
    }
}
