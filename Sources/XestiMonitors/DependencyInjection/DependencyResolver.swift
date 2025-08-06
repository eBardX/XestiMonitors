// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XestiTools

internal final class DependencyResolver {

    // MARK: Internal Type Methods

    @discardableResult
    internal static func register<T>(_ dependency: T) -> Bool {
         shared.register(dependency)
     }

    internal static func resolve<T>() -> T {
        shared.resolve().require(hint: "Dependency not injected for type \(T.self)")
     }

    // MARK: Private Type Properties

    private static let shared = DependencyResolver()

    // MARK: Private Initializers

    private init() {
        self.lock = .init(named: "\(type(of: self)).lock")
        self.unsafeDependencies = [:]
    }

    // MARK: Private Instance Properties

    private let lock: NSRecursiveLock

    private var unsafeDependencies: [String: Any]

    // MARK: Private Instance Methods

    private func register<T>(_ dependency: T) -> Bool {
        lock.withLock {
            unsafeDependencies[String(reflecting: T.self)] = dependency
        }

        return true
    }

    private func resolve<T>() -> T? {
        lock.withLock {
            unsafeDependencies[String(reflecting: T.self)] as? T
        }
    }
}

// MARK: - Inject Property Wrapper

@propertyWrapper
internal struct Inject<T> {

    // MARK: Internal Instance Properties

    internal var wrappedValue: T {
        DependencyResolver.resolve()
    }
}

// MARK: - Dependencies Namespace

internal enum Dependencies {
}
