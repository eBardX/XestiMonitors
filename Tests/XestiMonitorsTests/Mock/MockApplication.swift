// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
@testable import XestiMonitors

internal class MockApplication: AppProtocol {
    init() {
        self.applicationState = .inactive

#if os(iOS)
        self.backgroundRefreshStatus = .restricted
#endif

        self.isProtectedDataAvailable = false
        self.preferredContentSizeCategory = .unspecified

#if os(iOS)
        self.statusBarFrame = .zero
        self.statusBarOrientation = .unknown
#endif
    }

    var applicationState: UIApplication.State

#if os(iOS)
    var backgroundRefreshStatus: UIBackgroundRefreshStatus
#endif

    var isProtectedDataAvailable: Bool
    var preferredContentSizeCategory: UIContentSizeCategory

#if os(iOS)
    var statusBarFrame: CGRect
    var statusBarOrientation: UIInterfaceOrientation
#endif
}
