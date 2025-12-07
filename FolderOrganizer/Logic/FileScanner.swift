//  Logic/FileScanner.swift
import Foundation
import AppKit

struct FileScanner {

    // フォルダ選択ダイアログを表示して URL を返す
    // （キャンセル時は nil）
    static func pickFolder(completion: @escaping (URL?) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = false
        panel.prompt = "選択"

        // 非同期で開く（UI をブロックしない）
        panel.begin { response in
            if response == .OK {
                completion(panel.url)
            } else {
                completion(nil)
            }
        }
    }

    // 指定フォルダ直下の「サブフォルダ名」だけを列挙して返す
    // 返り値はフォルダ名（文字列）の配列
    static func loadFolderNames(from root: URL) -> [String] {
        let fm = FileManager.default

        let resourceKeys: [URLResourceKey] = [
            .isDirectoryKey,
            .isHiddenKey
        ]

        guard let enumerator = fm.enumerator(
            at: root,
            includingPropertiesForKeys: resourceKeys,
            options: [
                .skipsHiddenFiles,              // 隠しファイル/フォルダは無視
                .skipsSubdirectoryDescendants   // 第1階層だけ
            ],
            errorHandler: { url, error in
                print("フォルダ列挙エラー:", url.path, error)
                return true   // エラーが出ても列挙を続行
            }
        ) else {
            return []
        }

        var names: [String] = []

        for case let url as URL in enumerator {
            do {
                let values = try url.resourceValues(forKeys: Set(resourceKeys))

                // ディレクトリだけを対象にする
                guard values.isDirectory == true else { continue }

                // フォルダ名（最後のパスコンポーネント）
                let folderName = url.lastPathComponent
                names.append(folderName)

            } catch {
                // 1件エラーになっても全体は止めない
                print("resourceValues 取得エラー:", error)
            }
        }

        // 安定した順番で扱えるようにソートしておく
        return names.sorted()
    }
}
