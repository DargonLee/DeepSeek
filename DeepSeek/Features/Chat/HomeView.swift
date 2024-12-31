//
//  HomeView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/1.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    // MARK: - Properties
    @State private var isSidebarVisible = false
    @State private var chatStore: ChatStore = AppContainer.shared.chatStore

    var body: some View {
        
        ZStack {
            NavigationStack {
                VStack {
                    ChatView(chatStore: chatStore)
                        .withHideKeyboard()
                }
                .navigationTitle(navigationTitle)
                .toolbar {
                    toolbarContent
                }
            }
            
            BlurredBackgroundView(isVisible: $isSidebarVisible)
            
            SidebarView(chatStore: chatStore, isSidebarVisible: $isSidebarVisible)
        }
    }

    private var navigationTitle: String {
        chatStore.currentChat?.messages.isEmpty ?? true ? "" : "DeepSeek"
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            SidebarToggleButton(isSidebarVisible: $isSidebarVisible)
                .withHideKeyboard()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            NewChatButton(chatStore: chatStore)
        }
    }
}

private struct SidebarToggleButton: View {
    @Binding var isSidebarVisible: Bool
    @Environment(\.hideKeyboard) private var hideKeyboard

    var body: some View {
        Button(action: {
            withAnimation {
                isSidebarVisible.toggle()
                hideKeyboard()
            }
            Haptics.shared.light()
        }) {
            Image(systemName: "bubble.left.and.bubble.right")
                .imageScale(.large)
        }
    }
}

private struct NewChatButton: View {
    var chatStore: ChatStore
    
    var body: some View {
        Button(action: {
            chatStore.createNewChat()
        }) {
            Image(systemName: "square.and.pencil")
                .imageScale(.large)
        }
    }
}

#Preview {
    HomeView()
}
