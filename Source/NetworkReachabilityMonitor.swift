//
//  NetworkReachabilityMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-12-05.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import SystemConfiguration

///
/// A `NetworkReachabilityMonitor` instance monitors a network node name or
/// address for changes to its reachability.
///
public class NetworkReachabilityMonitor: BaseMonitor {
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

        ///
        /// The reachability of the network node name or address cannot be
        /// determined.
        ///
        case unknown
    }

    ///
    /// Initializes a new `NetworkReachabilityMonitor` for the network address
    /// `0.0.0.0` (meaning “any IPv4 address at all”).
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the reachability of the
    ///                 network node address changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.innerQueue = .main
        self.queue = queue
        self.unsafePreviousFlags = []

        super.init()

        var address = sockaddr_in()

        address.sin_family = sa_family_t(AF_INET)
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)

        let success = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self,
                                 capacity: MemoryLayout<sockaddr_in>.size) {
                                    networkReachability.listen(to: $0)
            }
        }

        if !success {
            fatalError("Unable to create network reachability")
        }
    }

    ///
    /// Initializes a new `NetworkReachabilityMonitor` for the specified
    /// network node name.
    ///
    /// - Parameters:
    ///   - name:       The network node name of the desired host.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the reachability of the
    ///                 network node name changes.
    ///
    public init(name: String,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.innerQueue = .main
        self.queue = queue
        self.unsafePreviousFlags = []

        super.init()

        if !networkReachability.listen(to: name) {
            fatalError("Unable to create network reachability")
        }
    }

    ///
    /// A Boolean value indicating whether the network node name or address can
    /// be reached (`true`) or not (`false`).
    ///
    public var isReachable: Bool {
        return isReachableViaWiFi || isReachableViaWWAN
    }

    ///
    /// A Boolean value indicating whether the network node name or address can
    /// be reached via a non-cellular connection (`true`) or not (`false`).
    ///
    public var isReachableViaWiFi: Bool {
        return status == .reachableViaWiFi
    }

    ///
    /// A Boolean value indicating whether the network node name or address can
    /// be reached via a cellular connection (`true`) or not (`false`).
    ///
    public var isReachableViaWWAN: Bool {
        return status == .reachableViaWWAN
    }

    ///
    /// The reachability of the network node name or address.
    ///
    public var status: Status {
        guard
            let flags = self.currentFlags
            else { return .unknown }

        return statusFromFlags(flags)
    }

    private let handler: (Event) -> Void
    private let innerQueue: DispatchQueue
    private let queue: OperationQueue

    private var currentFlags: SCNetworkReachabilityFlags? {
        var flags: SCNetworkReachabilityFlags = []

        return networkReachability.getFlags(&flags) ? flags : nil
    }

    private var unsafePreviousFlags: SCNetworkReachabilityFlags

    private func invokeHandler(_ flags: SCNetworkReachabilityFlags) {
        guard
            unsafePreviousFlags != flags
            else { return }

        unsafePreviousFlags = flags

        queue.addOperation {
            self.handler(.statusDidChange(self.statusFromFlags(flags)))
        }
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

    public override final func cleanupMonitor() {
        networkReachability.setDispatchQueue(nil)
        networkReachability.setCallback(nil, nil)

        super.cleanupMonitor()
    }

    public override final func configureMonitor() {
        super.configureMonitor()

        var context = SCNetworkReachabilityContext()

        context.info = Unmanaged.passUnretained(self).toOpaque()

        let callback: SCNetworkReachabilityCallBack = { _, flags, info in
            guard
                let info = info
                else { return }

            let monitor = Unmanaged<NetworkReachabilityMonitor>.fromOpaque(info).takeUnretainedValue()

            monitor.invokeHandler(flags)
        }

        guard
            networkReachability.setCallback(callback, &context)
            else { return }

        guard
            networkReachability.setDispatchQueue(innerQueue)
            else { networkReachability.setCallback(nil, nil); return }

        innerQueue.async {
            self.unsafePreviousFlags = []

            self.invokeHandler(self.currentFlags ?? [])
        }
    }
}

extension NetworkReachabilityMonitor: NetworkReachabilityInjected {}
