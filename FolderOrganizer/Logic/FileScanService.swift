import Foundation
#if os(macOS)
import AppKit
#endif

struct NormalizedExportRow: Codable {
    let original: String
    let renamed: String
    let flagged: Bool
}

struct AuthorMoveLog: Codable {
    let newAuthorFolderName: String
    let newWorkFolderName: String
}

struct FileScanService {

    // MARK: - 0. サンプルデータ（デバッグ・UIプレビュー用）
    static func loadSampleNames() -> [RenameItem] {
        let samples = [
            "(同人誌)【黒山羊野メェ吉】元カレのデカチンが忘れられないの？;; (オリジナル) [DL版]",
            "[diletta] 復讐に飢えた没落令嬢をメス堕ちするまで飼いならし、愛る。",
            "【立花ミナミ】異世界ハーレム物語 vol.2.5",
            "【あいざわひろし】",
            "（成年コミック）[猫夜] あげちん♂ ～美女たちにSEXしてとせがまれて～ [DL版]"
        ]

        return samples.map { name in
            let result = NameNormalizer.normalize(name)
            return RenameItem(
                original: name,
                normalized: result.normalizedName,   // ✅ ここ
                flagged: false
            )
        }
    }

    // MARK: - 1. フォルダ選択ダイアログ
    #if os(macOS)
    static func pickFolder(completion: @escaping (URL?) -> Void) {
        let panel = NSOpenPanel()
        panel.title = "フォルダを選択"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        panel.begin { response in
            if response == .OK {
                completion(panel.url)
            } else {
                completion(nil)
            }
        }
    }
    #endif

    // MARK: - 2. 対象フォルダ配下のフォルダ名を取得
    static func loadFolderNames(from rootURL: URL) -> [String] {
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: rootURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            let onlyFolders = contents.filter { url in
                (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
            }

            return onlyFolders.map { $0.lastPathComponent }
        } catch {
            print("フォルダ読み込みエラー:", error)
            return []
        }
    }

    // MARK: - 3. normalize 済み結果を JSON で書き出す（検証用）
    #if os(macOS)
    static func exportNormalizedJSON(from rootURL: URL) {
        let names = loadFolderNames(from: rootURL)

        let rows: [NormalizedExportRow] = names.map { name in
            let result = NameNormalizer.normalize(name)
            return NormalizedExportRow(
                original: name,
                renamed: result.normalizedName,      // ✅ ここ
                flagged: false
            )
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        do {
            let data = try encoder.encode(rows)

            let panel = NSSavePanel()
            panel.title = "正規化結果を JSON で書き出し"
            panel.nameFieldStringValue = "FolderOrganizer_Normalized.json"
            panel.allowedContentTypes = [.json]

            if panel.runModal() == .OK, let url = panel.url {
                try data.write(to: url)
                print("JSON exported to:", url.path)
            }
        } catch {
            print("JSON export error:", error)
        }
    }
    #endif
}
