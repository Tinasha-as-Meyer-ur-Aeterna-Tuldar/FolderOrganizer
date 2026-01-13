import Foundation
import Combine

protocol SubtitleDecisionStoring {
    func setSubtitleDecision(confirmAsSubtitle: Bool, for url: URL)
    func decision(for url: URL) -> Bool?
}

final class UserDecisionStore: ObservableObject, SubtitleDecisionStoring {

    /// url.path をキーにする
    @Published private var decisions: [String: Bool] = [:]

    // ✅ Combine 用に「変更通知だけ」公開
    var decisionsPublisher: AnyPublisher<Void, Never> {
        $decisions.map { _ in () }.eraseToAnyPublisher()
    }

    func setSubtitleDecision(confirmAsSubtitle: Bool, for url: URL) {
        decisions[url.path] = confirmAsSubtitle
    }

    func decision(for url: URL) -> Bool? {
        decisions[url.path]
    }
}
