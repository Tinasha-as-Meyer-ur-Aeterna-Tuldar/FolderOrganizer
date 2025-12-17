// AppTheme.swift
import SwiftUI

enum AppTheme {

    enum colors {

        // MARK: - Base
        static let accent = Color.accentColor
        static let cardBackground = Color(nsColor: .windowBackgroundColor)

        // MARK: - Text
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary

        // MARK: - Row Background
        static let rowOdd  = Color.primary.opacity(0.03)
        static let rowEven = Color.primary.opacity(0.06)

        // MARK: - Badges
        static let modifiedBadge = Color.blue
        static let subtitleBadge = Color.green
        static let maybeBadge    = Color.orange

        // MARK: - Space Markers（既存コード互換）
        static let spaceMarkerHalf = Color.red.opacity(0.6)
        static let spaceMarkerFull = Color.red
        static let newText         = Color.accentColor
    }
}
