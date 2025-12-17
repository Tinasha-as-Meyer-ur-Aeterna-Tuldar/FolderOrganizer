// Domain/RenamePlan.swift
import Foundation

struct RenamePlan: Identifiable {
    let id = UUID()

    let originalURL: URL
    let originalName: String
    let normalizedName: String

    let detectedAuthor: String?
    let title: String
    let subtitle: String?
    let maybeSubtitle: String?

    let targetParentFolder: URL
    let targetName: String

    let warnings: [RenameWarning]
}
