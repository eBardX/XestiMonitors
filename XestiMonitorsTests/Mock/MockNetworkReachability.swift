//
//  MockNetworkReachability.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-01-06.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import SystemConfiguration
@testable import XestiMonitors

internal class MockNetworkReachability: NetworkReachabilityProtocol {
    func getFlags(_ flags: UnsafeMutablePointer<SCNetworkReachabilityFlags>) -> Bool {
        guard
            let tmpFlags = self.flags
            else { return false }

        flags.pointee = tmpFlags

        return true
    }

    func listen(to address: UnsafePointer<sockaddr>) -> Bool {
        self.handle = SCNetworkReachabilityCreateWithAddress(nil,
                                                             address)

        return self.handle != nil
    }

    func listen(to nodename: UnsafePointer<Int8>) -> Bool {
        self.handle = SCNetworkReachabilityCreateWithName(nil,
                                                          nodename)

        return self.handle != nil
    }

    func setCallback(_ callout: SCNetworkReachabilityCallBack?,
                     _ context: UnsafeMutablePointer<SCNetworkReachabilityContext>?) -> Bool {
        self.callout = callout
        self.context = context

        return true
    }

    func setDispatchQueue(_ queue: DispatchQueue?) -> Bool {
        self.queue = queue

        return true
    }

    // MARK: -

    func updateFlags(_ flags: SCNetworkReachabilityFlags?) {
        self.flags = flags

        guard
            let callout = self.callout,
            let context = self.context,
            let flags = self.flags,
            let handle = self.handle
            else { return }

        //if let queue = queue {
        //    queue.async { callout(handle, flags, context) }
        //} else {
            callout(handle, flags, context)
        //}
    }

    private var callout: SCNetworkReachabilityCallBack?
    private var context: UnsafeMutablePointer<SCNetworkReachabilityContext>?
    private var flags: SCNetworkReachabilityFlags?
    private var handle: SCNetworkReachability?
    private var queue: DispatchQueue?
}
