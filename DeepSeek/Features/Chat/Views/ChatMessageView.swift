//
//  ChatMessageView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/2.
//

import SwiftUI
import MarkdownUI
import Splash

struct ChatMessageView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let message: ChatMessage
    
    private var codeHighlightColorScheme: Splash.Theme {
        switch colorScheme {
        case .dark:
            return .wwdc17(withFont: .init(size: 16))
        default:
            return .sunset(withFont: .init(size: 16))
        }
    }
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                userMessageView
            } else {
                assistantMessageView
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    // MARK: - View Components
    
    /// 用户消息视图
    private var userMessageView: some View {
        Text(message.content)
            .font(.system(size: 14))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.1))
            )
            .foregroundColor(.primary)
    }
    
    /// AI助手消息视图
    private var assistantMessageView: some View {
        Markdown(message.content)
            .markdownCodeSyntaxHighlighter(.splash(theme: codeHighlightColorScheme))
            .markdownTheme(MarkdownColours.enchantedTheme)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
            .foregroundColor(.primary)
    }
}

#Preview {
    VStack {
        // 用户消息示例
        ChatMessageView(message: ChatMessage(
            role: .user,
            content: "你好,我想了解一下 SwiftUI 的基础知识"
        ))
        
        // AI助手回复示例
        ChatMessageView(message: ChatMessage(
            role: .assistant,
            content: """
            我很乐意为您介绍 SwiftUI 的基础知识!
            
            SwiftUI 是苹果推出的声明式UI框架,主要特点包括:
            
            1. 声明式语法
            2. 数据驱动
            3. 跨平台支持
            
            来看一个简单的代码示例:
            
            ```swift
            struct ContentView: View {
                var body: some View {
                    Text("Hello, SwiftUI!")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
            }
            ```
            
            您想从哪个方面开始了解呢?
            """
        ))
    }
}
