//
//  HomeView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/1.
//

import SwiftData
import SwiftUI

// MARK: - SidebarView
struct SidebarView: View {
    // MARK: - Properties
    let chatStore: ChatStore
    @Binding var isSidebarVisible: Bool
    
    // MARK: - State
    @Query(sort: [SortDescriptor(\Chat.startTime, order: .reverse)])
        private var allChats: [Chat]
    @State private var searchText: String = ""
    
    // MARK: - Constants
    private let sidebarWidth: CGFloat = UIScreen.main.bounds.width * 0.7

    // MARK: - Body
    var body: some View {
        HStack(spacing: 0) {
            sidebarNavigationView
            Spacer()
        }
    }
    
    // MARK: - Subviews
    private var sidebarNavigationView: some View {
        NavigationView {
            ChatListView(
                chatStore: chatStore,
                isSidebarVisible: $isSidebarVisible,
                searchText: $searchText,
                sections: filteredAndGroupedChats
            )
            .frame(width: sidebarWidth)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "搜索聊天记录"
            )
        }
        .offset(x: isSidebarVisible ? 0 : -sidebarWidth)
        .frame(width: sidebarWidth)
    }
    
    // MARK: - Computed Properties
    private var filteredAndGroupedChats: [SidebarChatSection] {
        let chatsToGroup = searchText.isEmpty ? allChats : allChats.filter { $0.title.localizedStandardContains(searchText) }
        return ChatGrouper.groupChats(chatsToGroup)
    }
}

// MARK: - ChatListView
private struct ChatListView: View {
    // MARK: - Properties
    let chatStore: ChatStore
    @Binding var isSidebarVisible: Bool
    @Binding var searchText: String
    let sections: [SidebarChatSection]
    
    // MARK: - Body
    var body: some View {
        Group {
            if sections.isEmpty && !searchText.isEmpty {
                EmptySearchResultView()
            } else if sections.isEmpty {
                EmptyChatListView()
            } else {
                ChatSectionListView(
                    sections: sections,
                    chatStore: chatStore,
                    isSidebarVisible: $isSidebarVisible
                )
            }
        }
        .navigationTitle("最近使用")
        .navigationBarTitleDisplayMode(.automatic)
        .safeAreaInset(edge: .bottom) {
            BottomBarView(chatStore: chatStore, iconWidth: 25)
        }
    }
}

#Preview {
    SidebarView(
        chatStore: ChatStore.preview,
        isSidebarVisible: .constant(true)
    )
}
