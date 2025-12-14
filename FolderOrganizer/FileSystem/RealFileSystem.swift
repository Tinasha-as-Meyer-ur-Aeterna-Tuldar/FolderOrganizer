import Foundation

final class RealFileSystem: FileSystem {

    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func fileExists(at url: URL) -> Bool {
        fileManager.fileExists(atPath: url.path)
    }

    func createDirectory(at url: URL) throws {
        try fileManager.createDirectory(
            at: url,
            withIntermediateDirectories: true
        )
    }

    func moveItem(from sourceURL: URL, to destinationURL: URL) throws {
        try fileManager.moveItem(
            at: sourceURL,
            to: destinationURL
        )
    }
}
