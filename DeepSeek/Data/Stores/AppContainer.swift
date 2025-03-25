//
//  AppContainer.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import Foundation
import SwiftData

/// AppContainer 是应用程序的主容器类，负责管理和提供对各种服务和存储的访问
/// 使用单例模式确保整个应用程序中只有一个实例
@MainActor
final class AppContainer {
    // MARK: - Shared Instance
    /// 共享的单例实例
    static let shared: AppContainer = AppContainer()
    
    // MARK: - Properties
    let modelContainer: ModelContainer
    /// 聊天数据存储管理器
    let chatStore: ChatStore
//    let promptsStore: PromptStore

    
    // MARK: - Private Properties
    /// 数据模型上下文
    let modelContext: ModelContext
    
    // MARK: - Initialization
    private init() {
        do {
            let modelConfiguration = ModelConfiguration(
                isStoredInMemoryOnly: false,
                allowsSave: true
            )

            // 创建数据模型容器
            modelContainer = try ModelContainer(
                for: Chat.self, ChatMessage.self,
                configurations: modelConfiguration
            )
            
            // 初始化模型上下文
            self.modelContext = modelContainer.mainContext
            
            // 初始化聊天存储
            self.chatStore = ChatStore(modelContext: modelContext)

            // 初始化提示词存储
//            self.promptsStore = PromptStore(modelContext: modelContext)

            
        } catch {
            fatalError("Failed to create model container: \(error.localizedDescription)")
        }
    }
}
