//
//  BottomBarView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import SwiftUI

// MARK: - Bottom Bar View
struct BottomBarView: View {
    // MARK: - Properties
    let chatStore: ChatStore
    let iconWidth: CGFloat
    
    @State private var isSettingViewPresented: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                settingsButton
                Spacer()
                balanceView
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(UIColor.systemBackground))
        .overlay(separatorLine, alignment: .top)
    }
    
    // MARK: - Subviews
    private var settingsButton: some View {
        Button {
            isSettingViewPresented = true
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .scaledToFit()
                .frame(width: iconWidth, height: iconWidth)
        }
        .sheet(isPresented: $isSettingViewPresented) {
            SettingView(chatStore: chatStore)
        }
    }
    
    private var balanceView: some View {
        HStack(spacing: 4) {
            Image(systemName: "dollarsign.circle.fill")
                .foregroundColor(.green)
            Text("\(chatStore.balance?.balanceInfos.first?.totalBalance ?? "0.00")")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
        .onTapGesture {
            Task {
                try? await chatStore.checkBalance()
            }
        }
        .onAppear {
            Task {
                try? await chatStore.checkBalance()
            }
        }
    }
    
    private var separatorLine: some View {
        Rectangle()
            .frame(height: 0.5)
            .foregroundColor(Color(UIColor.separator))
            .opacity(0.5)
    }
}
