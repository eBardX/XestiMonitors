//
//  FileSystemInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-02-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

internal protocol FileSystemProtocol: AnyObject {
    @discardableResult
    func close(_ fd: Int32) -> Int32

    func fcntl(_ fd: Int32,
               _ cmd: Int32,
               _ ptr: UnsafeMutableRawPointer) -> Int32

    func open(_ path: UnsafePointer<CChar>,
              _ oflag: Int32) -> Int32
}

extension FileSystem: FileSystemProtocol {}

internal enum FileSystemInjector {
    internal static var inject: () -> FileSystemProtocol = { shared }

    private static let shared: FileSystemProtocol = FileSystem()
}
