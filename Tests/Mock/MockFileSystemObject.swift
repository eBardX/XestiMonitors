//
//  MockFileSystemObject.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-02-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
@testable import XestiMonitors

internal class MockFileSystemObject: FileSystemObjectProtocol {
    init(fileDescriptor: Int32,
         eventMask: DispatchSource.FileSystemEvent,
         queue: DispatchQueue?) {
        self.data = []
        self.handle = fileDescriptor
        self.mask = eventMask
        self.queue = queue ?? .global()
    }

    private(set) var data: DispatchSource.FileSystemEvent

    func cancel() {
        if let handler = cancelHandler {
            queue.async(execute: handler)
        }
    }

    func resume() {
    }

    func setCancelHandler(qos: DispatchQoS,
                          flags: DispatchWorkItemFlags,
                          handler: DispatchSourceProtocol.DispatchSourceHandler?) {
        cancelHandler = handler
    }

    func setEventHandler(qos: DispatchQoS,
                         flags: DispatchWorkItemFlags,
                         handler: DispatchSourceProtocol.DispatchSourceHandler?) {
        eventHandler = handler
    }

    // MARK: -

    func updateData(for eventMask: DispatchSource.FileSystemEvent) {
        data = mask.intersection(eventMask)

        if !data.isEmpty,
            let handler = eventHandler {
            queue.async(execute: handler)
        }
    }

    private let queue: DispatchQueue

    private var cancelHandler: DispatchSourceProtocol.DispatchSourceHandler?
    private var eventHandler: DispatchSourceProtocol.DispatchSourceHandler?
    private var handle: Int32
    private var mask: DispatchSource.FileSystemEvent
}
