//
//  Prompts.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/6.
//

import Foundation
import SwiftData

@Model
final class Prompts {
    // MARK: - Properties
    /// 提示词标题
    var title: String
    /// 提示词内容
    var content: String
    /// 是否为内置提示词
    var isBuiltIn: Bool
    /// 创建时间
    var createdAt: Date
    /// 是否被选中
    var isSelected: Bool
    
    // MARK: - Initialization
    init(
        title: String,
        content: String,
        isBuiltIn: Bool = false,
        createdAt: Date = .now,
        isSelected: Bool = false
    ) {
        self.title = title
        self.content = content
        self.isBuiltIn = isBuiltIn
        self.createdAt = createdAt
        self.isSelected = isSelected
    }
}

// MARK: - Models
struct Prompt: Identifiable, Codable {
    let id: UUID
    let title: String
    let content: String
    let isBuiltIn: Bool
    let createdAt: Date
    let isSelected: Bool
    
    init(id: UUID = UUID(), title: String, content: String, isBuiltIn: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.isBuiltIn = isBuiltIn
        self.createdAt = Date()
        self.isSelected = false
    }
}

