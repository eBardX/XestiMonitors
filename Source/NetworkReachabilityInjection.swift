//
//  NetworkReachabilityInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-07.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import SystemConfiguration

internal protocol NetworkReachabilityProtocol: class {
    func getFlags(_ flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool

    func listen(to address: UnsafePointer<sockaddr>) -> Bool

    func listen(to nodename: UnsafePointer<Int8>) -> Bool

    @discardableResult
    func setCallback(_ callout: SystemConfiguration.SCNetworkReachabilityCallBack?,
                     _ context: UnsafeMutablePointer<SCNetworkReachabilityContext>?) -> Bool

    @discardableResult
    func setDispatchQueue(_ queue: DispatchQueue?) -> Bool
}

extension NetworkReachability: NetworkReachabilityProtocol {}

internal protocol NetworkReachabilityInjected {}

internal struct NetworkReachabilityInjector {
    static var networkReachability: NetworkReachabilityProtocol = NetworkReachability()
}

internal extension NetworkReachabilityInjected {
    var networkReachability: NetworkReachabilityProtocol { return NetworkReachabilityInjector.networkReachability }
}
