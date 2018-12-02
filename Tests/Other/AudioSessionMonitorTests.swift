//
//  AudioSessionMonitorTests.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 02/12/2018.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import XCTest
import AVFoundation
@testable import XestiMonitors

internal class AudioSessionMonitorTest: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    
    override func setUp() {
        super.setUp()
        
        NotificationCenterInjector.inject = { self.notificationCenter }
    }
    
    func testMonitor_didInterruptAudio() {
        let expectation = self.expectation(description: "Handler Called")
        var expectedEvent: AudioSessionMonitor.Event?
        let monitor = AudioSessionMonitor(options: .didInterruptAudio,
                                          queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)
                                            expectedEvent = event
                                            expectation.fulfill()
        }
        
        monitor.startMonitoring()
    }
    
    
    private func makeUserInfo(interruptionType: UInt?,
                              interruptionOptions: UInt?,
                              routeChangeReason: UInt?,
                              previousRoute: AVAudioSessionRouteDescription?,
                              silenceSecondaryAudioHintType: UInt?) -> [AnyHashable: Any] {
        return [AVAudioSessionInterruptionTypeKey: interruptionType,
                AVAudioSessionInterruptionOptionKey: interruptionOptions,
                AVAudioSessionRouteChangeReasonKey: routeChangeReason,
                AVAudioSessionRouteChangePreviousRouteKey: previousRoute,
                AVAudioSessionSilenceSecondaryAudioHintTypeKey: silenceSecondaryAudioHintType]
    }
    private func simulateDidInterruptAudio() {
        
    }
}
