// © 2018–2025 John Gary Pusey (see LICENSE.md)

internal protocol FileSystemProtocol {
    @discardableResult
    func close(_ fd: Int32) -> Int32

    func fcntl(_ fd: Int32,
               _ cmd: Int32,
               _ ptr: UnsafeMutableRawPointer) -> Int32

    func open(_ path: UnsafePointer<CChar>,
              _ oflag: Int32) -> Int32
}

// MARK: -

extension FileSystem: FileSystemProtocol {}

// MARK: -

extension Dependencies {
    internal static let fileSystemInjected = {
        DependencyResolver.register(FileSystem() as any FileSystemProtocol)
    }()
}
