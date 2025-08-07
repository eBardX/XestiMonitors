// © 2017–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import UIKit

internal protocol AppProtocol {
    var applicationState: UIApplication.State { get }

#if os(iOS)
    var backgroundRefreshStatus: UIBackgroundRefreshStatus { get }
#endif

    var isProtectedDataAvailable: Bool { get }

    var preferredContentSizeCategory: UIContentSizeCategory { get }

#if os(iOS)
    var statusBarFrame: CGRect { get }

    var statusBarOrientation: UIInterfaceOrientation { get }
#endif
}

// MARK: -

extension UIApplication: AppProtocol {}

// MARK: -

internal enum AppInjector {
    internal static var inject: () -> any AppProtocol = { UIApplication.shared }
}

#endif
