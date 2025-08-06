// © 2016–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XestiMonitors

public class UIKitApplicationViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var appStateLabel: UILabel!
    @IBOutlet private weak var backgroundRefreshLabel: UILabel!
    @IBOutlet private weak var memoryButton: UIButton!
    @IBOutlet private weak var memoryLabel: UILabel!
    @IBOutlet private weak var protectedDataLabel: UILabel!
    @IBOutlet private weak var screenshotLabel: UILabel!
    @IBOutlet private weak var statusBarActionLabel: UILabel!
    @IBOutlet private weak var statusBarFrameLabel: UILabel!
    @IBOutlet private weak var statusBarOrientationLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    private lazy var appStateMonitor = AppStateMonitor { [unowned self] in
        self.displayAppState($0)
    }

    private lazy var backgroundRefreshMonitor = BackgroundRefreshMonitor { [unowned self] in
        self.displayBackgroundRefresh($0)
    }

    private lazy var memoryMonitor = MemoryMonitor { [unowned self] in
        self.displayMemory($0)
    }

    private lazy var protectedDataMonitor = ProtectedDataMonitor { [unowned self] in
        self.displayProtectedData($0)
    }

    private lazy var screenshotMonitor = ScreenshotMonitor { [unowned self] in
        self.displayScreenshot($0)
    }

    private lazy var statusBarMonitor = StatusBarMonitor { [unowned self] in
        self.displayStatusBar($0)
    }

    private lazy var timeMonitor = TimeMonitor { [unowned self] in
        self.displayTime($0)
    }

    private lazy var monitors: [Monitor] = [appStateMonitor,
                                            backgroundRefreshMonitor,
                                            memoryMonitor,
                                            protectedDataMonitor,
                                            screenshotMonitor,
                                            statusBarMonitor,
                                            timeMonitor]

    private var memoryCount = 0
    private var screenshotCount = 0
    private var timeCount = 0

    // MARK: Private Instance Methods

    private func displayAppState(_ event: AppStateMonitor.Event?) {
        if let event = event {
            switch event {
            case .didBecomeActive:
                appStateLabel.text = "Did become active"

            case .didEnterBackground:
                appStateLabel.text = "Did enter background"

            case .didFinishLaunching:
                appStateLabel.text = "Did finish launching"

            case .willEnterForeground:
                appStateLabel.text = "Will enter foreground"

            case .willResignActive:
                appStateLabel.text = "Will resign active"

            case .willTerminate:
                appStateLabel.text = "Will terminate"
            }
        } else {
            appStateLabel.text = " "
        }
    }

    private func displayBackgroundRefresh(_ event: BackgroundRefreshMonitor.Event?) {
        if let event = event,
           case let .statusDidChange(status) = event {
            backgroundRefreshLabel.text = formatBackgroundRefreshStatus(status)
        } else {
            backgroundRefreshLabel.text = formatBackgroundRefreshStatus(backgroundRefreshMonitor.status)
        }
    }

    private func displayMemory(_ event: MemoryMonitor.Event?) {
        if let event = event,
           case .didReceiveWarning = event {
            memoryCount += 1
        }

        memoryLabel.text = formatInteger(memoryCount)
    }

    private func displayProtectedData(_ event: ProtectedDataMonitor.Event?) {
        if let event = event {
            switch event {
            case .didBecomeAvailable:
                protectedDataLabel.text = "Did become available"

            case .willBecomeUnavailable:
                protectedDataLabel.text = "Will become unavailable"
            }
        } else {
            protectedDataLabel.text = " "
        }
    }

    private func displayScreenshot(_ event: ScreenshotMonitor.Event?) {
        if let event = event,
           case .userDidTake = event {
            screenshotCount += 1
        }

        screenshotLabel.text = formatInteger(screenshotCount)
    }

    private func displayStatusBar(_ event: StatusBarMonitor.Event?) {
        if let event = event {
            switch event {
            case let .didChangeFrame(frame):
                statusBarActionLabel.text = "Did change frame"

                statusBarFrameLabel.text = formatRect(frame)

                statusBarOrientationLabel.text = formatInterfaceOrientation(statusBarMonitor.orientation)

            case let .didChangeOrientation(orientation):
                statusBarActionLabel.text = "Did change orientation"

                statusBarFrameLabel.text = formatRect(statusBarMonitor.frame)

                statusBarOrientationLabel.text = formatInterfaceOrientation(orientation)

            case let .willChangeFrame(frame):
                statusBarActionLabel.text = "Will change frame"

                statusBarFrameLabel.text = formatRect(frame)

                statusBarOrientationLabel.text = formatInterfaceOrientation(statusBarMonitor.orientation)

            case let .willChangeOrientation(orientation):
                statusBarActionLabel.text = "Will change orientation"

                statusBarFrameLabel.text = formatRect(statusBarMonitor.frame)

                statusBarOrientationLabel.text = formatInterfaceOrientation(orientation)
            }
        } else {
            statusBarActionLabel.text = " "

            statusBarFrameLabel.text = formatRect(statusBarMonitor.frame)

            statusBarOrientationLabel.text = formatInterfaceOrientation(statusBarMonitor.orientation)
        }
    }

    private func displayTime(_ event: TimeMonitor.Event?) {
        if let event = event,
           case .significantChange = event {
            timeCount += 1
        }

        timeLabel.text = formatInteger(timeCount)
    }

    @IBAction private func memoryButtonTapped() {
        UIControl().sendAction(Selector(("_performMemoryWarning")),
                               to: UIApplication.shared,
                               for: nil)
    }

    // MARK: Overridden UIViewController Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        displayAppState(nil)
        displayBackgroundRefresh(nil)
        displayMemory(nil)
        displayProtectedData(nil)
        displayScreenshot(nil)
        displayStatusBar(nil)
        displayTime(nil)
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
