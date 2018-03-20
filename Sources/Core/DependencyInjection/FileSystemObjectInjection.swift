//
//  FileSystemObjectInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-02-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

internal protocol FileSystemObjectProtocol: class {
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

extension DispatchSource: FileSystemObjectProtocol {}

internal struct FileSystemObjectInjector {
    // swiftlint:disable force_cast

    internal static var inject: (Int32, DispatchSource.FileSystemEvent, DispatchQueue?) -> FileSystemObjectProtocol = {
        DispatchSource.makeFileSystemObjectSource(fileDescriptor: $0,
                                                  eventMask: $1,
                                                  queue: $2) as! DispatchSource
    }

    // swiftlint:enable force_cast
}
