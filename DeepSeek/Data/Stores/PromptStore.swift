//
//  PromptStore.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/6.
//

import Foundation
import SwiftData

@MainActor
final class PromptStore {
    // MARK: - Properties
    private let modelContext: ModelContext
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - CRUD Operations
    /// 创建新的提示词
    func createPrompt(title: String, content: String, isBuiltIn: Bool = false) throws {
        let prompt = Prompts(title: title, content: content, isBuiltIn: isBuiltIn)
        modelContext.insert(prompt)
        try modelContext.save()
    }
    
    /// 获取所有提示词
    func fetchPrompts() throws -> [Prompts] {
        let descriptor = FetchDescriptor<Prompts>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// 获取提示词
    func fetchPrompt(content: String) throws -> Prompts? {
        let descriptor = FetchDescriptor<Prompts>(
            predicate: #Predicate<Prompts> { prompt in
                prompt.content == content
            }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    /// 更新提示词
    func updatePrompt(_ prompt: Prompts) throws {
        try modelContext.save()
    }
    
    /// 删除提示词
    func deletePrompt(_ prompt: Prompts) throws {
        modelContext.delete(prompt)
        try modelContext.save()
    }
    
    /// 删除所有自定义提示词
    func deleteAllCustomPrompts() throws {
        let descriptor = FetchDescriptor<Prompts>(
            predicate: #Predicate<Prompts> { prompt in
                !prompt.isBuiltIn
            }
        )
        let prompts = try modelContext.fetch(descriptor)
        prompts.forEach { modelContext.delete($0) }
        try modelContext.save()
    }
}
