//
//  NetworkReachabilityInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-07.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(macOS) || os(tvOS)

    import SystemConfiguration

    internal protocol NetworkReachabilityProtocol: class {
        func getFlags(_ flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool

        func listen(to address: UnsafePointer<sockaddr>) throws

        func listen(to nodename: UnsafePointer<Int8>) throws

        @discardableResult
        func setCallback(_ callout: SystemConfiguration.SCNetworkReachabilityCallBack?,
                         _ context: UnsafeMutablePointer<SCNetworkReachabilityContext>?) -> Bool

        @discardableResult
        func setDispatchQueue(_ queue: DispatchQueue?) -> Bool
    }

    extension NetworkReachability: NetworkReachabilityProtocol {}

    internal struct NetworkReachabilityInjector {
        internal static var inject: () -> NetworkReachabilityProtocol = { return shared }

        private static let shared: NetworkReachabilityProtocol = NetworkReachability()
    }

#endif
