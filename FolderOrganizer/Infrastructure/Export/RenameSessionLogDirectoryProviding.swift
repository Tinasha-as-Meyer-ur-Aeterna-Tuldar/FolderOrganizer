// Infrastructure/Export/RenameSessionLogDirectoryProviding.swift
//
// RenameSessionLog の保存先ディレクトリを提供する責務の抽象
//

import Foundation

protocol RenameSessionLogDirectoryProviding {

    /// Export 用ディレクトリを返す
    /// - Throws: ディレクトリ作成に失敗した場合
    func exportDirectory() throws -> URL
}
