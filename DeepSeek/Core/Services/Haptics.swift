//
//  Haptics.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import UIKit 

class Haptics {
    // 单例模式
    static let shared = Haptics()
    
    private init() {}
    
    // 轻度触感反馈
    func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    // 中度触感反馈
    func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare() 
        generator.impactOccurred()
    }
    
    // 重度触感反馈
    func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    // 成功触感反馈
    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    // 警告触感反馈
    func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
    
    // 错误触感反馈
    func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}

// MARK: - 使用示例
/*
 
 // 在主线程中使用
 Haptics.shared.light() // 轻度触感
 Haptics.shared.success() // 成功触感
 
 // 在后台线程中使用需要切换到主线程
 DispatchQueue.main.async {
     Haptics.shared.error() // 错误触感
 }
 
 // 在 SwiftUI 视图中使用
 Button("点击") {
     Haptics.shared.medium() // 中度触感
 }
 
 // 在异步任务中使用
 Task { @MainActor in
     Haptics.shared.warning() // 警告触感
 }
 
 注意:
 1. 触感反馈必须在主线程中调用
 2. 如果在后台线程调用,需要切换到主线程
 3. 建议在用户交互操作时使用,如按钮点击、手势等
 4. 不同触感类型根据场景选择使用:
    - light/medium/heavy: 用于普通交互反馈
    - success: 用于操作成功提示
    - warning: 用于警告提示
    - error: 用于错误提示
*/

