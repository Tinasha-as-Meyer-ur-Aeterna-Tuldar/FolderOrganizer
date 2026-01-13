//
//  MockFileSystem.swift
//  FolderOrganizer
//
//  テスト用の仮想ファイルシステム（メモリ上のみ）
//  FileSystem プロトコルの完全準拠実装
//

import Foundation

/// メモリ上で動作する FileSystem のモック実装
final class MockFileSystem: FileSystem {

    // MARK: - Internal State

    /// 存在しているパス（path 文字列で管理）
    private(set) var existingPaths: Set<String>

    /// エラー注入用フラグ
    var shouldFailOnCreateDirectory: Bool = false
    var shouldFailOnMove: Bool = false
    var shouldFailOnRemove: Bool = false

    // MARK: - Init

    init(initialPaths: [URL] = []) {
        self.existingPaths = Set(initialPaths.map { $0.path })
    }

    // MARK: - FileSystem

    /// 指定URLが存在するか
    func fileExists(at url: URL) -> Bool {
        existingPaths.contains(url.path)
    }

    /// ディレクトリを作成する
    func createDirectory(at url: URL) throws {
        if shouldFailOnCreateDirectory {
            throw NSError(
                domain: "MockFileSystem",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "createDirectory failed (mock)"]
            )
        }

        existingPaths.insert(url.path)
    }

    /// ファイル or ディレクトリを移動する
    func moveItem(from sourceURL: URL, to destinationURL: URL) throws {
        if shouldFailOnMove {
            throw NSError(
                domain: "MockFileSystem",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "moveItem failed (mock)"]
            )
        }

        guard existingPaths.contains(sourceURL.path) else {
            throw NSError(
                domain: "MockFileSystem",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "source item does not exist (mock)"]
            )
        }

        existingPaths.remove(sourceURL.path)
        existingPaths.insert(destinationURL.path)
    }

    /// ファイル or ディレクトリを削除する
    func removeItem(at url: URL) throws {
        if shouldFailOnRemove {
            throw NSError(
                domain: "MockFileSystem",
                code: 4,
                userInfo: [NSLocalizedDescriptionKey: "removeItem failed (mock)"]
            )
        }

        guard existingPaths.contains(url.path) else {
            throw NSError(
                domain: "MockFileSystem",
                code: 5,
                userInfo: [NSLocalizedDescriptionKey: "item does not exist (mock)"]
            )
        }

        existingPaths.remove(url.path)
    }
}
