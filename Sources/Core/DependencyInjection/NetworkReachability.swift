//
//  NetworkReachability.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-07.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(macOS) || os(tvOS)

import SystemConfiguration

internal class NetworkReachability {

    // MARK: Public Nested Types

    internal enum Error: Swift.Error {
        case creationFailure
    }

    // MARK: Public Instance Methods

    internal func getFlags(_ flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool {
        guard
            let handle = handle
            else { return false }

        return SCNetworkReachabilityGetFlags(handle,
                                             flags)
    }

    internal func listen(to address: UnsafePointer<sockaddr>) throws {
        self.handle = SCNetworkReachabilityCreateWithAddress(nil,
                                                             address)

        if self.handle == nil {
            throw Error.creationFailure
        }
    }

    internal func listen(to nodename: UnsafePointer<Int8>) throws {
        self.handle = SCNetworkReachabilityCreateWithName(nil,
                                                          nodename)

        if self.handle == nil {
            throw Error.creationFailure
        }
    }

    @discardableResult
    internal func setCallback(_ callout: SystemConfiguration.SCNetworkReachabilityCallBack?,
                              _ context: UnsafeMutablePointer<SCNetworkReachabilityContext>?) -> Bool {
        guard
            let handle = handle
            else { return false }

        return SCNetworkReachabilitySetCallback(handle,
                                                callout,
                                                context)
    }

    @discardableResult
    internal func setDispatchQueue(_ queue: DispatchQueue?) -> Bool {
        guard
            let handle = handle
            else { return false }

        return SCNetworkReachabilitySetDispatchQueue(handle,
                                                     queue)
    }

    // MARK: Private Instance Properties

    private var handle: SCNetworkReachability?
}

#endif
