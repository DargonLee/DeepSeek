//
//  PromptDetailView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/4.
//

import SwiftUI

struct PromptDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    let prompt: Prompt?
    let onSave: (Prompt) -> Void
    
    @State private var title: String
    @State private var content: String
    @State private var showDeleteConfirmation = false
    @State private var isEditing = false
    
    init(prompt: Prompt?, onSave: @escaping (Prompt) -> Void) {
        self.prompt = prompt
        self.onSave = onSave
        _title = State(initialValue: prompt?.title ?? "")
        _content = State(initialValue: prompt?.content ?? "")
        _isEditing = State(initialValue: prompt == nil)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    titleSection
                    contentSection
                    promptInfoSection
                    actionButtonsSection
                }
                .padding(.vertical)
            }
            .navigationTitle(getNavigationTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                trailingToolbarItem
            }
        }
        .presentationDetents([.large])
    }
    
    // MARK: - View Components
    private var titleSection: some View {
        SectionView(title: "标题") {
            if isEditing {
                TextField("请输入提示词标题", text: $title)
                    .textFieldStyle(.roundedBorder)
            } else {
                Text(title).font(.body)
            }
        }
    }
    
    private var contentSection: some View {
        SectionView(title: "内容") {
            if isEditing {
                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(uiColor: .systemGray6))
                    )
            } else {
                Text(content).font(.body)
            }
        }
    }
    
    private var promptInfoSection: some View {
        Group {
            if let prompt = prompt {
                VStack(spacing: 12) {
                    if prompt.isBuiltIn {
                        InfoBanner(
                            icon: "info.circle",
                            title: "内置提示词",
                            message: "这是一个内置提示词，你可以基于它创建一个新的自定义提示词"
                        )
                    } else {
                        InfoBanner(
                            icon: "calendar",
                            title: "创建时间",
                            message: prompt.createdAt.formatted(
                                .dateTime
                                    .year().month().day()
                                    .hour().minute()
                            )
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var actionButtonsSection: some View {
        Group {
            if !isEditing {
                VStack(spacing: 12) {
                    Button {
                        handleUsePrompt()
                    } label: {
                        Text("使用此提示词")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var trailingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if prompt?.isBuiltIn == false {
                if isEditing {
                    Button("保存") {
                        handleSavePrompt()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                } else {
                    Button("编辑") {
                        isEditing = true
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func getNavigationTitle() -> String {
        if prompt == nil {
            return "新建提示词"
        } else if isEditing {
            return "编辑提示词"
        } else {
            return "提示词详情"
        }
    }
    
    private func handleUsePrompt() {
        let promptToUse = Prompt(
            title: title,
            content: content,
            isBuiltIn: false
        )
        onSave(promptToUse)
        dismiss()
    }
    
    private func handleSavePrompt() {
        let newPrompt = Prompt(
            title: title,
            content: content,
            isBuiltIn: false
        )
        onSave(newPrompt)
        if prompt == nil {
            dismiss()
        } else {
            isEditing = false
        }
    }
}

// MARK: - SectionView
private struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            content
        }
        .padding(.horizontal)
    }
}

// MARK: - InfoBanner
private struct InfoBanner: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(10)
    }
}


#Preview("提示词详情") {
    PromptDetailView(
        prompt: Prompt(
            title: "AI助手",
            content: "你是一个智能助手",
            isBuiltIn: true
        )
    ) { _ in }
}
