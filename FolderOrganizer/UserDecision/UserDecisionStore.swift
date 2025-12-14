import Foundation
import Combine

final class UserDecisionStore: ObservableObject {

    // MARK: - Public State

    /// key: originalURL.path
    /// value: ユーザー判断
    @Published private(set) var subtitleDecisions: [String: UserSubtitleDecision] = [:]

    // MARK: - Private

    private let storageKey = "UserDecisionStore.subtitleDecisions.v1"
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        load()

        // 変更があったら自動保存
        $subtitleDecisions
            .dropFirst()
            .sink { [weak self] _ in
                self?.save()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public API

    func decision(for url: URL) -> UserSubtitleDecision {
        subtitleDecisions[url.path] ?? .undecided
    }

    func setDecision(
        _ decision: UserSubtitleDecision,
        for url: URL
    ) {
        subtitleDecisions[url.path] = decision
    }

    func resetDecision(for url: URL) {
        subtitleDecisions.removeValue(forKey: url.path)
    }

    func resetAll() {
        subtitleDecisions.removeAll()
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(subtitleDecisions)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            assertionFailure("Failed to save UserDecisionStore: \(error)")
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            subtitleDecisions = try JSONDecoder().decode(
                [String: UserSubtitleDecision].self,
                from: data
            )
        } catch {
            // 壊れていたら安全側で初期化
            subtitleDecisions = [:]
        }
    }
}
