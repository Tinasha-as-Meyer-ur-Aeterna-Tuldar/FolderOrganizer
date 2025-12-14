import Foundation

/// フォルダ / ファイルが置かれている文脈情報
struct ContextInfo {

    /// 現在の親フォルダ
    let currentParent: URL

    /// 作者フォルダ直下かどうか
    let isUnderAuthorFolder: Bool

    /// 検出された作者フォルダ名
    /// isUnderAuthorFolder == true の場合のみ入る
    let detectedAuthorFolderName: String?
}
