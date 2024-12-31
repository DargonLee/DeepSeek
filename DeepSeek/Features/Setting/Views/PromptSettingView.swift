//
//  ThemeSettingView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import SwiftUI

// MARK: - Prompt设置视图
struct PromptSettingView: View {
    // MARK: - Properties
    @State private var promptManager = PromptManager.shared
    @State private var isAddingPrompt = false
    
    // MARK: - View
    var body: some View {
        List {
            builtInPromptsSection
            customPromptsSection
        }
        .navigationTitle("Prompt 管理")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { addPromptButton }
        .sheet(isPresented: $isAddingPrompt) {
            AddPromptView()
        }
    }
    
    // MARK: - Subviews
    private var builtInPromptsSection: some View {
        Section("内置 Prompts") {
            ForEach(promptManager.builtInPrompts()) { prompt in
                PromptRowView(prompt: prompt)
            }
        }
    }
    
    private var customPromptsSection: some View {
        Section("自定义 Prompts") {
            ForEach(promptManager.customPrompts) { prompt in
                PromptRowView(prompt: prompt)
            }
        }
    }
    
    private var addPromptButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isAddingPrompt = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

// MARK: - 添加Prompt视图
struct AddPromptView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var promptManager = PromptManager.shared
    @State private var title = ""
    @State private var content = ""
    
    private var isFormValid: Bool {
        !title.isEmpty && !content.isEmpty
    }
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            Form {
                promptForm
            }
            .navigationTitle("添加 Prompt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelButton
                saveButton
            }
        }
    }
    
    // MARK: - Subviews
    private var promptForm: some View {
        Group {
            TextField("标题", text: $title)
            TextEditor(text: $content)
                .frame(height: 200)
        }
    }
    
    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("取消") {
                dismiss()
            }
        }
    }
    
    private var saveButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("保存") {
                savePrompt()
            }
            .disabled(!isFormValid)
        }
    }
    
    // MARK: - Methods
    private func savePrompt() {
        let prompt = Prompt(title: title, content: content, isBuiltIn: false)
        promptManager.addCustomPrompt(prompt)
        dismiss()
    }
}

// MARK: - Prompt行视图
private struct PromptRowView: View {
    // MARK: - Properties
    let prompt: Prompt
    @State private var isExpanded = false
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            promptHeader
            promptContent
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isExpanded.toggle()
        }
    }
    
    // MARK: - Subviews
    private var promptHeader: some View {
        HStack {
            Text(prompt.title)
                .font(.headline)
            
            Spacer()
            
            if prompt.isBuiltIn {
                builtInBadge
            }
            
            expandCollapseIcon
        }
    }
    
    private var builtInBadge: some View {
        Text("内置")
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(4)
    }
    
    private var expandCollapseIcon: some View {
        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .foregroundColor(.secondary)
    }
    
    @ViewBuilder
    private var promptContent: some View {
        if isExpanded {
            Text(prompt.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}


