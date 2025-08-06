// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Darwin

internal class FileSystem {

    // MARK: Public Instance Methods

    internal func close(_ fd: Int32) -> Int32 {
        Darwin.close(fd)
    }

    internal func fcntl(_ fd: Int32,
                        _ cmd: Int32,
                        _ ptr: UnsafeMutableRawPointer) -> Int32 {
        Darwin.fcntl(fd, cmd, ptr)
    }

    internal func open(_ path: UnsafePointer<CChar>,
                       _ oflag: Int32) -> Int32 {
        Darwin.open(path, oflag)
    }
}
