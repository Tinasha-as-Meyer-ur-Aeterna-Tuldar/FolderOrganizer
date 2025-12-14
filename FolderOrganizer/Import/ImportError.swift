import Foundation

enum ImportError: LocalizedError {

    case unsupportedVersion(String)
    case invalidData
    case fileNotFound(URL)

    var errorDescription: String? {
        switch self {
        case .unsupportedVersion(let version):
            return "未対応のバージョンです: \(version)"
        case .invalidData:
            return "JSON の形式が不正です"
        case .fileNotFound(let url):
            return "ファイルが見つかりません: \(url.lastPathComponent)"
        }
    }
}
