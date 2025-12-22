import Foundation

enum UndoError: LocalizedError {

    case originalLocationAlreadyExists(URL)
    case appliedItemMissing(URL)
    case failedToMoveItem(from: URL, to: URL, underlying: Error)
    case notApplicable
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .originalLocationAlreadyExists(let url):
            return "元の場所に既に同名の項目があります: \(url.lastPathComponent)"
        case .appliedItemMissing(let url):
            return "元に戻す対象が見つかりません: \(url.lastPathComponent)"
        case .failedToMoveItem(_, _, let underlying):
            return "元に戻せませんでした: \(underlying.localizedDescription)"
        case .notApplicable:
            return "この項目は Undo 対象ではありません"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
