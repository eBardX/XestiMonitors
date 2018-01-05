//
//  NSNotificationCenter+XestiMonitors.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-05.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

public typealias NSNotificationCenter = Foundation.NotificationCenter

public protocol NotificationCenter: class {

    func addObserver(forName name: NSNotification.Name?,
                     object obj: Any?,
                     queue: OperationQueue?,
                     using block: @escaping (Notification) -> Void) -> NSObjectProtocol

    func removeObserver(_ observer: Any)

}

extension NSNotificationCenter: NotificationCenter {}
