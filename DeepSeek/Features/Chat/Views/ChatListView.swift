//
//  ChatListView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import SwiftUI

struct ChatMessageListView: View {
    // MARK: - Properties
    let messages: [ChatMessage]
    let isLoading: Bool
    let onEditMessage: (String) -> Void

    @State private var selectedMessage: ChatMessage?
    @StateObject private var speechSynthesizer = SpeechSynthesizer.shared
    @Environment(\.hideKeyboard) private var hideKeyboard
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            messageList
            readingAloudOverlay
        }
        .sheet(item: $selectedMessage) { message in
            messageDetailSheet(message)
        }
    }
    
    // MARK: - Private Views
    private var messageList: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                ForEach(messages) { message in
                    messageRow(message)
                }
            }
            .onAppear { scrollToBottom(proxy: scrollViewProxy) }
            .onChange(of: messages) { _, _ in scrollToBottom(proxy: scrollViewProxy) }
            .onChange(of: messages.last?.content) { _, _ in scrollToBottom(proxy: scrollViewProxy) }
            .simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { _ in
                        hideKeyboard()
                    }
            )
        }
    }
    
    private func messageRow(_ message: ChatMessage) -> some View {
        ChatMessageView(message: message)
            .id(message.id)
            .overlay(
                ChatMessageLoadingView(
                    message: message,
                    messages: messages,
                    isLoading: isLoading
                )
            )
            .contextMenu {
                MessageContextMenu(
                    message: message,
                    onCopy: copyMessage,
                    onSelect: { selectedMessage = message },
                    onReadAloud: onReadAloud,
                    onEdit: { onEditMessage(message.content) }
                )
            }
    }
    
    private var readingAloudOverlay: some View {
        ReadingAloudView(onStopTap: stopReadingAloud)
            .frame(maxWidth: 400)
            .showIf(speechSynthesizer.isSpeaking)
            .transition(
                .asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.7, anchor: .top)),
                    removal: .opacity.combined(with: .scale(scale: 0.7, anchor: .top))
                )
            )
    }
    
    private func messageDetailSheet(_ message: ChatMessage) -> some View {
        NavigationStack {
            ScrollView {
                Text(message.content)
                    .padding()
                    .textSelection(.enabled)
            }
            .navigationTitle("选择文本")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Helper Methods
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = messages.last {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    private func copyMessage(_ message: String) {
        Clipboard.shared.setString(message)
    }
    
    private func onReadAloud(_ message: String) {
        Task {
            await speechSynthesizer.speak(text: message)
        }
    }
    
    private func stopReadingAloud() {
        Task {
            await speechSynthesizer.stopSpeaking()
        }
    }
}

// MARK: - Supporting Views
private struct ChatMessageLoadingView: View {
    let message: ChatMessage
    let messages: [ChatMessage]
    let isLoading: Bool
    
    var body: some View {
        Group {
            if shouldShowLoading {
                HStack {
                    StreamingLoadingView()
                        .transition(.opacity)
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.leading)
            }
        }
    }
    
    private var shouldShowLoading: Bool {
        message.id == messages.last?.id && message.role == .assistant && isLoading
            && message.content.isEmpty
    }
}

private struct MessageContextMenu: View {
    let message: ChatMessage
    
    let onCopy: (String) -> Void
    let onSelect: () -> Void
    let onReadAloud: (String) -> Void
    let onEdit: () -> Void
    
    var onAppear: (() -> Void)? = nil
    var onDisappear: (() -> Void)? = nil
    
    var body: some View {
        Group {
            Button(action: { onCopy(message.content) }) {
                Label("复制", systemImage: "doc.on.doc")
            }
            
            Button(action: onSelect) {
                Label("选择文本", systemImage: "selection.pin.in.out")
            }
            
            Button(action: { onReadAloud(message.content) }) {
                Label("朗读", systemImage: "speaker.wave.3.fill")
            }
            
            if message.role == .user {
                Button(action: onEdit) {
                    Label("编辑", systemImage: "pencil")
                }
            }
        }
        .onAppear { onAppear?() }
        .onDisappear { onDisappear?() }
    }
}
