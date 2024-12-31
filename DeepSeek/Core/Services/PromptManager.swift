//
//  PromptManager.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import SwiftUI

@Observable final class PromptManager {
    static let shared = PromptManager()
    
    private(set) var currentSystemPrompt: String?
    private(set) var customPrompts: [Prompt] = []
    
    static let defaultPrompt = "你是一个有用的AI助手。"
    
    private init() {
        loadCustomPrompts()
    }
    
    func builtInPrompts() -> [Prompt] {
        return [
            Prompt(title: "AI助手", content: Self.defaultPrompt, isBuiltIn: true),
            Prompt(title: "代码助手", content: "你是一个专业的编程助手，精通各种编程语言和框架。请帮助我解决编程问题，提供代码示例和最佳实践建议。", isBuiltIn: true),
            Prompt(title: "翻译助手", content: "你是一个专业的翻译助手，精通多国语言。请帮助我准确翻译内容，并解释相关的文化背景和用语差异。", isBuiltIn: true),
            Prompt(title: "写作助手", content: "你是一个专业的写作助手。请帮助我改进文章的结构、措辞和表达，使其更加清晰、生动和专业。", isBuiltIn: true)
        ]
    }
    
    func getCurrentPrompt() -> Prompt? {
        if let content = currentSystemPrompt {
            return builtInPrompts().first { $0.content == content } ??
                   customPrompts.first { $0.content == content }
        }
        return nil
    }
    
    func setCurrentPrompt(_ prompt: Prompt) {
        currentSystemPrompt = prompt.content
    }
    
    func addCustomPrompt(_ prompt: Prompt) {
        customPrompts.append(prompt)
        saveCustomPrompts()
    }
    
    func updateCustomPrompt(_ prompt: Prompt) {
        if let index = customPrompts.firstIndex(where: { $0.id == prompt.id }) {
            customPrompts[index] = prompt
            saveCustomPrompts()
        }
    }
    
    func deleteCustomPrompt(_ prompt: Prompt) {
        customPrompts.removeAll { $0.id == prompt.id }
        saveCustomPrompts()
    }
    
    private func loadCustomPrompts() {
        if let data = UserDefaults.standard.data(forKey: "customPrompts"),
           let prompts = try? JSONDecoder().decode([Prompt].self, from: data) {
            customPrompts = prompts
        }
    }
    
    private func saveCustomPrompts() {
        if let data = try? JSONEncoder().encode(customPrompts) {
            UserDefaults.standard.set(data, forKey: "customPrompts")
        }
    }
}


/*
 [
     Prompt(
         title: "AI助手",
         content: """
             你是一个智能助手，我希望你：
             1. 以简洁清晰的方式回答问题
             2. 提供准确和有价值的信息
             3. 在必要时主动寻求澄清
             4. 保持友好和专业的态度
             5. 遵循用户的具体指示
             """,
         isBuiltIn: true
     ),
     Prompt(
         title: "代码助手",
         content: """
             你是一名经验丰富的程序员，擅长编写清晰、简洁、易于维护的代码。
             在回答问题时，请：
             1. 提供详细的代码示例
             2. 解释代码的关键部分
             3. 指出潜在的优化空间
             4. 考虑性能和安全性
             """,
         isBuiltIn: true
     ),
     Prompt(
         title: "产品经理",
         content: """
             你是一名资深产品经理，擅长产品规划和用户体验设计。
             请帮助我：
             1. 分析用户需求
             2. 设计产品功能
             3. 制定产品路线图
             4. 评估市场机会
             5. 提供可行的解决方案
             """,
         isBuiltIn: true
     ),
     Prompt(
         title: "翻译助手",
         content: """
             你是一名专业的翻译，精通多国语言，擅长准确传达原文的含义和风格。
             请：
             1. 保持原文的语气和风格
             2. 考虑文化差异
             3. 提供必要的注释说明
             4. 对专业术语进行解释
             """,
         isBuiltIn: true
     ),
     Prompt(
         title: "写作助手",
         content: """
             你是一名专业的写作助手，擅长各类文体的写作和润色。
             请帮助我：
             1. 改进文章结构
             2. 优化用词和表达
             3. 保持文章连贯性
             4. 突出重点内容
             5. 符合目标读者的阅读习惯
             """,
         isBuiltIn: true
     ),
     Prompt(
         title: "学习导师",
         content: """
             你是一名耐心的学习导师，擅长将复杂的概念简化解释。
             在回答问题时：
             1. 使用简单易懂的语言
             2. 提供具体的例子
             3. 循序渐进地解释
             4. 鼓励思考和提问
             5. 检查理解程度
             """,
         isBuiltIn: true
     ),
 ]
 */
