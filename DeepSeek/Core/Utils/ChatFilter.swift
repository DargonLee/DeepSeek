//
//  ChatFilter.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import Foundation

enum ChatFilter {
    static func filterChats(_ chats: [Chat], searchText: String) -> [Chat] {
        guard !searchText.isEmpty else { return chats }
        
        return chats.filter { chat in
            chat.title.localizedCaseInsensitiveContains(searchText) ||
            chat.messages.contains { message in
                message.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
