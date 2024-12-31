//
//  PromptChooseView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import SwiftUI
import Foundation

// MARK: - Views
/// 提示词选择视图
struct PromptChooseView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    private let promptManager = PromptManager.shared
    @State private var searchText = ""
    @State private var selectedPrompt: Prompt?

    let onPromptSelected: (Prompt) -> Void

    // MARK: - Computed Properties
    private var currentPrompt: Prompt? {
        promptManager.getCurrentPrompt()
    }

    private var filteredBuiltInPrompts: [Prompt] {
        let prompts = promptManager.builtInPrompts()
        guard !searchText.isEmpty else { return prompts }
        return prompts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    private var filteredCustomPrompts: [Prompt] {
        guard !searchText.isEmpty else { return promptManager.customPrompts }
        return promptManager.customPrompts.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var hasSearchResults: Bool {
        !searchText.isEmpty && filteredBuiltInPrompts.isEmpty && filteredCustomPrompts.isEmpty
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            promptListView
                .navigationTitle("选择提示词")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer,
                    prompt: "搜索提示词"
                )
                .toolbar {
                    toolbarContent
                }
        }
    }

    // MARK: - View Components
    private var promptListView: some View {
        List {
            if hasSearchResults {
                ContentUnavailableView("没有找到相关提示词", systemImage: "magnifyingglass")
            } else {
                promptSections
            }
        }
    }

    private var promptSections: some View {
        Group {
            if !filteredBuiltInPrompts.isEmpty {
                PromptSection(
                    title: "内置提示词",
                    prompts: filteredBuiltInPrompts,
                    onPromptTap: handlePromptTap
                )
            }

            if !filteredCustomPrompts.isEmpty {
                PromptSection(
                    title: "自定义提示词",
                    prompts: filteredCustomPrompts,
                    onPromptTap: handlePromptTap
                )
            }
        }
    }

    private var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("取消", role: .cancel) {
                    dismiss()
                }
            }
        }
    }

    // MARK: - Methods
    private func handlePromptTap(_ prompt: Prompt) {
        promptManager.setCurrentPrompt(prompt)
        onPromptSelected(prompt)
        dismiss()
    }
}

// MARK: - PromptSection
private struct PromptSection: View {
    let title: String
    let prompts: [Prompt]
    let onPromptTap: (Prompt) -> Void
    private let promptManager = PromptManager.shared
    @State private var showDeleteAlert = false
    @State private var promptToDelete: Prompt?

    private var currentPrompt: Prompt? {
        promptManager.getCurrentPrompt()
    }

    var body: some View {
        Section(title) {
            ForEach(prompts) { prompt in
                PromptRowView(prompt: prompt, isSelected: prompt.id == currentPrompt?.id)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onPromptTap(prompt)
                    }
                    .modifier(PromptSwipeActions(
                        prompt: prompt,
                        showDeleteAlert: $showDeleteAlert,
                        promptToDelete: $promptToDelete,
                        promptManager: promptManager
                    ))
            }
        }
        .alert("确认删除", isPresented: $showDeleteAlert, presenting: promptToDelete) { prompt in
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                promptManager.deleteCustomPrompt(prompt)
            }
        } message: { prompt in
            Text("确定要删除\"\(prompt.title)\"提示词吗？此操作无法撤销。")
        }
    }
}

// MARK: - PromptRowView
private struct PromptRowView: View {
    let prompt: Prompt
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            // 选中状态指示器
            Circle()
                .fill(isSelected ? Color.blue : Color.clear)
                .frame(width: 8, height: 8)
                .overlay(
                    Circle()
                        .strokeBorder(
                            isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )

            // 提示词内容
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(prompt.title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    if prompt.isBuiltIn {
                        Text("内置")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    Spacer()
                }

                Text(prompt.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .padding(.vertical, 6)
    }
}

// MARK: - PromptSwipeActions
private struct PromptSwipeActions: ViewModifier {
    let prompt: Prompt
    @Binding var showDeleteAlert: Bool
    @Binding var promptToDelete: Prompt?
    let promptManager: PromptManager

    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                // 删除按钮（仅对自定义提示词显示）
                if !prompt.isBuiltIn {
                    Button(role: .destructive) {
                        promptToDelete = prompt
                        showDeleteAlert = true
                    } label: {
                        Label("删除", systemImage: "trash")
                    }
                    
                    // 编辑按钮
                    NavigationLink {
                        PromptDetailView(
                            prompt: prompt,
                            onSave: { updatedPrompt in
                                if prompt.isBuiltIn {
                                    // 如果是内置提示词，创建新的自定义提示词
                                    promptManager.addCustomPrompt(updatedPrompt)
                                } else {
                                    // 如果是自定义提示词，更新现有提示词
                                    promptManager.updateCustomPrompt(updatedPrompt)
                                }
                            }
                        )
                    } label: {
                        Label("查看", systemImage: "eye")
                    }
                    .tint(.blue)
                }
            }
    }
}

// MARK: - PromptButtonView
struct PromptButtonView: View {
    // MARK: - Properties
    @Binding var currentPrompt: String
    @State private var showPromptChooseView = false
    @State private var selectedPromptIndex: Int?

    // MARK: - Computed Properties
    private var buttonImage: some View {
        Group {
            if let index = selectedPromptIndex {
                Text("\(index + 1)")
                    .font(.system(size: 12, weight: .medium))
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Circle())
            } else {
                Image(systemName: "text.bubble")
                    .foregroundColor(.blue)
            }
        }
    }

    // MARK: - Body
    var body: some View {
        Button {
            showPromptChooseView = true
        } label: {
            buttonImage
                .padding(.trailing, 8)
        }
        .sheet(isPresented: $showPromptChooseView) {
            PromptChooseView { prompt in
                currentPrompt = prompt.title
                selectedPromptIndex = PromptManager.shared.builtInPrompts().firstIndex {
                    $0.id == prompt.id
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("提示词选择") {
    PromptChooseView { prompt in
        print("Selected prompt: \(prompt.title)")
    }
}

#Preview("提示词按钮") {
    PromptButtonView(currentPrompt: .constant("AI助手"))
        .padding()
}
