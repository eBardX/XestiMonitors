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

    func listen(to address: UnsafePointer<sockaddr>) throws {
        self.handle = SCNetworkReachabilityCreateWithAddress(nil,
                                                             address)
    }

    func listen(to nodename: UnsafePointer<Int8>) throws {
        self.handle = SCNetworkReachabilityCreateWithName(nil,
                                                          nodename)
    }

    func setCallback(_ callout: SCNetworkReachabilityCallBack?,
                     _ context: UnsafeMutablePointer<SCNetworkReachabilityContext>?) -> Bool {
        self.callout = callout

        if let info = context?.pointee.info {
            self.monitor = Unmanaged<NetworkReachabilityMonitor>.fromOpaque(info).takeUnretainedValue()
        }

        return true
    }

    func setDispatchQueue(_ queue: DispatchQueue?) -> Bool {
        return true
    }

    // MARK: -

    func clearFlags() {
        self.flags = []
    }

    func updateFlags(_ flags: SCNetworkReachabilityFlags?) {
        self.flags = flags

        guard
            let callout = self.callout,
            let flags = self.flags,
            let handle = self.handle
            else { return }

        let info: UnsafeMutableRawPointer?

        if let monitor = monitor {
            info = Unmanaged<NetworkReachabilityMonitor>.passUnretained(monitor).toOpaque()
        } else {
            info = nil
        }

        callout(handle, flags, info)
    }

    private var callout: SCNetworkReachabilityCallBack?
    private var flags: SCNetworkReachabilityFlags?
    private var handle: SCNetworkReachability?
    private weak var monitor: NetworkReachabilityMonitor?
}
