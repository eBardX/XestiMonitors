//
//  MockNotificationCenter.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import Foundation

internal class MockNotificationCenter: NotificationCenter {

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

    override func addObserver(forName name: NSNotification.Name?,
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

    override func addObserver(_ observer: Any,
                              selector: Selector,
                              name: NSNotification.Name?,
                              object: Any?) {

        fatalError("Not implemented")

    }

    override func post(_ notification: Notification) {

        guard
            let observer = observers[notification.name.rawValue]
            else { fatalError("No observer registered for name") }

        if let filter = observer.object as AnyObject? {
            guard
                let object = notification.object as AnyObject?,
                filter === object
                else { return }
        }

        if let queue = observer.queue {
            queue.addOperation { observer.block(notification) }
        } else {
            observer.block(notification)
        }

    }

    override func post(name: NSNotification.Name,
                       object: Any?) {

        post(name: name,
             object: object,
             userInfo: nil)

    }

    override func post(name: NSNotification.Name,
                       object: Any?,
                       userInfo: [AnyHashable: Any]? = nil) {

        post (Notification(name: name,
                           object: object,
                           userInfo: userInfo))

    }

    override func removeObserver(_ observer: Any) {

        guard
            let name = observer as? String
            else { fatalError("Bad observer") }

        observers[name] = nil

    }

    override func removeObserver(_ observer: Any,
                                 name: NSNotification.Name?,
                                 object: Any?) {

        fatalError("Not implemented")

    }

}
