//
//  Chat.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import Foundation
import SwiftData

@Model
final class Chat {
    var id: UUID
    var title: String
    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.chat)
    var messages: [ChatMessage] = []
    var startTime: Date
    
    var sortedMessages: [ChatMessage] {
        messages.sorted { $0.timestamp < $1.timestamp }
    }
    
    init(
        title: String = "New Chat",
        startTime: Date = Date()
    ) {
        self.id = UUID()
        self.title = title
        self.startTime = startTime
    }
}

extension Chat {
    /// 添加消息的方法
    func addMessage(_ role: ChatMessageRole, _ content: String) {
        let message = ChatMessage(role: role, content: content, chat: self)
        messages.append(message)
        message.chat = self
    }

    /// 获取当前Chat的所有messages的Count
    func totalMessagesCount(modelContext: ModelContext) -> Int {
        self.messages.count
    }
    
    /// 获取最近的 n 条消息
    func recentMessages(_ count: Int = 10) -> [ChatMessage] {
        sortedMessages.prefix(count).reversed()
    }
}
