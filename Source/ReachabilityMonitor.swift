//
//  ReachabilityMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-05.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import SystemConfiguration

///
/// A `ReachabilityMonitor` object monitors a network node name or address for
/// changes to its reachability.
///
public class ReachabilityMonitor: BaseMonitor {

    // Public Nested Types

    ///
    /// Encapsulates changes to the reachability of a network node name or
    /// address.
    ///
    public enum Event {
        ///
        /// The reachability status has changed.
        ///
        case statusDidChange(Status)
    }

    ///
    /// Encapsulates the reachability of a network node name or address.
    ///
    public enum Status {

        ///
        /// The reachability of the network node name or address cannot be
        /// determined.
        ///
        case unknown

        ///
        /// The network node name or address is not reachable.
        ///
        case notReachable

        ///
        /// The network node name or address can be reached via a non-cellular
        /// connection.
        ///
        case reachableViaWiFi

        ///
        /// The network node name or address can be reached via a cellular
        /// connection.
        ///
        case reachableViaWWAN
    }

    // Public Initializers

    ///
    /// Initializes a new `ReachabilityMonitor` for the network address
    /// `0.0.0.0` (meaning “any IPv4 address at all”).
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the reachability of the
    ///                 network node address changes.
    ///
    public convenience init?(queue: DispatchQueue = .main,
                             handler: @escaping (Event) -> Void) {

        var address = sockaddr_in()

        address.sin_family = sa_family_t(AF_INET)
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)

        let reachability = withUnsafePointer(to: &address) { pointer in

            return pointer.withMemoryRebound(to: sockaddr.self,
                                             capacity: MemoryLayout<sockaddr>.size) {

                                                return SCNetworkReachabilityCreateWithAddress(nil, $0)

            }

        }

        self.init(reachability: reachability,
                  queue: queue,
                  handler: handler)

    }

    ///
    /// Initializes a new `ReachabilityMonitor` for the specified network node
    /// name.
    ///
    /// - Parameters:
    ///   - host:       The network node name of the desired host.
    ///   - handler:    The handler to call when the reachability of the
    ///                 network node name changes.
    ///
    public convenience init?(name: String,
                             queue: DispatchQueue = .main,
                             handler: @escaping (Event) -> Void) {

        let reachability = SCNetworkReachabilityCreateWithName(nil, name)

        self.init(reachability: reachability,
                  queue: queue,
                  handler: handler)

    }

    // Public Instance Properties

    ///
    /// A Boolean value indicating whether the network node name or address can
    /// be reached (`true`) or not (`false`).
    ///
    public var isReachable: Bool { return isReachableViaWiFi ||  isReachableViaWWAN }

    ///
    /// A Boolean value indicating whether the network node name or address can
    /// be reached via a non-cellular connection (`true`) or not (`false`).
    ///
    public var isReachableViaWiFi: Bool { return status == .reachableViaWiFi }

    ///
    /// A Boolean value indicating whether the network node name or address can
    /// be reached via a cellular connection (`true`) or not (`false`).
    ///
    public var isReachableViaWWAN: Bool { return status == .reachableViaWWAN }

    ///
    /// The reachability of the network node name or address.
    ///
    public var status: Status {

        guard let flags = self.currentFlags
            else { return .unknown }

        return statusFromFlags(flags)

    }

    // Private Initializers

    private init?(reachability: SCNetworkReachability?,
                  queue: DispatchQueue,
                  handler: @escaping (Event) -> Void) {

        guard let reachability = reachability
            else { return nil }

        self.handler = handler
        self.previousFlags = SCNetworkReachabilityFlags()
        self.queue = queue
        self.reachability = reachability

    }

    // Private Instance Properties

    private let handler: (Event) -> Void
    private let queue: DispatchQueue
    private let reachability: SCNetworkReachability

    private var previousFlags: SCNetworkReachabilityFlags

    private var currentFlags: SCNetworkReachabilityFlags? {

        var flags = SCNetworkReachabilityFlags()

        return SCNetworkReachabilityGetFlags(reachability, &flags) ? flags : nil

    }

    // Private Instance Methods

    private func invokeHandler(_ flags: SCNetworkReachabilityFlags) {

        guard previousFlags != flags
            else { return }

        previousFlags = flags

        handler(.statusDidChange(statusFromFlags(flags)))

    }

    private func statusFromFlags(_ flags: SCNetworkReachabilityFlags) -> Status {

        if !flags.contains(.reachable) {
            return .notReachable
        }

        if flags.contains(.connectionRequired) {

            if flags.contains(.interventionRequired) {
                return .notReachable
            }

            if !flags.contains(.connectionOnDemand)
                && !flags.contains(.connectionOnTraffic) {
                return .notReachable
            }
        }

        #if os(iOS)
            if flags.contains(.isWWAN) {
                return .reachableViaWWAN
            }
        #endif

        return .reachableViaWiFi

    }

    // Overridden BaseMonitor Instance Methods

    public override final func cleanupMonitor() -> Bool {

        guard SCNetworkReachabilitySetDispatchQueue(reachability,
                                                    nil)
            else { return false }

        SCNetworkReachabilitySetCallback(reachability,
                                         nil,
                                         nil)

        return super.cleanupMonitor()

    }

    public override final func configureMonitor() -> Bool {

        guard super.configureMonitor()
            else { return false }

        var context = SCNetworkReachabilityContext()

        context.info = Unmanaged.passUnretained(self).toOpaque()

        let callback: SCNetworkReachabilityCallBack = { _, flags, info in

            guard let info = info
                else { return }

            let monitor = Unmanaged<ReachabilityMonitor>.fromOpaque(info).takeUnretainedValue()

            monitor.invokeHandler(flags)

        }

        guard SCNetworkReachabilitySetCallback(reachability,
                                               callback,
                                               &context)
            else { return false }

        guard SCNetworkReachabilitySetDispatchQueue(reachability,
                                                    queue)
            else {

                SCNetworkReachabilitySetCallback(reachability, nil, nil)

                return false
        }

        queue.async {

            self.previousFlags = SCNetworkReachabilityFlags()

            self.invokeHandler(self.currentFlags ?? SCNetworkReachabilityFlags())

        }

        return true

    }

}
