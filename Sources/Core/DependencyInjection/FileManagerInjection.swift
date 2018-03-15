//
//  FileManagerInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-14.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

internal protocol FileManagerProtocol: class {
    var ubiquityIdentityToken: (NSCoding & NSCopying & NSObjectProtocol)? { get }
}

extension FileManager: FileManagerProtocol {}

internal struct FileManagerInjector {
    internal static var inject: () -> FileManagerProtocol = { return FileManager.`default` }
}
