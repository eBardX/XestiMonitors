//
//  NotificationCenterInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-05.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

internal typealias NSNotificationCenter = Foundation.NotificationCenter

internal protocol NotificationCenter: class {
    func addObserver(forName name: NSNotification.Name?,
                     object obj: Any?,
                     queue: OperationQueue?,
                     using block: @escaping (Notification) -> Void) -> NSObjectProtocol

    func removeObserver(_ observer: Any)
}

extension NSNotificationCenter: NotificationCenter {}

internal protocol NotificationCenterInjected {}

internal struct NotificationCenterInjector {
    static var notificationCenter: NotificationCenter = NSNotificationCenter.`default`
}

internal extension NotificationCenterInjected {
    var notificationCenter: NotificationCenter { return NotificationCenterInjector.notificationCenter }
}
