// Domain/Export/ApplyResultLog.swift
//
// ApplyResult の Export 用 DTO
//

import Foundation

struct ApplyResultLog: Codable {

    let planId: UUID
    let status: Status
    let fromPath: String?
    let toPath: String?
    let reason: String?

    enum Status: String, Codable {
        case success
        case skipped
        case failure
    }
}
