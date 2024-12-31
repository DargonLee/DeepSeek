//
//  ChatSectionListView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import SwiftUI

// MARK: - ChatSectionListView
struct ChatSectionListView: View {
    // MARK: - Properties
    let sections: [SidebarChatSection]
    let chatStore: ChatStore
    @Binding var isSidebarVisible: Bool
    
    // MARK: - Body
    var body: some View {
        List {
            ForEach(sections, id: \.id) { section in
                ChatSectionView(
                    section: section,
                    chatStore: chatStore,
                    isSidebarVisible: $isSidebarVisible
                )
            }
        }
    }
}

// MARK: - Chat Section View
private struct ChatSectionView: View {
    // MARK: - Properties
    let section: SidebarChatSection
    let chatStore: ChatStore
    @Binding var isSidebarVisible: Bool
    
    // MARK: - Body
    var body: some View {
        Section(header: Text(section.title)) {
            chatList
        }
    }
    
    // MARK: - Subviews
    private var chatList: some View {
        ForEach(section.items) { chat in
            chatRow(for: chat)
        }
        .onDelete(perform: deleteChatItems)
    }
    
    private func chatRow(for chat: Chat) -> some View {
        HStack {
            selectionIndicator(for: chat)
            ChatListItemView(chat: chat)
        }
        .onTapGesture {
            handleChatSelection(chat)
        }
    }

    private func selectionIndicator(for chat: Chat) -> some View {
        Circle()
            .fill(chatStore.currentChat?.id == chat.id ? Color.blue : Color.clear)
            .frame(width: 8, height: 8)
    }
    
    // MARK: - Actions
    private func handleChatSelection(_ chat: Chat) {
        chatStore.switchChat(chat: chat)
        withAnimation {
            isSidebarVisible = false
        }
    }
    
    private func deleteChatItems(at offsets: IndexSet) {
        for index in offsets {
            chatStore.deleteChat(chat: section.items[index])
        }
    }
}

// MARK: - Chat Section Item View
private struct ChatListItemView: View {
    // MARK: - Properties
    let chat: Chat
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            chatTitle
            lastMessagePreview
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Subviews
    private var chatTitle: some View {
        Text(chat.title)
            .font(.headline)
            .lineLimit(1)
    }
    
    private var lastMessagePreview: some View {
        Group {
            if let lastMessage = chat.messages.last {
                Text(lastMessage.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}
