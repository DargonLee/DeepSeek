//
//  ChatSamples.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/13.
//

import Foundation

extension Chat {
    static let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
    static let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!
    static let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
    
    static var sampleChats: [Chat] {
        let chat1 = Chat(title: "SwiftUI 学习", startTime: lastDay)
        chat1.addMessage(.user, "你好,我想了解一下 SwiftUI 的基础知识")
        chat1.addMessage(.assistant, """
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
            """)
        
        let chat2 = Chat(title: "iOS开发讨论", startTime: lastWeek)
        chat2.addMessage(.user, "Swift和Objective-C有什么主要区别?")
        chat2.addMessage(.assistant, """
            Swift和Objective-C的主要区别包括:
            
            1. 语法现代化:
               - Swift更简洁、易读
               - 支持函数式编程
               - 类型推断
            
            2. 安全性:
               - 更严格的类型检查
               - 可选类型处理
               - 更好的内存管理
            
            3. 性能:
               - Swift通常性能更好
               - 编译优化更强
            
            需要我详细解释某个方面吗?
            """)
        
        let chat3 = Chat(title: "项目架构探讨", startTime: lastMonth)
        chat3.addMessage(.user, "在iOS项目中如何实现MVVM架构?")
        chat3.addMessage(.assistant, """
            在iOS项目中实现MVVM架构的关键点:
            
            1. 职责划分:
               - Model: 数据模型
               - View: UI展示
               - ViewModel: 业务逻辑
            
            2. 数据绑定:
               ```swift
               class ViewModel: ObservableObject {
                   @Published var data: String = ""
                   
                   func updateData() {
                       // 处理业务逻辑
                   }
               }
               ```
            
            3. 依赖注入
            4. 单向数据流
            
            需要具体的示例代码吗?
            """)
        
        return [chat1, chat2, chat3]
    }
}
