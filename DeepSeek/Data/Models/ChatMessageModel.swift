//
//  ChatMessageModel.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/2.
//

import Foundation

struct ChatMessageModel: Codable {
    let role: String
    let content: String
    
    init(from messageModel: ChatMessage) {
        self.role = messageModel.role.rawValue
        self.content = messageModel.content
    }
}
