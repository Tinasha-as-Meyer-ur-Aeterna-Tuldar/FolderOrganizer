// FolderOrganizer/Domain/Browse/FolderConfidenceEvaluator.swift
//
// フォルダ役割の「確信度」を評価する（C-1）
//

import Foundation

struct FolderConfidenceEvaluator {

    // MARK: - Public

    func evaluate(node: FolderNode, parent: FolderNode?) -> FolderConfidence {

        switch node.roleHint {
        case .volume:
            return evaluateVolume(node: node, parent: parent)
        case .series:
            return evaluateSeries(node: node, parent: parent)
        case .unknown:
            return evaluateUnknown(node: node)
        }
    }

    // MARK: - Volume

    private func evaluateVolume(
        node: FolderNode,
        parent: FolderNode?
    ) -> FolderConfidence {

        var score = 0

        // ① 巻数らしさ
        if looksLikeVolumeName(node.name) {
            score += 1
        }

        // ② ノイズが少ない
        if !hasNoiseInName(node.name) {
            score += 1
        }

        // ③ 親が SERIES
        if parent?.roleHint == .series {
            score += 1
        }

        return confidence(from: score)
    }

    // MARK: - Series

    private func evaluateSeries(
        node: FolderNode,
        parent: FolderNode?
    ) -> FolderConfidence {

        var score = 0

        // ① 子が VOLUME で構成されている
        let children = node.children ?? []
        let volumeChildrenCount = children.filter { $0.roleHint == .volume }.count
        if volumeChildrenCount >= 2 {
            score += 1
        }

        // ② 自身が巻数っぽくない
        if !looksLikeVolumeName(node.name) {
            score += 1
        }

        // ③ ノイズが少ない
        if !hasNoiseInName(node.name) {
            score += 1
        }

        return confidence(from: score)
    }

    // MARK: - Unknown

    private func evaluateUnknown(node: FolderNode) -> FolderConfidence {

        var score = 0

        if looksLikeVolumeName(node.name) {
            score += 1
        }

        if !hasNoiseInName(node.name) {
            score += 1
        }

        return confidence(from: score)
    }

    // MARK: - Confidence Mapping

    private func confidence(from score: Int) -> FolderConfidence {
        switch score {
        case 3:
            return .high
        case 2:
            return .medium
        default:
            return .low
        }
    }

    // MARK: - Heuristics

    private func looksLikeVolumeName(_ name: String) -> Bool {
        VolumeNumberDetector.containsVolumeNumber(in: name)
    }

    private func hasNoiseInName(_ name: String) -> Bool {

        let noiseKeywords: [String] = [
            "DL", "dl",
            "RAW", "raw",
            "zip", "ZIP",
            "manga", "MANGA",
            "info", "INFO",
            "[", "]", "(", ")"
        ]

        return noiseKeywords.contains { name.contains($0) }
    }
}
