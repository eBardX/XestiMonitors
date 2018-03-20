//
//  MockFileSystem.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-02-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
@testable import XestiMonitors

internal class MockFileSystem: FileSystemProtocol {
    init() {
        self.fileDescriptor = -1
        self.filePath = nil
    }

    func close(_ fd: Int32) -> Int32 {
        guard
            fd == fileDescriptor,
            filePath != nil
            else { return -1 }

        fileDescriptor = -1
        filePath = nil

        return 0
    }

    func fcntl(_ fd: Int32,
               _ cmd: Int32,
               _ ptr: UnsafeMutableRawPointer) -> Int32 {
        guard
            fd == fileDescriptor,
            cmd == F_GETPATH,
            let path = filePath
            else { return -1 }

        ptr.copyBytes(from: path,
                      count: String(cString: path).count)

        return 0
    }

    func open(_ path: UnsafePointer<CChar>,
              _ oflag: Int32) -> Int32 {
        guard
            fileDescriptor < 0,
            filePath == nil
            else { return -1 }

        fileDescriptor = Int32(arc4random_uniform(1_000))
        filePath = path

        return fileDescriptor
    }

    // MARK: -

    func rename(to path: String) {
        filePath = (path as NSString).fileSystemRepresentation
    }

    private var fileDescriptor: Int32
    private var filePath: UnsafePointer<CChar>?
}
