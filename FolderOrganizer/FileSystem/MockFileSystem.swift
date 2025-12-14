import Foundation

/// 仮想ファイルシステム（メモリ上のみ）
final class MockFileSystem: FileSystem {

    /// 存在するパス一覧
    private(set) var existingPaths: Set<String> = []

    /// エラー注入用
    var shouldFailOnMove: Bool = false
    var shouldFailOnCreateDirectory: Bool = false

    init(initialPaths: [URL] = []) {
        existingPaths = Set(initialPaths.map { $0.path })
    }

    func fileExists(at url: URL) -> Bool {
        existingPaths.contains(url.path)
    }

    func createDirectory(at url: URL) throws {
        if shouldFailOnCreateDirectory {
            throw NSError(domain: "MockFileSystem", code: 1)
        }
        existingPaths.insert(url.path)
    }

    func moveItem(from sourceURL: URL, to destinationURL: URL) throws {

        if shouldFailOnMove {
            throw NSError(domain: "MockFileSystem", code: 2)
        }

        guard existingPaths.contains(sourceURL.path) else {
            throw NSError(domain: "MockFileSystem", code: 3)
        }

        existingPaths.remove(sourceURL.path)
        existingPaths.insert(destinationURL.path)
    }
}
