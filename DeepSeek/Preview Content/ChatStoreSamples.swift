//
//  ChatStoreSamples.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/13.
//

import Foundation

extension ChatStore {
    static var preview: ChatStore {
        let container = AppContainer.shared
        
        // 添加示例数据
        let context = container.chatStore.modelContext
        for chat in Chat.sampleChats {
            context.insert(chat)
        }
        try? context.save()
        
        return container.chatStore
    }
}
