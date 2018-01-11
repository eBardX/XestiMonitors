//
//  MockNotificationCenter.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import Foundation
@testable import XestiMonitors

internal class MockNotificationCenter: NotificationCenterProtocol {
    class MockObserver {
        let block: (Notification) -> Void
        let object: Any?
        let queue: OperationQueue?

        init(object: Any?,
             queue: OperationQueue?,
             block: @escaping (Notification) -> Void) {
            self.block = block
            self.object = object
            self.queue = queue
        }
    }

    var observers: [String: MockObserver] = [:]

    func addObserver(forName name: NSNotification.Name?,
                     object: Any?,
                     queue: OperationQueue?,
                     using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        guard
            let name = name
            else { fatalError("Name must be specified for testing") }

        guard
            observers[name.rawValue] == nil
            else { fatalError("Cannot have multiple observers for same name") }

        observers[name.rawValue] = MockObserver(object: object,
                                                queue: queue,
                                                block: block)

        return name.rawValue as NSString
    }

    func post(name: NSNotification.Name,
              object: Any?,
              userInfo: [AnyHashable: Any]? = nil) {
        guard
            let observer = observers[name.rawValue]
            else { return }

        if let filter = observer.object as AnyObject? {
            guard
                let object = object as AnyObject?,
                filter === object
                else { return }
        }

        let notification = Notification(name: name,
                                        object: object,
                                        userInfo: userInfo)

        if let queue = observer.queue {
            queue.addOperation { observer.block(notification) }
        } else {
            observer.block(notification)
        }
    }

    func removeObserver(_ observer: Any) {
        guard
            let name = observer as? String
            else { return }

        observers[name] = nil
    }
}
