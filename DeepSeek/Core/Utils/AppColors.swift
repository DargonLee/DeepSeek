//
//  AppColors.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/11.
//

import SwiftUI

struct AppColors {
    // MARK: - Background Colors
    static let background = Color("Background")
    static let secondaryBackground = Color("SecondaryBackground")
    static let groupedBackground = Color("GroupedBackground")
    
    // MARK: - Text Colors
    static let primaryText = Color("PrimaryText")
    static let secondaryText = Color("SecondaryText")
    
    // MARK: - Chat Colors
    static let userBubble = Color("UserBubble")
    static let assistantBubble = Color("AssistantBubble")
    
    // MARK: - UI Elements
    static let separator = Color("Separator")
    static let overlay = Color("Overlay")
}

// MARK: - Supporting Types
struct ColorOption: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

enum ThemeMode: String, CaseIterable, Identifiable {
    case system, dark, light
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .system: return "iphone"
        case .dark: return "moon.fill"
        case .light: return "sun.max.fill"
        }
    }
    
    var title: String {
        switch self {
        case .system: return "跟随系统"
        case .dark: return "深色模式"
        case .light: return "浅色模式"
        }
    }
}
