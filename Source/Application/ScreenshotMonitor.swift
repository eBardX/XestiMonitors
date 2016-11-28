//
//  ScreenshotMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// A `ScreenshotMonitor` object monitors the app for screenshots.
///
public class ScreenshotMonitor: BaseNotificationMonitor {

    // MARK: Public Initializers

    ///
    /// Initializes a new `ScreenshotMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the user presses the Home and
    ///                 Lock buttons to take a screenshot.
    ///
    public init(handler: @escaping () -> Void) {

        self.handler = handler

    }

    // MARK: Private Instance Properties

    private let handler: () -> Void

    // MARK: Private Instance Methods

    @objc private func applicationUserDidTakeScreenshot(_ notification: NSNotification) {

        handler()

    }

    // MARK: Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ center: NotificationCenter) -> Bool {

        center.addObserver(self,
                           selector: #selector(applicationUserDidTakeScreenshot(_:)),
                           name: .UIApplicationUserDidTakeScreenshot,
                           object: nil)

        return true

    }

}
