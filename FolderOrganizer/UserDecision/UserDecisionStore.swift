import Foundation
import Combine

final class UserDecisionStore: ObservableObject {

    // MARK: - Public State

    /// key: originalURL.path
    @Published private(set) var subtitleDecisions: [String: UserSubtitleDecision] = [:]
    @Published private(set) var authorDecisions: [String: UserAuthorDecision] = [:]

    // MARK: - Private

    private let payloadKey = "UserDecisionStore.payload.v1"
    private let legacySubtitleKey = "UserDecisionStore.subtitleDecisions.v1" // 旧キー互換
    private var cancellables = Set<AnyCancellable>()

    private struct Payload: Codable {
        var subtitleDecisions: [String: UserSubtitleDecision]
        var authorDecisions: [String: UserAuthorDecision]
    }

    // MARK: - Init

    init() {
        load()

        Publishers.CombineLatest($subtitleDecisions.dropFirst(),
                                $authorDecisions.dropFirst())
            .sink { [weak self] _, _ in
                self?.save()
            }
            .store(in: &cancellables)
    }

    // MARK: - Subtitle Decision

    func decision(for url: URL) -> UserSubtitleDecision {
        subtitleDecisions[url.path] ?? .undecided
    }

    func setDecision(_ decision: UserSubtitleDecision, for url: URL) {
        subtitleDecisions[url.path] = decision
    }

    func resetDecision(for url: URL) {
        subtitleDecisions.removeValue(forKey: url.path)
    }

    // MARK: - Author Decision

    func authorDecision(for url: URL) -> UserAuthorDecision {
        authorDecisions[url.path] ?? .undecided
    }

    func setAuthorDecision(_ decision: UserAuthorDecision, for url: URL) {
        authorDecisions[url.path] = decision
    }

    func resetAuthorDecision(for url: URL) {
        authorDecisions.removeValue(forKey: url.path)
    }

    // MARK: - Reset

    func resetAll() {
        subtitleDecisions.removeAll()
        authorDecisions.removeAll()
    }

    // MARK: - Persistence

    private func save() {
        do {
            let payload = Payload(subtitleDecisions: subtitleDecisions,
                                  authorDecisions: authorDecisions)
            let data = try JSONEncoder().encode(payload)
            UserDefaults.standard.set(data, forKey: payloadKey)
        } catch {
            assertionFailure("Failed to save UserDecisionStore payload: \(error)")
        }
    }

    private func load() {
        // 新形式
        if let data = UserDefaults.standard.data(forKey: payloadKey) {
            do {
                let payload = try JSONDecoder().decode(Payload.self, from: data)
                subtitleDecisions = payload.subtitleDecisions
                authorDecisions = payload.authorDecisions
                return
            } catch {
                // 壊れてたら安全側
                subtitleDecisions = [:]
                authorDecisions = [:]
                return
            }
        }

        // 旧形式（subtitleのみ）互換
        if let legacy = UserDefaults.standard.data(forKey: legacySubtitleKey) {
            do {
                subtitleDecisions = try JSONDecoder().decode([String: UserSubtitleDecision].self, from: legacy)
                authorDecisions = [:]
            } catch {
                subtitleDecisions = [:]
                authorDecisions = [:]
            }
        }
    }
}
