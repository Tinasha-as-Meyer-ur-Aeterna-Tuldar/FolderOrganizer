// Domain/RenameWarning.swift
import Foundation

/// リネーム処理中に発生する警告・ブロック要因
///
/// UI / Summary / Export すべてがこの enum を参照する
/// case を減らすと壊れるので「増やすのみ」が原則
enum RenameWarning: Identifiable {
    case authorNotDetected
    case ambiguousSubtitle
    case duplicateNameExists

    var id: String { message }

    var message: String {
        switch self {
        case .authorNotDetected:
            return "作者が検出できません"
        case .ambiguousSubtitle:
            return "サブタイトルの判定が曖昧です"
        case .duplicateNameExists:
            return "同名フォルダが既に存在します"
        }
    }
}
