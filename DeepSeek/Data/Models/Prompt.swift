import Foundation

/// Prompt 模型，用于存储提示词信息
struct Prompt: Identifiable, Codable {
    /// 唯一标识符
    let id: UUID
    /// 提示词标题
    let title: String
    /// 提示词内容
    let content: String
    /// 是否为内置提示词
    let isBuiltIn: Bool
    /// 创建时间
    let createdAt: Date
    
    init(id: UUID = UUID(), title: String, content: String, isBuiltIn: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.isBuiltIn = isBuiltIn
        self.createdAt = Date()
    }
} 