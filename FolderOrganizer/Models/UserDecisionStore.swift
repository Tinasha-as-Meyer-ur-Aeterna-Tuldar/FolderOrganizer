// Models/UserDecisionStore.swift
import Foundation
import Combine

final class UserDecisionStore: ObservableObject {

    // MARK: - Subtitle
    @Published private(set) var subtitleDecisions: [URL: UserSubtitleDecision] = [:]

    // MARK: - Author
    @Published private(set) var authorDecisions: [URL: UserAuthorDecision] = [:]

    // MARK: - Update
    func setSubtitleDecision(_ decision: UserSubtitleDecision, for url: URL) {
        subtitleDecisions[url] = decision
    }

    func setAuthorDecision(_ decision: UserAuthorDecision, for url: URL) {
        authorDecisions[url] = decision
    }
}
