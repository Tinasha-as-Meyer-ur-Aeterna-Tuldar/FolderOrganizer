import Foundation

enum ApplyError: LocalizedError {

    case destinationAlreadyExists(URL)
    case failedToCreateDirectory(URL)
    case failedToMoveItem(from: URL, to: URL, underlying: Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .destinationAlreadyExists(let url):
            return "移動先が既に存在します: \(url.lastPathComponent)"
        case .failedToCreateDirectory(let url):
            return "フォルダを作成できませんでした: \(url.lastPathComponent)"
        case .failedToMoveItem(_, _, let underlying):
            return "移動に失敗しました: \(underlying.localizedDescription)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
