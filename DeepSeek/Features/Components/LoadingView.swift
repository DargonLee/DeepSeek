//
//  LoadingBubbleView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/2.
//

import SwiftUI

struct StreamingLoadingView: View {
    @State private var dots = ""
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 4) {
            // AI头像或图标
            Image(systemName: "brain")
                .foregroundColor(.blue)
                .imageScale(.medium)
            
            // 思考中的动画点
            Text("思考中\(dots)")
                .foregroundColor(.secondary)
                .font(.system(.subheadline))
                .onReceive(timer) { _ in
                    if dots.count >= 3 {
                        dots = ""
                    } else {
                        dots += "."
                    }
                }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}
/*
使用方法：
  if chatStore.isLoading {
      HStack {
          LoadingBubbleView()
              .padding(.horizontal)
          Spacer()
      }
  }
*/
struct LoadingBubbleView: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingBubbleView()
}
