//
//  ChatStore.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import SwiftData
import SwiftUI

@MainActor
@Observable final class ChatStore {
    // MARK: - Properties
    private(set) var modelContext: ModelContext
    private(set) var currentChat: Chat?
    private(set) var balance: BalanceResponse?
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    private(set) var isResponding: Bool = false
    let deepSeekService: DeepSeekService
    
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.deepSeekService = DeepSeekService.shared
    }
    
    // MARK: - Public Methods
    /// 检查当前账户的余额信息
    /// - Returns: 返回一个异步操作，可能会抛出错误
    /// - Throws: 如果API请求失败，将抛出网络相关错误
    func checkBalance() async throws {
        self.balance = try await deepSeekService.checkBalance()
    }
    
    /// 创建一个新的聊天会话
    /// - Note: 新创建的会话会自动被设置为当前会话
    func createNewChat() {
        let chat = Chat()
        modelContext.insert(chat)
        currentChat = chat
        saveContext()
    }
    
    /// 删除指定的聊天会话
    /// - Parameter chat: 要删除的聊天会话
    func deleteChat(chat: Chat) {
        modelContext.delete(chat)
        if currentChat?.id == chat.id {
            currentChat = nil
        }
        saveContext()
    }
    
    /// 切换到指定的聊天会话
    /// - Parameter chat: 要切换到的聊天会话
    func switchChat(chat: Chat) {
        currentChat = chat
    }
    
    /// 发送消息到当前聊天会话
    /// - Parameter content: 要发送的消息内容
    /// - Throws: 如果消息发送失败，将抛出相关错误
    /// - Note: 如果当前没有活动的聊天会话，将自动创建一个新的会话
    func sendMessage(_ content: String) async throws {
        guard !content.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard let chat = currentChat else {
            createNewChat()
            return
        }
        
        isLoading = true
        isResponding = true
        defer { isLoading = false }
        
        let userMessage = await handleUserMessage(content, in: chat)
        let messages = await prepareMessages(userMessage: userMessage, in: chat)
        try await sendAndHandleResponse(messages: messages, in: chat)
    }

    /// 取消当前的流式响应
    func cancelStreaming() {
        isResponding = false
    }
    
    /// 获取所有聊天会话列表
    /// - Returns: 按更新时间倒序排列的聊天会话数组
    /// - Throws: 如果获取失败，将抛出数据库相关错误
    func fetchChats() throws -> [Chat] {
        let descriptor = FetchDescriptor<Chat>(
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// 删除所有聊天数据
    func deleteAllData() async throws {
        let chats = try modelContext.fetch(FetchDescriptor<Chat>())
        chats.forEach { modelContext.delete($0) }
        currentChat = nil
        saveContext()
    }
    
    // MARK: - Private Message Handling Methods
    private func handleUserMessage(_ content: String, in chat: Chat) async -> ChatMessage {
        let userMessage = ChatMessage(role: .user, content: content, chat: chat)        
        if chat.title == "New Chat" {
            chat.title = String(content.prefix(20))
        }
        chat.startTime = Date()
        
        return userMessage
    }
    
    private func prepareMessages(userMessage: ChatMessage, in chat: Chat) async -> [ChatMessage] {
        let systemPrompt = getSystemPrompt(for: chat)
        var messages = [
            ChatMessage(role: .system, content: systemPrompt)
        ]
        
        let historyMessages = await getRelevantHistoryMessages(
            systemPrompt: systemPrompt,
            userMessage: userMessage,
            in: chat
        )
        messages.append(contentsOf: historyMessages.isEmpty ? [userMessage] : historyMessages)
        return messages
    }
    
    // MARK: - Private Helper Methods
    private func getSystemPrompt(for chat: Chat) -> String {
        if let currentPrompt = PromptManager.shared.currentSystemPrompt {
            return currentPrompt
        }
        return PromptManager.defaultPrompt
    }
    
    private func getRelevantHistoryMessages(
        systemPrompt: String,
        userMessage: ChatMessage,
        in chat: Chat
    ) async -> [ChatMessage] {
        let nonSystemMessages = chat.messages.filter { $0.role != .system }
        let defaultHistoryLimit = DeepSeekServiceConfiguration.historyMessageCount
        let userHistoryLimit = UserDefaults.standard.integer(forKey: "deepseek_historyMessageCount") 
        let effectiveHistoryLimit = userHistoryLimit > 0 ? userHistoryLimit : defaultHistoryLimit
        let recentHistoryMessages = Array(nonSystemMessages.prefix(effectiveHistoryLimit))
        return recentHistoryMessages
    }
    
    private func sendAndHandleResponse(messages: [ChatMessage], in chat: Chat) async throws {
        let assistantMessage = ChatMessage(
            role: .assistant,
            content: "",
            chat: chat
        )
        
        modelContext.insert(assistantMessage)
        
        do {
            let parameters = ChatParameters(messages: messages)
            try await handleStreamResponse(
                parameters: parameters,
                assistantMessage: assistantMessage,
                in: chat
            )
        } catch {
            modelContext.delete(assistantMessage)
            errorMessage = error.localizedDescription
            saveContext()
            throw error
        }
    }
    
    private func handleStreamResponse(
        parameters: ChatParameters,
        assistantMessage: ChatMessage,
        in chat: Chat
    ) async throws {
        for try await chunk in deepSeekService.stream(parameters: parameters) {
            guard isResponding else {
                modelContext.delete(assistantMessage)
                return
            }

            if let delta = chunk.choices.first?.delta {
                assistantMessage.content += delta.content ?? ""
                assistantMessage.timestamp = Date()
                chat.startTime = Date()
                saveContext()
            }
        }
        isResponding = false
    }
    
    private func handleError(_ error: Error, assistantMessage: ChatMessage, in chat: Chat) async {
        if let index = chat.messages.firstIndex(where: { $0.id == assistantMessage.id }) {
            chat.messages.remove(at: index)
        }
        errorMessage = error.localizedDescription
        saveContext()
    }
    
    private func saveContext() {
        try? modelContext.save()
    }
}
