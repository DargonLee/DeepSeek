//
//  ThemeSettingView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import SwiftUI

struct ThemeSettingView: View {
    @State private var themeManager = ThemeManager.shared
    @Environment(\.colorScheme) private var systemColorScheme
    
    // MARK: - View
    var body: some View {
        Form {
            themeSection
            accentColorSection
        }
        .navigationTitle("主题设置")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: themeManager.useSystemTheme) { _, newValue in
            if newValue {
                themeManager.setThemeMode(.system, systemColorScheme: systemColorScheme)
            }
        }
    }
    
    // MARK: - Subviews
    private var themeSection: some View {
        Section("主题模式") {
            ForEach(ThemeMode.allCases) { mode in
                ThemeModeRow(
                    mode: mode,
                    isSelected: isThemeModeSelected(mode),
                    action: {
                        themeManager.setThemeMode(mode, systemColorScheme: systemColorScheme)
                    }
                )
            }
        }
    }
    
    private func isThemeModeSelected(_ mode: ThemeMode) -> Bool {
        switch mode {
        case .system: return themeManager.useSystemTheme
        case .dark: return !themeManager.useSystemTheme && themeManager.isDarkMode
        case .light: return !themeManager.useSystemTheme && !themeManager.isDarkMode
        }
    }
    
    private var accentColorSection: some View {
        Section("强调色") {
            ForEach(ThemeManager.availableColors) { option in
                ColorRowView(
                    option: option,
                    isSelected: themeManager.accentColorName == option.name,
                    action: { themeManager.setAccentColor(option.name) }
                )
            }
        }
    }
}

// MARK: - Theme Mode Row
private struct ThemeModeRow: View {
    let mode: ThemeMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: mode.icon)
                    .foregroundColor(.primary)
                Text(mode.title)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

// MARK: - Color Row View
private struct ColorRowView: View {
    let option: ColorOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(option.color)
                    .frame(width: 20, height: 20)
                
                Text(option.name)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ThemeSettingView()
    }
}
