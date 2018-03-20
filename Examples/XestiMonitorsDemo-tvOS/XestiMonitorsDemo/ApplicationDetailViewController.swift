//
//  ApplicationDetailViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-11.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

public class ApplicationDetailViewController: UITableViewController {

    // MARK: Private Instance Properties

    @IBOutlet private weak var applicationStateLabel: UILabel!
    @IBOutlet private weak var memoryButton: UIButton!
    @IBOutlet private weak var memoryLabel: UILabel!
    @IBOutlet private weak var protectedDataLabel: UILabel!
    @IBOutlet private weak var screenshotLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    private lazy var applicationStateMonitor = ApplicationStateMonitor(options: .all,
                                                                       queue: .main) { [unowned self] in
        self.displayApplicationState($0)
    }

    private lazy var memoryMonitor = MemoryMonitor(queue: .main) { [unowned self] in
        self.displayMemory($0)
    }

    private lazy var protectedDataMonitor = ProtectedDataMonitor(options: .all,
                                                                 queue: .main) { [unowned self] in
        self.displayProtectedData($0)
    }

    private lazy var screenshotMonitor = ScreenshotMonitor(queue: .main) { [unowned self] in
        self.displayScreenshot($0)
    }

    private lazy var timeMonitor = TimeMonitor(queue: .main) { [unowned self] in
        self.displayTime($0)
    }

    private lazy var monitors: [Monitor] = [self.applicationStateMonitor,
                                            self.memoryMonitor,
                                            self.protectedDataMonitor,
                                            self.screenshotMonitor,
                                            self.timeMonitor]

    private var memoryCount = 0
    private var screenshotCount = 0
    private var timeCount = 0

    // MARK: Private Instance Methods

    private func displayApplicationState(_ event: ApplicationStateMonitor.Event?) {
        if let event = event {
            switch event {
            case .didBecomeActive:
                applicationStateLabel.text = "Did become active"

            case .didEnterBackground:
                applicationStateLabel.text = "Did enter background"

            case .didFinishLaunching:
                applicationStateLabel.text = "Did finish launching"

            case .willEnterForeground:
                applicationStateLabel.text = "Will enter foreground"

            case .willResignActive:
                applicationStateLabel.text = "Will resign active"

            case .willTerminate:
                applicationStateLabel.text = "Will terminate"
            }
        } else {
            applicationStateLabel.text = " "
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

        displayApplicationState(nil)
        displayMemory(nil)
        displayProtectedData(nil)
        displayScreenshot(nil)
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
