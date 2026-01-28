// FolderOrganizer/Domain/Browse/FolderRole.swift
//
// フォルダの役割推定（SERIES / VOLUME / UNKNOWN）
// - 名前ベースで軽量に判定
// - 確信度（Confidence）は別レイヤーで評価する
//

import Foundation

func inferRole(
    name: String,
    parentRole: FolderRoleHint?
) -> FolderRoleHint {

    let normalized = name.lowercased()

    // ------------------------------------
    // ① 明示的な巻数表現（最優先）
    // ------------------------------------
    if looksLikeExplicitVolume(normalized) {
        return .volume
    }

    // ------------------------------------
    // ② 漢数字「単体」巻（★今回追加）
    //    条件：
    //    - 親が SERIES
    //    - 名前が漢数字のみ
    // ------------------------------------
    if parentRole == .series,
       VolumeNumberDetector.isPureKanjiNumber(name) {
        return .volume
    }

    // ------------------------------------
    // ③ 親が SERIES で、数字を含む
    // ------------------------------------
    if parentRole == .series,
       containsAnyNumber(normalized) {
        return .volume
    }

    // ------------------------------------
    // ④ 子に複数 VOLUME がぶら下がる想定 → SERIES
    // （※ TreeBuilder 側で後処理）
    // ------------------------------------
    if looksLikeSeriesName(normalized) {
        return .series
    }

    return .unknown
}

// MARK: - Helpers

private func looksLikeExplicitVolume(_ name: String) -> Bool {
    return name.contains("第")
        || name.contains("巻")
        || name.contains("vol")
        || name.contains("v")
}

private func containsAnyNumber(_ name: String) -> Bool {
    name.rangeOfCharacter(from: .decimalDigits) != nil
}

private func looksLikeSeriesName(_ name: String) -> Bool {
    // 今は弱め。将来ここを強化する
    return !looksLikeExplicitVolume(name)
}
