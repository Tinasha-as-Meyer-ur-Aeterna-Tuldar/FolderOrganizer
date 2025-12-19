// AppTheme.swift
import SwiftUI

enum AppTheme {

    enum colors {
        
        //        static let previewBackground = Color.secondary.opacity(0.12)
        
        //        static let spaceHalf = Color.blue.opacity(0.55)
        //        static let spaceFull = Color.orange.opacity(0.85)
        
        static let spaceHalf = Color.white
        static let spaceFull = Color.white
        
        
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
        
        static let newText         = Color.accentColor
       
        // 既存
//        static let cardBackground = Color.primary.opacity(0.04)
        
        // 追加（これだけ残す）
        static let previewBackground = Color.primary.opacity(0.05)
        static let previewBorder     = Color.primary.opacity(0.15)
        
        // SpaceMarker
        static let spaceMarkerHalf = Color.red.opacity(0.6)
        static let spaceMarkerFull = Color.red
    }
}
