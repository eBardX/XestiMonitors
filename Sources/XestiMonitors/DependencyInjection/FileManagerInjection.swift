// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

internal protocol FileManagerProtocol {
    var ubiquityIdentityToken: (any NSCoding & NSCopying & NSObjectProtocol)? { get }
}

// MARK: -

extension FileManager: FileManagerProtocol {}

// MARK: -

extension Dependencies {
    internal static let fileManagerInjected = {
        DependencyResolver.register(FileManager.default as any FileManagerProtocol)
    }()
}
