//
//  ThemeManager.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/11.
//

import SwiftUI

final class ThemeManager {
    static let shared = ThemeManager()
    
    // MARK: - Published Properties
    @AppStorage("isDarkMode") var isDarkMode = false
    @AppStorage("useSystemTheme") var useSystemTheme = true
    @AppStorage("accentColor") var accentColorName = "Blue"

    private(set) var accentColor: Color = .blue
    
    // MARK: - Constants
    static let availableColors: [ColorOption] = [
        ColorOption(name: "Blue", color: .blue),
        ColorOption(name: "Purple", color: .purple),
        ColorOption(name: "Pink", color: .pink),
        ColorOption(name: "Red", color: .red),
        ColorOption(name: "Orange", color: .orange),
        ColorOption(name: "Green", color: .green)
    ]
    
    private init() {
        updateAccentColor()
    }
    
    // MARK: - Public Methods
    func setThemeMode(_ mode: ThemeMode, systemColorScheme: ColorScheme) {
        switch mode {
        case .system:
            useSystemTheme = true
            isDarkMode = systemColorScheme == .dark
        case .dark:
            useSystemTheme = false
            isDarkMode = true
        case .light:
            useSystemTheme = false
            isDarkMode = false
        }
    }
    
    func setAccentColor(_ name: String) {
        accentColorName = name
        updateAccentColor()
    }
    
    private func updateAccentColor() {
        if let colorOption = Self.availableColors.first(where: { $0.name == accentColorName}) {
            accentColor = colorOption.color
        }
    }
}
