//
//  NotificationCenterInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-05.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

internal protocol NotificationCenterProtocol: class {
    func addObserver(forName name: NSNotification.Name?,
                     object obj: Any?,
                     queue: OperationQueue?,
                     using block: @escaping (Notification) -> Void) -> NSObjectProtocol

    func removeObserver(_ observer: Any)
}

extension NotificationCenter: NotificationCenterProtocol {}

internal protocol NotificationCenterInjected {}

internal struct NotificationCenterInjector {
    static var notificationCenter: NotificationCenterProtocol = NotificationCenter.`default`
}

internal extension NotificationCenterInjected {
    var notificationCenter: NotificationCenterProtocol { return NotificationCenterInjector.notificationCenter }
}
