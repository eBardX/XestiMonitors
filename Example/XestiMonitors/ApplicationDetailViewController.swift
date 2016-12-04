//
//  ApplicationDetailViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

class ApplicationDetailViewController: UITableViewController {

    @IBOutlet weak var applicationLabel: UILabel!
    @IBOutlet weak var backgroundRefreshLabel: UILabel!
    @IBOutlet weak var memoryButton: UIButton!
    @IBOutlet weak var memoryLabel: UILabel!
    @IBOutlet weak var protectedDataLabel: UILabel!
    @IBOutlet weak var screenshotLabel: UILabel!
    @IBOutlet weak var statusBarActionLabel: UILabel!
    @IBOutlet weak var statusBarFrameLabel: UILabel!
    @IBOutlet weak var statusBarOrientationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    lazy var applicationStateMonitor: ApplicationStateMonitor = ApplicationStateMonitor { [weak self] in

        self?.displayApplication($0)

    }

    lazy var backgroundRefreshMonitor: BackgroundRefreshMonitor = BackgroundRefreshMonitor { [weak self] in

        self?.displayBackgroundRefresh($0)

    }

    lazy var memoryMonitor: MemoryMonitor = MemoryMonitor { [weak self] in

        self?.displayMemory()

    }

    lazy var protectedDataMonitor: ProtectedDataMonitor = ProtectedDataMonitor { [weak self] in

        self?.displayProtectedData($0)

    }

    lazy var screenshotMonitor: ScreenshotMonitor = ScreenshotMonitor { [weak self] in

        self?.displayScreenshot()

    }

    lazy var statusBarMonitor: StatusBarMonitor = StatusBarMonitor { [weak self] in

        self?.displayStatusBar($0)

    }

    lazy var timeMonitor: TimeMonitor = TimeMonitor { [weak self] in

        self?.displayTime()

    }

    lazy var monitors: [Monitor] = [self.applicationStateMonitor,
                                    self.backgroundRefreshMonitor,
                                    self.memoryMonitor,
                                    self.protectedDataMonitor,
                                    self.screenshotMonitor,
                                    self.statusBarMonitor,
                                    self.timeMonitor]

    var memoryCount = -1
    var screenshotCount = -1
    var timeCount = -1

    // MARK: -

    private func displayApplication(_ event: ApplicationStateMonitor.Event?) {

        var text: String

        if let event = event {

            switch event {

            case .didBecomeActive:
                text = "Did become active"

            case .didEnterBackground:
                text = "Did enter background"

            case .didFinishLaunching:
                text = "Did finish launching"

            case .willEnterForeground:
                text = "Will enter foreground"

            case .willResignActive:
                text = "Will resign active"

            case .willTerminate:
                text = "Will terminate"

            }

        } else {

            text = " "

        }

        applicationLabel.text = text

    }

    private func displayBackgroundRefresh(_ status: UIBackgroundRefreshStatus) {

        var text: String

        switch status {

        case .available:
            text = "Available"

        case .denied:
            text = "Denied"

        case .restricted:
            text = "Restricted"

        }

        backgroundRefreshLabel.text = text

    }

    private func displayMemory() {

        memoryCount += 1

        memoryLabel.text = "\(memoryCount)"

    }

    private func displayProtectedData(_ event: ProtectedDataMonitor.Event?) {

        var text: String

        if let event = event {

            switch event {

            case .didBecomeAvailable:
                text = "Did become available"

            case .willBecomeUnavailable:
                text = "Will become unavailable"

            }

        } else {

            text = " "

        }

        protectedDataLabel.text = text

    }

    private func displayScreenshot() {

        screenshotCount += 1

        screenshotLabel.text = "\(screenshotCount)"

    }

    private func displayStatusBar(_ event: StatusBarMonitor.Event?) {

        if let event = event {

            switch event {

            case let .didChangeFrame(frame):
                displayStatusBar("Did change frame", frame, statusBarMonitor.orientation)

            case let .didChangeOrientation(orientation):
                displayStatusBar("Did change orientation", statusBarMonitor.frame, orientation)

            case let .willChangeFrame(frame):
                displayStatusBar("Will change frame", frame, statusBarMonitor.orientation)

            case let .willChangeOrientation(orientation):
                displayStatusBar("Will change orientation", statusBarMonitor.frame, orientation)

            }

        } else {

            displayStatusBar(" ", statusBarMonitor.frame, statusBarMonitor.orientation)

        }

    }

    private func displayStatusBar(_ action: String,
                                  _ frame: CGRect,
                                  _ orientation: UIInterfaceOrientation) {

        statusBarActionLabel.text = action

        statusBarFrameLabel.text = "\(frame)"

        statusBarOrientationLabel.text = formatOrientation(orientation)

    }

    private func displayTime() {

        timeCount += 1

        timeLabel.text = "\(timeCount)"

    }

    private func formatOrientation(_ orientation: UIInterfaceOrientation) -> String {

        switch orientation {

        case .landscapeLeft:
            return "Landscape left"

        case .landscapeRight:
            return "Landscape right"

        case .portrait:
            return "Portrait"

        case .portraitUpsideDown:
            return "Portrait upside down"

        default:
            return "Unknown"

        }

    }

    @IBAction private func memoryButtonTapped() {

        UIControl().sendAction(Selector(("_performMemoryWarning")),
                               to: UIApplication.shared,
                               for: nil)

    }

    // MARK: -

    override func viewDidLoad() {

        super.viewDidLoad()

        displayApplication(nil)

        displayBackgroundRefresh(backgroundRefreshMonitor.status)

        displayMemory()

        displayProtectedData(nil)

        displayScreenshot()

        displayStatusBar(nil)

        displayTime()

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
