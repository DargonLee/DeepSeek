//
//  SamplePrompts.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import Foundation

struct SamplePrompts: Identifiable, Hashable {
    enum SamplePromptType {
        case question
        case action
        
        var icon: String {
            switch self {
            case .question:
                return "questionmark.circle"
            case .action:
                return "lightbulb.circle"
            }
        }
    }
    
    var prompt: String
    var type: SamplePromptType
    
    var id: String {
        prompt
    }
}

// MARK: - Sample Data
extension SamplePrompts {
    static let samples: [SamplePrompts] = [
        .init(prompt: "你好", type: .action),
        .init(prompt: "教我一些新语言的常用短语", type: .action),
        .init(prompt: "扮演《丛林之书》中的毛克利来回答问题", type: .action),
        .init(prompt: "如何在HTML中让div居中？", type: .question),
        .init(prompt: "Go编程语言有什么独特之处？", type: .question),
        .init(prompt: "给我10个送给好朋友的礼物建议", type: .action),
        .init(prompt: "帮我写一条邀请朋友参加婚礼的短信", type: .action),
        .init(prompt: "用五岁小孩能理解的方式解释超级计算机", type: .action),
        .init(prompt: "如何在中国申报个人所得税？", type: .question),
        .init(prompt: "请列出中国人口最多的城市，用表格展示", type: .question),
        .init(prompt: "给我一些新年计划的建议", type: .action),
        .init(prompt: "什么是冒泡排序？用Python写个示例", type: .question)
    ]
    
    static var shuffled: [SamplePrompts] {
        return samples.shuffled()
    }
}
