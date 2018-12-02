//
//  AudioSessionMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 02/12/2018.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import AVFoundation

///
/// A `AudioSessionMonitor` instance monitors the state change notifications for an audio
/// session.
///
public class AudioSessionMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates state changes notifications for an audio session.
    ///
    public enum Event {
        ///
        /// Audio interruption has occured.
        ///
        case didInterruptAudio(Info)
        
        //
        //  Media server is terminated
        //
        case mediaServicesWereLost
        
        //
        // Media server restarts.
        //
        case mediaServicesWereReset
        
        //
        // The primary audio from other applications starts and stops
        //
        case silenceSecondaryAudioHint(Info)
        
        ///
        /// The system's audio route has changed.
        ///
        case sessionRouteDidChange(Info)
    }
    
    ///
    /// Encapsulates information associated with a audio session monitor event.
    ///
    public struct Info {
        ///
        /// Defines whether the audio interruption has begun or ended
        ///
        public let interruptionType: AVAudioSession.InterruptionType?
        
        ///
        /// If the audio interruption has ended interruption options are available
        ///  either to resume or cancel audio
        ///
        public let interruptionOptions: AVAudioSession.InterruptionOptions?
        
        ///
        ///  The reason was to why the audio route has changed
        ///
        public let routeChangeReason: AVAudioSession.RouteChangeReason?
        
        ///
        ///  The audio session previous route
        ///
        public let previousRoute: AVAudioSessionRouteDescription?
        
        //
        // Use the audio hint type to determine if your secondary audio muting should begin or end.
        //
        public let silenceSecondaryAudioHintType: AVAudioSessionSilenceSecondaryAudioHintType?
        
        fileprivate init(_ notification: Notification) {
            let userInfo = notification.userInfo
            
            if let rawValue = (userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt),
               let type = AVAudioSessionInterruptionType(rawValue: rawValue ) {
                    self.interruptionType = type
            } else {
                self.interruptionType = nil
            }
            
            if let rawValue = (userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt) {
                let options = AVAudioSessionInterruptionOptions(rawValue: rawValue)
                self.interruptionOptions = options
            } else {
                self.interruptionOptions = nil
            }
            
            if let rawValue = (userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt),
                let reason = AVAudioSessionRouteChangeReason(rawValue: rawValue) {
                self.routeChangeReason = reason
            } else {
                self.routeChangeReason = nil
            }
            
            
            if let previousRoute = (userInfo?[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription) {
                self.previousRoute = previousRoute
            } else {
                self.previousRoute = nil
            }
            
            
            if let rawValue = (userInfo?[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt),
                let audioHint = AVAudioSessionSilenceSecondaryAudioHintType(rawValue: rawValue) {
                self.silenceSecondaryAudioHintType = audioHint
            } else {
                self.silenceSecondaryAudioHintType = nil
            }
            
        }
    }
    
    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didInterruptAudio` events.
        ///
        public static let didInterruptAudio = Options(rawValue: 1 << 0)
        
        ///
        /// Monitor `mediaServicesWereLost` events.
        ///
        public static let mediaServicesWereLost = Options(rawValue: 1 << 1)
        
        ///
        /// Monitor `mediaServicesWereReset` events.
        ///
        public static let mediaServicesWereReset = Options(rawValue: 1 << 2)
        
        ///
        /// Monitor `sessionRouteDidChange` events.
        ///
        public static let sessionRouteDidChange = Options(rawValue: 1 << 3)
        
        ///
        /// Monitor `silenceSecondaryAudioHint` events.
        ///
        public static let silenceSecondaryAudioHint = Options(rawValue: 1 << 4)
        
        ///
        /// Monitor all events.
        ///
        public static let all: Options = [ .didInterruptAudio,
                                           .mediaServicesWereLost,
                                           .mediaServicesWereReset,
                                           .sessionRouteDidChange,
                                           .silenceSecondaryAudioHint ]
        
        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        /// :nodoc:
        public let rawValue: UInt
    }
    
    ///
    /// Initializes a new `AudioSessionMonitor`.
    ///
    /// - Parameters:
    ///   - options:    The options that specify which events to monitor.
    ///                 By default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when state change notifications
    ///                 for the audio sessions are fired.
    ///
    public init(options: Options = .all,
                queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options
        
        super.init(queue: queue)
    }
    
    private let handler: (Event) -> Void
    private let options: Options
    
    override public  func addNotificationObservers() {
        super.addNotificationObservers()
        
        if options.contains(.didInterruptAudio) {
            observe(.AVAudioSessionInterruption) { [unowned self] in
                      self.handler(.didInterruptAudio(Info($0)))
            }
        }
        
        if options.contains(.mediaServicesWereLost) {
            observe(.AVAudioSessionMediaServicesWereLost) { [unowned self] _ in
                        self.handler(.mediaServicesWereLost)
                        
            }
        }
        
        if options.contains(.mediaServicesWereReset) {
            observe(.AVAudioSessionMediaServicesWereReset) { [unowned self] _ in
                        self.handler(.mediaServicesWereReset)
                        
            }
        }
        
        if options.contains(.sessionRouteDidChange) {
            observe(.AVAudioSessionRouteChange) { [unowned self]  in
                        self.handler(.sessionRouteDidChange(Info($0)))
            }
        }
        
        if options.contains(.silenceSecondaryAudioHint) {
            observe(.AVAudioSessionSilenceSecondaryAudioHint) { [unowned self]  in
                        self.handler(.silenceSecondaryAudioHint(Info($0)))
            }
        }
    }

}
