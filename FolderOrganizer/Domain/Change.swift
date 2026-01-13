//  Domain/Change.swift

import Foundation

// MARK: - Change
struct Change: Codable, Hashable {

    enum Kind: String, Codable {
        case renamed
        case unchanged
    }

    let kind: Kind

    init(original: String, final: String) {
        self.kind = (original == final) ? .unchanged : .renamed
    }
}
