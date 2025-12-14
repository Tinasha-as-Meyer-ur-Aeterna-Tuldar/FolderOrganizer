import Foundation

// MARK: - Public Protocol

protocol RoleDetectionService {
    func detectRoles(from tokens: NameTokens) -> RoleDetectionResult
}

// MARK: - Default Implementation

final class DefaultRoleDetectionService: RoleDetectionService {

    // MARK: - 定義済みルール

    /// 確定 subtitle として扱って良いワード
    private let definiteSubtitleKeywords: [String] = [
        "特典",
        "修正版",
        "完全版",
        "初回限定",
        "増補版",
        "再編集版"
    ]

    /// subtitle かもしれないが断定できないワード
    private let ambiguousSubtitleKeywords: [String] = [
        "DL",
        "DL版",
        "ダウンロード",
        "電子版",
        "RAW",
        "JPG",
        "PNG"
    ]

    // MARK: - Main
    func detectRoles(from tokens: NameTokens) -> RoleDetectionResult {

        // 1️⃣ author 判定
        let author = detectAuthor(from: tokens)
        // 2️⃣ subtitle / maybe subtitle 判定
        let subtitleResult = detectSubtitles(from: tokens.rawSubstrings)
        // 3️⃣ title 決定
        let title = buildTitle(
            tokens: tokens,
            author: author,
            subtitle: subtitleResult.subtitle,
            maybeSubtitle: subtitleResult.maybeSubtitle
        )

        return RoleDetectionResult(
            author: author,
            title: title,
            subtitle: subtitleResult.subtitle,
            maybeSubtitle: subtitleResult.maybeSubtitle
        )
    }
}

// MARK: - Private Logic

private extension DefaultRoleDetectionService {

    // MARK: - Author

    func detectAuthor(from tokens: NameTokens) -> String? {
        // [] から抽出された候補があれば最優先
        return tokens.authorCandidates.first
    }

    // MARK: - Subtitle 判定

    func detectSubtitles(from rawSubstrings: [String])
        -> (subtitle: String?, maybeSubtitle: String?) {

        var detectedSubtitle: String?
        var detectedMaybeSubtitle: String?

        for value in rawSubstrings {

            // 確定 subtitle
            if definiteSubtitleKeywords.contains(where: { value.contains($0) }) {
                detectedSubtitle = value
                continue
            }

            // 不確定 subtitle
            if ambiguousSubtitleKeywords.contains(where: { value.contains($0) }) {
                detectedMaybeSubtitle = value
            }
        }

        return (detectedSubtitle, detectedMaybeSubtitle)
    }

    // MARK: - Title 構築

    func buildTitle(
        tokens: NameTokens,
        author: String?,
        subtitle: String?,
        maybeSubtitle: String?
    ) -> String {

        var titleCandidates = tokens.titleCandidates

        // author が titleCandidates に混ざっていたら除外
        if let author {
            titleCandidates.removeAll { $0.contains(author) }
        }

        // subtitle / maybe subtitle を除外
        if let subtitle {
            titleCandidates.removeAll { $0.contains(subtitle) }
        }

        if let maybeSubtitle {
            titleCandidates.removeAll { $0.contains(maybeSubtitle) }
        }

        // 最終 fallback
        return titleCandidates.first ?? ""
    }
}
