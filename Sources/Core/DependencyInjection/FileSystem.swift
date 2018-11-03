//
//  FileSystem.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-02-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Darwin

internal class FileSystem {

    // MARK: Public Instance Methods

    internal func close(_ fd: Int32) -> Int32 {
        return Darwin.close(fd)
    }

    internal func fcntl(_ fd: Int32,
                        _ cmd: Int32,
                        _ ptr: UnsafeMutableRawPointer) -> Int32 {
        return Darwin.fcntl(fd, cmd, ptr)
    }

    internal func open(_ path: UnsafePointer<CChar>,
                       _ oflag: Int32) -> Int32 {
        return Darwin.open(path, oflag)
    }
}
