//
//  EmptyConversaitonView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import SwiftUI

struct EmptyConversaitonView: View {
    let onSendPrompt: (String) -> Void
    @State private var samplePrompts = SamplePrompts.shuffled
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                DeepSeekLogo()
                Text("今天我有什么能帮助你的？")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
//            LazyVGrid(
//                columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12
//            ) {
//                ForEach(samplePrompts.prefix(6)) { prompt in
//                    PromptButton(prompt: prompt) {
//                        onSendPrompt(prompt.prompt)
//                        Haptics.shared.light()
//                    }
//                }
//                
//            }
//            .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(samplePrompts.prefix(3)) { prompt in
                    PromptButton(prompt: prompt) {
                        onSendPrompt(prompt.prompt)
                        Haptics.shared.light()
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 32)
    }
}

// MARK: - DeepSeek Logo
private struct DeepSeekLogo: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Deep")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("Seek")
                .font(.system(size: 40, weight: .medium, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Prompt Button
private struct PromptButton: View {
    let prompt: SamplePrompts
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // 左侧图标
                Image(systemName: prompt.type.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.accentColor)
                    .frame(width: 24)
                
                // 提示文本
                Text(prompt.prompt)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // 发送图标
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 20))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style
private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    EmptyConversaitonView(onSendPrompt: { message in
        print("发送消息: \(message)")
    })
}
