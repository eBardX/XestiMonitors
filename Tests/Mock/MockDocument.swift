//
//  MockDocument.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-02-16.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
@testable import XestiMonitors

internal class MockDocument: UIDocument {
    init() {
        super.init(fileURL: Bundle.main.bundleURL)
    }
}
