// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Dispatch

internal protocol FileSystemObjectProtocol {
    var data: DispatchSource.FileSystemEvent { get }

    func cancel()

    func resume()

    func setCancelHandler(qos: DispatchQoS,
                          flags: DispatchWorkItemFlags,
                          handler: DispatchSourceProtocol.DispatchSourceHandler?)

    func setEventHandler(qos: DispatchQoS,
                         flags: DispatchWorkItemFlags,
                         handler: DispatchSourceProtocol.DispatchSourceHandler?)
}

// MARK: -

extension DispatchSource: FileSystemObjectProtocol {}

// MARK: -

internal typealias MakeFileSystemObject = (Int32, DispatchSource.FileSystemEvent, DispatchQueue?) -> any FileSystemObjectProtocol

private let _makeFileSystemObject: MakeFileSystemObject = {
    DispatchSource.makeFileSystemObjectSource(fileDescriptor: $0,
                                              eventMask: $1,
                                              queue: $2) as! DispatchSource // swiftlint:disable:this force_cast
}

extension Dependencies {
    internal static var makeFileSystemObjectInjected = {
        DependencyResolver.register(_makeFileSystemObject)
    }()
}
