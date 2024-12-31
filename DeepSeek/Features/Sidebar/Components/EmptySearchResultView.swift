//
//  EmptySearchResultView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import SwiftUI

// MARK: - Empty State Views
struct EmptySearchResultView: View {
    var body: some View {
        ContentUnavailableView {
            Label {
                Text("没有找到相关聊天记录")
                    .font(.title2)
                    .fontWeight(.medium)
            } icon: {
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        } description: {
            Text("尝试使用其他关键词搜索")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct EmptyChatListView: View {
    var body: some View {
        ContentUnavailableView {
            VStack(spacing: 12) {
                if #available(iOS 18.0, *) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 50))
                        .symbolEffect(.bounce)
                        .foregroundStyle(.blue.gradient)
                } else {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 50))
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5).repeatForever(), value: UUID())
                        .foregroundStyle(.blue.gradient)
                }
                
                Text("暂无聊天记录")
                    .font(.title2)
                    .fontWeight(.medium)
            }
        } description: {
            Text("开始新的对话吧")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
