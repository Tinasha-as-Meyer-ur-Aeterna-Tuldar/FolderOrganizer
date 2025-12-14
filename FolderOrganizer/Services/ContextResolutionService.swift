import Foundation

protocol ContextResolutionService {

    /// URL の置かれている文脈を解決する
    func resolveContext(for url: URL) -> ContextInfo
}

final class DefaultContextResolutionService: ContextResolutionService {

    func resolveContext(for url: URL) -> ContextInfo {

        let parent = url.deletingLastPathComponent()
        let parentName = parent.lastPathComponent

        // 作者フォルダ判定
        let authorFolderName = detectAuthorFolderName(from: parentName)

        return ContextInfo(
            currentParent: parent,
            isUnderAuthorFolder: authorFolderName != nil,
            detectedAuthorFolderName: authorFolderName
        )
    }
}

private extension DefaultContextResolutionService {

    /// 作者フォルダ名を検出する
    ///
    /// 例:
    ///  "山田太郎"        → 山田太郎
    ///  "[山田太郎]"      → 山田太郎
    ///  "山田太郎_作品集" → nil（作者単独でない）
    func detectAuthorFolderName(from folderName: String) -> String? {

        let trimmed = folderName.trimmingCharacters(in: .whitespacesAndNewlines)

        // [作者名] 形式
        if trimmed.hasPrefix("["),
           trimmed.hasSuffix("]") {

            let name = trimmed
                .dropFirst()
                .dropLast()
                .trimmingCharacters(in: .whitespaces)

            return name.isEmpty ? nil : String(name)
        }

        // 純粋に作者名のみ（記号を含まない）
        if isPlainAuthorName(trimmed) {
            return trimmed
        }

        return nil
    }

    /// 「作者名っぽい単独フォルダ」か判定
    ///
    /// ・空白はOK
    /// ・記号を含まない
    /// ・長すぎない
    func isPlainAuthorName(_ name: String) -> Bool {

        guard name.count >= 2, name.count <= 40 else {
            return false
        }

        // 記号を含む場合は除外
        let invalidCharacterSet = CharacterSet
            .punctuationCharacters
            .union(.symbols)

        return name.rangeOfCharacter(from: invalidCharacterSet) == nil
    }
}
