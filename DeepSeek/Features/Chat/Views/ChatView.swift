//
//  ChatView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/1.
//

import SwiftData
import SwiftUI

struct ChatView: View {
    let chatStore: ChatStore

    private var messages: [ChatMessage] {
        chatStore.currentChat?.sortedMessages ?? []
    }
    @State private var newMessageText: String = ""
    @State private var isLoading: Bool = false
    @Environment(\.hideKeyboard) private var hideKeyboard

    var body: some View {
        VStack {
            if messages.isEmpty {
                EmptyConversaitonView(onSendPrompt: sendMessage)
            } else {
                ChatMessageListView(
                    messages: messages,
                    isLoading: chatStore.isLoading,
                    onEditMessage: { message in
                        newMessageText = message
                    }
                )
                .withHideKeyboard()
            }
            
            Spacer()
            
            ChatInputView(
                text: $newMessageText,
                isLoading: chatStore.isLoading,
                isResponding: chatStore.isResponding,
                onSend: sendMessage,
                onPause: handlePause,
                onSelectedPicture: handleSelectedPicture,
                onSelectedFile: handleSelectedFile,
                onCapturePhoto: {
                    
                }
            )
        }
        .background(Color(.systemBackground))
        .onTapGesture {
            hideKeyboard()
        }
        .alert("提示", isPresented: .constant(chatStore.errorMessage != nil)) {
            Button("确定") {
            }
        } message: {
            Text(chatStore.errorMessage ?? "未知错误")
        }
    }
}

// MARK: - Action Handlers
private extension ChatView {
    func sendMessage(_ message: String) {
        newMessageText = ""
        Task {
            do {
                try await chatStore.sendMessage(message)
            } catch {
                print("发送消息失败：\(error)")
            }
        }
    }

    func handlePause() {
        chatStore.cancelStreaming()
    }

    func handleSelectedPicture() {
        print("selectedPicture")
    }

    func handleSelectedFile() {
        print("selectedFile")
    }
}

#Preview {
    ChatView(chatStore: ChatStore(modelContext: ModelContext(try! ModelContainer(for: Chat.self))))
}
