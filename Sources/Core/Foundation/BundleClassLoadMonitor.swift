//
//  BundleClassLoadMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-05-20.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `BundleClassLoadMonitor` instance monitors a bundle for changes to ...
///
public class BundleClassLoadMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to ...
    ///
    public enum Event {
        ///
        ///
        ///
        case didLoad(Bundle, [String])
    }

    ///
    /// Initializes a new `BundleClassLoadMonitor`.
    ///
    /// - Parameters:
    ///   - bundle:     The bundle to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when ...
    ///
    public init(bundle: Bundle,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.bundle = bundle
        self.handler = handler

        super.init(queue: queue)
    }

    ///
    /// The bundle being monitored.
    ///
    public let bundle: Bundle

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(Bundle.didLoadNotification,
                object: bundle) { [unowned self] in
                    if let bundle = $0.object as? Bundle,
                        let loadedClasses = $0.userInfo?[NSLoadedClasses] as? [String] {
                        self.handler(.didLoad(bundle, loadedClasses))
                    }
        }
    }
}
