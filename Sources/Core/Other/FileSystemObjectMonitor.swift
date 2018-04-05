//
//  FileSystemObjectMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-02-20.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Dispatch

///
/// A `FileSystemObjectMonitor` instance monitors a file-system object for
/// changes. A file-system object can be a regular file, a directory, a
/// symbolic link, a socket, a pipe, or a device. Monitorable activities can
/// include when the file-system object is deleted, written to, or renamed, as
/// well as when specific types of meta information (such as its size and link
/// count) change.
///
public class FileSystemObjectMonitor: BaseMonitor {
    ///
    /// Encapsulates changes to the file-system object.
    ///
    public enum Event {
        ///
        /// Access to the file-system object was revoked.
        ///
        case accessWasRevoked(URL)

        ///
        /// The file-system object data changed.
        ///
        case dataDidChange(URL)

        ///
        /// The file-system object link count changed.
        ///
        case linkCountDidChange(URL)

        ///
        /// The file-system object metadata changed.
        ///
        case metadataDidChange(URL)

        ///
        /// The file-system object changed in size.
        ///
        case sizeDidChange(URL)

        ///
        /// The file-system object was deleted from the namespace.
        ///
        case wasDeleted(URL)

        ///
        /// The file-system object was renamed in the namespace. The first URL
        /// in the associated value contains the *original* file path, the
        /// second contains the *renamed* file path.
        ///
        case wasRenamed(URL, URL)
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `accessWasRevoked` events.
        ///
        public static let accessWasRevoked = Options(rawValue: 1 << 0)

        ///
        /// Monitor `dataDidChange` events.
        ///
        public static let dataDidChange = Options(rawValue: 1 << 1)

        ///
        /// Monitor `linkCountDidChange` events.
        ///
        public static let linkCountDidChange = Options(rawValue: 1 << 2)

        ///
        /// Monitor `metadataDidChange` events.
        ///
        public static let metadataDidChange = Options(rawValue: 1 << 3)

        ///
        /// Monitor `sizeDidChange` events.
        ///
        public static let sizeDidChange = Options(rawValue: 1 << 4)

        ///
        /// Monitor `wasDeleted` events.
        ///
        public static let wasDeleted = Options(rawValue: 1 << 5)

        ///
        /// Monitor `wasRenamed` events.
        ///
        public static let wasRenamed = Options(rawValue: 1 << 5)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.accessWasRevoked,
                                          .dataDidChange,
                                          .linkCountDidChange,
                                          .metadataDidChange,
                                          .sizeDidChange,
                                          .wasDeleted,
                                          .wasRenamed]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `FileSystemObjectMonitor`.
    ///
    /// - Parameters:
    ///   - fileURL:    The URL of the file-system object to monitor.
    ///   - options:    The options that specify which events to monitor. By
    ///                 default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the file-system object
    ///                 changes.
    ///
    public init(fileURL: URL,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.fileSystem = FileSystemInjector.inject()
        self.fileURL = fileURL.absoluteURL
        self.handler = handler
        self.options = options
        self.queue = queue

        super.init()
    }

    ///
    /// The URL of the file-system object being monitored. If the file-system
    /// object is renamed in the namespace *(and `wasRenamed` events are being
    /// monitored)*, this URL is updated accordingly.
    ///
    public private(set) var fileURL: URL

    private let fileSystem: FileSystemProtocol
    private let handler: (Event) -> Void
    private let options: Options
    private let queue: OperationQueue

    private var fileSystemObject: FileSystemObjectProtocol?

    private func fileURL(for fileDescriptor: Int32) -> URL? {
        var rawPath = [CChar](repeating: 0,
                              count: Int(MAXPATHLEN))

        guard
            fileSystem.fcntl(fileDescriptor, F_GETPATH, &rawPath) == 0,
            let path = String(validatingUTF8: rawPath)
            else { return nil }

        return URL(fileURLWithPath: path).absoluteURL
    }

    private func invokeHandler(_ eventMask: DispatchSource.FileSystemEvent,
                               _ fileDescriptor: Int32) {
        if eventMask.contains(.attrib) {
            handler(.metadataDidChange(fileURL))
        }

        if eventMask.contains(.delete) {
            handler(.wasDeleted(fileURL))
        }

        if eventMask.contains(.extend) {
            handler(.sizeDidChange(fileURL))
        }

        if eventMask.contains(.link) {
            handler(.linkCountDidChange(fileURL))
        }

        if eventMask.contains(.rename) {
            if let newFileURL = fileURL(for: fileDescriptor) {
                handler(.wasRenamed(fileURL, newFileURL))

                fileURL = newFileURL
            }
        }

        if eventMask.contains(.revoke) {
            handler(.accessWasRevoked(fileURL))
        }

        if eventMask.contains(.write) {
            handler(.dataDidChange(fileURL))
        }
    }

    private func makeEventMask() -> DispatchSource.FileSystemEvent {
        var eventMask: DispatchSource.FileSystemEvent = []

        if options.contains(.accessWasRevoked) {
            eventMask.insert(.revoke)
        }

        if options.contains(.dataDidChange) {
            eventMask.insert(.write)
        }

        if options.contains(.linkCountDidChange) {
            eventMask.insert(.link)
        }

        if options.contains(.metadataDidChange) {
            eventMask.insert(.attrib)
        }

        if options.contains(.sizeDidChange) {
            eventMask.insert(.extend)
        }

        if options.contains(.wasDeleted) {
            eventMask.insert(.delete)
        }

        if options.contains(.wasRenamed) {
            eventMask.insert(.rename)
        }

        return eventMask
    }

    override public func cleanupMonitor() {
        super.cleanupMonitor()

        fileSystemObject?.cancel()

        fileSystemObject = nil
    }

    override public func configureMonitor() {
        super.configureMonitor()

        let path = (fileURL as NSURL).fileSystemRepresentation
        let targetQueue = DispatchQueue.global(qos: .`default`)
        let fileDescriptor = fileSystem.open(path, O_EVTONLY)
        let fileSystemObject = FileSystemObjectInjector.inject(fileDescriptor,
                                                               makeEventMask(),
                                                               targetQueue)

        fileSystemObject.setEventHandler(qos: .unspecified,
                                         flags: []) { [weak self] in
                                            self?.invokeHandler(fileSystemObject.data,
                                                                fileDescriptor)
        }

        fileSystemObject.setCancelHandler(qos: .unspecified,
                                          flags: []) { [weak self] in
                                            self?.fileSystem.close(fileDescriptor)
        }

        self.fileSystemObject = fileSystemObject

        fileSystemObject.resume()
    }
}
