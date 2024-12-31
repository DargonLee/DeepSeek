import Foundation

/// Prompt 管理器，负责管理所有提示词
@Observable final class PromptManager {
    /// 单例实例
    static let shared = PromptManager()
    
    /// 当前选中的系统提示词
    private(set) var currentSystemPrompt: String?
    
    /// 自定义提示词列表
    private(set) var customPrompts: [Prompt] = []
    
    /// 默认的系统提示词
    static let defaultPrompt = "你是一个有用的AI助手。"
    
    private init() {
        loadCustomPrompts()
    }
    
    /// 获取内置提示词列表
    /// - Returns: 内置提示词数组
    func builtInPrompts() -> [Prompt] {
        return [
            Prompt(title: "AI助手", content: Self.defaultPrompt, isBuiltIn: true),
            Prompt(title: "代码助手", content: "你是一个专业的编程助手，精通各种编程语言和框架。请帮助我解决编程问题，提供代码示例和最佳实践建议。", isBuiltIn: true),
            Prompt(title: "翻译助手", content: "你是一个专业的翻译助手，精通多国语言。请帮助我准确翻译内容，并解释相关的文化背景和用语差异。", isBuiltIn: true),
            Prompt(title: "写作助手", content: "你是一个专业的写作助手。请帮助我改进文章的结构、措辞和表达，使其更加清晰、生动和专业。", isBuiltIn: true)
        ]
    }
    
    /// 设置当前使用的提示词
    /// - Parameter prompt: 要设置的提示词
    func setCurrentPrompt(_ prompt: Prompt) {
        currentSystemPrompt = prompt.content
    }
    
    /// 添加自定义提示词
    /// - Parameter prompt: 要添加的提示词
    func addCustomPrompt(_ prompt: Prompt) {
        customPrompts.append(prompt)
        saveCustomPrompts()
    }
    
    /// 删除自定义提示词
    /// - Parameter prompt: 要删除的提示词
    func deleteCustomPrompt(_ prompt: Prompt) {
        customPrompts.removeAll { $0.id == prompt.id }
        saveCustomPrompts()
    }
    
    // MARK: - Private Methods
    
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