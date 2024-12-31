//
//  BlurredBackgroundView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/1.
//

import SwiftUI

struct BlurredBackgroundView: View {
    @Binding var isVisible: Bool
    var opacity: CGFloat = 0.6
    var blurRadius: CGFloat = 5
    var tapAction: (() -> Void)? = nil

    var body: some View {
        Color.black
            .opacity(isVisible ? opacity : 0.0)
            .blur(radius: isVisible ? blurRadius : 0)
            .animation(.easeInOut, value: isVisible)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    isVisible = false
                }
                tapAction?()
            }
    }
}

#Preview {
    BlurredBackgroundView(isVisible: .constant(true))
}
