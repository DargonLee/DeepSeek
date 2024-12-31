//
//  ChooseStyles.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/2.
//

import Foundation

/// 系统提示词管理类
final class SystemPromptManager {
    /// 单例实例
    static let shared = SystemPromptManager()
    
    /// 当前使用的提示词
    @UserDefault(key: "currentPrompt", defaultValue: SystemPromptManager.defaultPrompt)
    private var currentPrompt: String
    
    /// 所有可用的系统提示词
    @UserDefault(key: "systemPrompts", defaultValue: SystemPromptManager.defaultPrompts)
    private var prompts: [String]
    
    /// 默认提示词
    private static let defaultPrompt = "You are a helpful assistant."
    
    /// 默认提示词列表
    private static let defaultPrompts = [
        defaultPrompt,
        "You are a professional programmer who can help solve coding problems.",
        "You are a creative writer who can help with content creation.",
        "You are an expert in data analysis and can help interpret data."
    ]
    
    private init() {}
    
    /// 设置当前使用的提示词
    /// - Parameter prompt: 要设置的提示词
    func setCurrentPrompt(_ prompt: String) {
        currentPrompt = prompt
    }
    
    /// 获取当前使用的提示词
    /// - Returns: 当前使用的提示词
    func getCurrentPrompt() -> String {
        return currentPrompt
    }

    static func getCurrentPrompt() -> String {
        return shared.getCurrentPrompt()
    }
    
    /// 获取所有可用的提示词
    /// - Returns: 所有提示词数组
    func getAllPrompts() -> [String] {
        return prompts
    }
    
    /// 添加新的提示词
    /// - Parameter prompt: 要添加的提示词
    func addPrompt(_ prompt: String) {
        guard !prompts.contains(prompt) else { return }
        prompts.append(prompt)
    }
    
    /// 删除指定提示词
    /// - Parameter prompt: 要删除的提示词
    func removePrompt(_ prompt: String) {
        guard prompt != Self.defaultPrompt else { return }
        prompts.removeAll { $0 == prompt }
    }
}

/// UserDefaults属性包装器
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
