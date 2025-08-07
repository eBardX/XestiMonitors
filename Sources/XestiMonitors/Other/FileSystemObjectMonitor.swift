// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Dispatch
import Foundation

/// A `FileSystemObjectMonitor` instance monitors a file-system object for
/// changes. A file-system object can be a regular file, a directory, a
/// symbolic link, a socket, a pipe, or a device. Monitorable activities can
/// include when the file-system object is deleted, written to, or renamed, as
/// well as when specific types of meta information (such as its size and link
/// count) change.
public final class FileSystemObjectMonitor: BaseMonitor {

    // MARK: Public Initializers

    /// Initializes a new `FileSystemObjectMonitor`.
    /// - Parameters:
    ///   - fileURL:    The URL of the file-system object to monitor.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the file-system object
    ///                 changes.
    public init(fileURL: URL,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.fileURL = fileURL.absoluteURL
        self.fileSystem = FileSystemInjector.inject()
        self.handler = handler
        self.queue = queue
    }

    // MARK: Public Instance Properties

    /// The URL of the file-system object being monitored. If the file-system
    /// object is renamed in the namespace *(and `wasRenamed` events are being
    /// monitored)*, this URL is updated accordingly.
    public private(set) var fileURL: URL

    // MARK: Private Instance Properties

    private let fileSystem: any FileSystemProtocol
    private let handler: (Event) -> Void
    private let queue: OperationQueue

    private var fileSystemObject: (any FileSystemObjectProtocol)?

    // MARK: Overridden Public Instance Methods

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
                                                               _makeEventMask(),
                                                               targetQueue)

        fileSystemObject.setEventHandler(qos: .unspecified,
                                         flags: []) { [weak self] in
            self?._invokeHandler(fileSystemObject.data,
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

// MARK: -

extension FileSystemObjectMonitor {

    // MARK: Public Nested Types

    /// Encapsulates changes to the file-system object.
    public enum Event {
        /// Access to the file-system object was revoked.
        case accessWasRevoked(URL)

        /// The file-system object data changed.
        case dataDidChange(URL)

        /// The file-system object link count changed.
        case linkCountDidChange(URL)

        /// The file-system object metadata changed.
        case metadataDidChange(URL)

        /// The file-system object changed in size.
        case sizeDidChange(URL)

        /// The file-system object was deleted from the namespace.
        case wasDeleted(URL)

        /// The file-system object was renamed in the namespace. The first URL
        /// in the associated value is the *original* file path, the second is
        /// the *renamed* file path.
        case wasRenamed(URL, URL)
    }

    // MARK: Private Instance Methods

    private func _fileURL(for fileDescriptor: Int32) -> URL? {
        var rawPath = [CChar](repeating: 0,
                              count: Int(MAXPATHLEN))

        guard fileSystem.fcntl(fileDescriptor, F_GETPATH, &rawPath) == 0,
              let path = String(validatingUTF8: rawPath)
        else { return nil }

        return URL(fileURLWithPath: path).absoluteURL
    }

    private func _invokeHandler(_ eventMask: DispatchSource.FileSystemEvent,
                                _ fileDescriptor: Int32) {
        if eventMask.contains(.attrib) {
            queue.addOperation {
                self.handler(.metadataDidChange(self.fileURL))
            }
        }

        if eventMask.contains(.delete) {
            queue.addOperation {
                self.handler(.wasDeleted(self.fileURL))
            }
        }

        if eventMask.contains(.extend) {
            queue.addOperation {
                self.handler(.sizeDidChange(self.fileURL))
            }
        }

        if eventMask.contains(.link) {
            queue.addOperation {
                self.handler(.linkCountDidChange(self.fileURL))
            }
        }

        if eventMask.contains(.rename) {
            if let newFileURL = _fileURL(for: fileDescriptor) {
                let oldFileURL = fileURL

                fileURL = newFileURL

                queue.addOperation {
                    self.handler(.wasRenamed(oldFileURL, newFileURL))
                }
            }
        }

        if eventMask.contains(.revoke) {
            queue.addOperation {
                self.handler(.accessWasRevoked(self.fileURL))
            }
        }

        if eventMask.contains(.write) {
            queue.addOperation {
                self.handler(.dataDidChange(self.fileURL))
            }
        }
    }

    private func _makeEventMask() -> DispatchSource.FileSystemEvent {
        var eventMask: DispatchSource.FileSystemEvent = []

        eventMask.insert(.attrib)
        eventMask.insert(.delete)
        eventMask.insert(.extend)
        eventMask.insert(.link)
        eventMask.insert(.rename)
        eventMask.insert(.revoke)
        eventMask.insert(.write)

        return eventMask
    }
}
