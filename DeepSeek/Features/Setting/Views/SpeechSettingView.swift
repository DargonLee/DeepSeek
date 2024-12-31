//
//  SpeechSettingView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import SwiftUI
import AVFAudio

struct SpeechSettingView: View {
    // MARK: - Properties
    @StateObject private var synthesizer = SpeechSynthesizer.shared
    @AppStorage("voiceIdentifier") private var selectedVoiceId: String = ""
    
    // MARK: - View
    var body: some View {
        List {
            infoSection
            voiceSelectionSection
        }
        .navigationTitle("语音设置")
    }
    
    // MARK: - Subviews
    private var infoSection: some View {
        Section {
            HStack(spacing: 12) {
                infoIcon
                infoContent
            }
            .padding(.vertical, 8)
        }
    }
    
    private var infoIcon: some View {
        Image(systemName: "info.circle.fill")
            .foregroundColor(.blue)
            .font(.system(size: 24))
    }
    
    private var infoContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("获取更多语音")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Text("前往 设置 > 辅助功能 > 朗读内容 > 声音")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
    }
    
    private var voiceSelectionSection: some View {
        Section("语音选择") {
            ForEach(synthesizer.voices, id: \.identifier) { voice in
                VoiceRowView(
                    voice: voice,
                    isSelected: selectedVoiceId == voice.identifier,
                    onSelect: {
                        selectedVoiceId = voice.identifier
                        testVoice(voice)
                    }
                )
            }
        }
    }
    
    // MARK: - Methods
    private func testVoice(_ voice: AVSpeechSynthesisVoice) {
        Task {
            await synthesizer.speak(text: "这是一段测试语音,用于验证\(voice.name)的语音效果。")
        }
    }
}

// MARK: - VoiceRowView
private struct VoiceRowView: View {
    let voice: AVSpeechSynthesisVoice
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(voice.name)
                    .font(.system(size: 16))
                Text(voice.language)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
}

#Preview {
    SpeechSettingView()
}
