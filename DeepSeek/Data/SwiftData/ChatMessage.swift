//
//  ChatMessage.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/12.
//

import SwiftUI
import SwiftData

enum ChatMessageRole: String, CaseIterable, Codable {
    case system
    case user
    case assistant
    
    // 用于UI展示的颜色
    var color: Color {
        switch self {
        case .system:
            return .gray
        case .user:
            return .blue
        case .assistant:
            return .green
        }
    }
    
    // 用于UI展示的图标
    var icon: String {
        switch self {
        case .system:
            return "gear"
        case .user:
            return "person"
        case .assistant:
            return "bubble.right"
        }
    }
    
    // 用于消息气泡的对齐方式
    var alignment: HorizontalAlignment {
        switch self {
        case .user:
            return .trailing
        case .assistant, .system:
            return .leading
        }
    }
    
    // 用于判断是否显示头像
    var shouldShowAvatar: Bool {
        switch self {
        case .system:
            return false
        case .user, .assistant:
            return true
        }
    }
}

@Model
final class ChatMessage {
    var id: UUID
    var role: ChatMessageRole
    var content: String
    var timestamp: Date
    var chat: Chat?
    
    init(role: ChatMessageRole, content: String, chat: Chat? = nil) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = Date()
        self.chat = chat
    }
}
