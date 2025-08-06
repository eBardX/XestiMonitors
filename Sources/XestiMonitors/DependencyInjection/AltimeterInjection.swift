// © 2017–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(watchOS)

import CoreMotion

internal protocol AltimeterProtocol {
    static func isRelativeAltitudeAvailable() -> Bool

    func startRelativeAltitudeUpdates(to queue: OperationQueue,
                                      withHandler handler: @escaping CMAltitudeHandler)

    func stopRelativeAltitudeUpdates()
}

// MARK: -

extension CMAltimeter: AltimeterProtocol {}

// MARK: -

extension Dependencies {
    internal static let altimeterInjected = {
        DependencyResolver.register(CMAltimeter() as any AltimeterProtocol)
    }()
}

#endif
