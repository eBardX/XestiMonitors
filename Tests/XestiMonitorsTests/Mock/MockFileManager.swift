// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
@testable import XestiMonitors

internal class MockFileManager: FileManagerProtocol {
    var ubiquityIdentityToken: (any NSCoding & NSCopying & NSObjectProtocol)?
}
