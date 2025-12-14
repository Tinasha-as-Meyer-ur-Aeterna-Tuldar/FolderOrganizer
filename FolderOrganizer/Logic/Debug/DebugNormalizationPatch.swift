import Foundation

/// 確認用：After が必ず変わるようにする「一瞬パッチ」
/// - 本番では絶対に使わない（検証が終わったら削除 or 無効化）
/// - DEBUG ビルド限定
enum DebugNormalizationPatch {

    /// targetName を「確実に変える」
    /// - 例: "AAA" -> "AAA【PATCH】"
    static func applyToTargetName(_ name: String) -> String {
        #if DEBUG
        // すでに付いていたら二重に付けない
        if name.contains("【PATCH】") { return name }
        return name + "【PATCH】"
        #else
        return name
        #endif
    }
}
