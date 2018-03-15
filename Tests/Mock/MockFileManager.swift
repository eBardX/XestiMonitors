//
//  MockFileManager.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-14.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
@testable import XestiMonitors

internal class MockFileManager: FileManagerProtocol {
    var ubiquityIdentityToken: (NSCoding & NSCopying & NSObjectProtocol)?
}
