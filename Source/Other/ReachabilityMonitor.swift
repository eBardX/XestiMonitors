//
//  ReachabilityMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-05.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

//import Foundation
import SystemConfiguration

///
/// A `ReachabilityMonitor` object monitors ...
///
public class ReachabilityMonitor: BaseMonitor {

    ///
    ///
    ///
    public enum Status {
        case unknown
        case notReachable
        case reachableViaWiFi
        case reachableViaWWAN
    }

    // Public Initializers

    ///
    /// Initializes a new `ReachabilityMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when ...
    ///
    public convenience init?(handler: @escaping (Status) -> Void) {

        var address = sockaddr_in()

        address.sin_family = sa_family_t(AF_INET)
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)

        guard let reachability = withUnsafePointer(to: &address,
                                                   { pointer in
                                                    return pointer.withMemoryRebound(to: sockaddr.self,
                                                                                     capacity: MemoryLayout<sockaddr>.size) {
                                                                                        return SCNetworkReachabilityCreateWithAddress(nil, $0)
                                                    }}) else { return nil }

        self.init(reachability: reachability,
                  handler: handler)

    }


    public convenience init?(host: String,
                             handler: @escaping (Status) -> Void) {

        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }

        self.init(reachability: reachability,
                  handler: handler)

    }

    // Private Initializers

    private init(reachability: SCNetworkReachability,
                 handler: @escaping (Status) -> Void) {

        self.handler = handler
        self.previousFlags = SCNetworkReachabilityFlags()
        self.reachability = reachability

    }

    // Public Instance Properties

    public var isReachable: Bool { return isReachableViaWiFi ||  isReachableViaWWAN }

    public var isReachableViaWiFi: Bool { return status == .reachableViaWiFi }

    public var isReachableViaWWAN: Bool { return status == .reachableViaWWAN }

    ///
    ///
    ///
    public var status: Status {

        guard let flags = self.currentFlags else { return .unknown }

        return statusForFlags(flags)

    }

    // Private Instance Properties

    private let handler: (Status) -> Void
    private let queue = DispatchQueue.main
    private let reachability: SCNetworkReachability

    private var previousFlags: SCNetworkReachabilityFlags

    private var currentFlags: SCNetworkReachabilityFlags? {

        var flags = SCNetworkReachabilityFlags()

        if SCNetworkReachabilityGetFlags(reachability, &flags) {
            return flags
        }

        return nil

    }

    // Private Instance Methods

    private func invokeHandler(_ flags: SCNetworkReachabilityFlags) {

        guard previousFlags != flags else { return }

        previousFlags = flags

        handler(statusForFlags(flags))

    }

    private func statusForFlags(_ flags: SCNetworkReachabilityFlags) -> Status {

        guard flags.contains(.reachable) else { return .notReachable }

        var status: Status = .notReachable

        if !flags.contains(.connectionRequired) {
            status = .reachableViaWiFi
        }

        if flags.contains(.connectionOnDemand)
            || flags.contains(.connectionOnTraffic) {
            if !flags.contains(.interventionRequired) {
                status = .reachableViaWiFi
            }
        }

        #if os(iOS)
            if flags.contains(.isWWAN) {
                status = .reachableViaWWAN
            }
        #endif

        return status

    }

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

//        return removeNotificationObservers(NotificationCenter.`default`)
//            && super.cleanupMonitor()

        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)

        return true

    }

    public override final func configureMonitor() -> Bool {

//        return super.configureMonitor()
//            && addNotificationObservers(NotificationCenter.`default`)

        var context = SCNetworkReachabilityContext()

        context.info = Unmanaged.passUnretained(self).toOpaque()

        let callbackEnabled = SCNetworkReachabilitySetCallback(reachability,
                                                               { (_, flags, info) in
                                                                let monitor = Unmanaged<ReachabilityMonitor>.fromOpaque(info!).takeUnretainedValue()
                                                                monitor.invokeHandler(flags) },
                                                               &context)

        let queueEnabled = SCNetworkReachabilitySetDispatchQueue(reachability, queue)

        queue.async {
            self.previousFlags = SCNetworkReachabilityFlags()

            self.invokeHandler(self.currentFlags ?? SCNetworkReachabilityFlags())
        }

        return callbackEnabled && queueEnabled

    }

}
