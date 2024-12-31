//
//  SettingView.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import SwiftUI
import SwiftData
import ToastUI

struct SettingView: View {
    // MARK: - Properties
    let chatStore: ChatStore
    
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - App Storage
    @AppStorage("deepseek_apiKey") private var apiKey = DeepSeekServiceConfiguration.apiKey
    @AppStorage("deepseek_baseURL") private var baseURL = DeepSeekServiceConfiguration.baseURL
    @AppStorage("deepseek_historyMessageCount") private var historyMessageCount = DeepSeekServiceConfiguration.historyMessageCount
    // MARK: - State
    @State private var useSystemLanguage = true
    @State private var isSecured = true
    @State private var isTestingAPI = false
    @State private var showTestResult = false
    @State private var testResultMessage = ""
    @State private var testSuccess = false
    @State private var showDeleteConfirmation = false
    @State private var isDeletingData = false
    
    // MARK: - Computed Properties
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            Form {
                apiSettingsSection
                aiAssistantSection
                personalizationSection
                languageSettingsSection
                speechSettingsSection
                dataManagementSection
                aboutSection
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    dismissButton
                }
            }
            .toast(isPresented: $showTestResult, dismissAfter: 2.0) {
                ToastView(testResultMessage)
            }
            .alert("确认删除", isPresented: $showDeleteConfirmation) {
                Button("取消", role: .cancel) { }
                Button("删除", role: .destructive) {
                    deleteAllData()
                }
            } message: {
                Text("此操作将删除所有聊天记录和设置数据，且无法恢复。确定要继续吗？")
            }
        }
    }
    
    // MARK: - View Components
    private var apiSettingsSection: some View {
        Section("API 设置") {
            apiKeyField
            baseURLField
            testConnectionButton
        }
    }
    
    private var apiKeyField: some View {
        HStack {
            if isSecured {
                SecureField("API Key", text: $apiKey)
                    .textContentType(.password)
                    .autocapitalization(.none)
            } else {
                TextField("API Key", text: $apiKey)
                    .textContentType(.none)
                    .autocapitalization(.none)
            }
            
            Image(systemName: isSecured ? "eye.slash" : "eye")
                .foregroundColor(isSecured ? .gray : .primary)
                .onTapGesture {
                    isSecured.toggle()
                }
        }
    }
    
    private var baseURLField: some View {
        TextField("Base URL", text: $baseURL)
            .autocapitalization(.none)
            .keyboardType(.URL)
    }
    
    private var testConnectionButton: some View {
        Button(action: testAPIConnection) {
            HStack {
                if isTestingAPI {
                    ProgressView()
                        .scaleEffect(0.8)
                }
                Text(isTestingAPI ? "测试中..." : "测试连接")
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .background(
                apiKey.isEmpty || baseURL.isEmpty || isTestingAPI
                ? Color.secondary : Color.blue
            )
            .cornerRadius(8)
        }
        .disabled(apiKey.isEmpty || baseURL.isEmpty || isTestingAPI)
    }
    
    private var languageSettingsSection: some View {
        Section("语言设置") {
            Toggle("跟随系统", isOn: $useSystemLanguage)
        }
    }
    
    private var personalizationSection: some View {
        Section("个性化") {
            NavigationLink {
                ThemeSettingView()
            } label: {
                Label("主题设置", systemImage: "paintpalette")
                Spacer()
            }
        }
    }
    
    private var aiAssistantSection: some View {
        Section("AI 助手") {
            NavigationLink {
                PromptSettingView()
            } label: {
                Label("Prompt 管理", systemImage: "text.bubble")
                Spacer()
            }
            
            Section {
                Stepper(
                    value: $historyMessageCount,
                    in: 1...50,
                    step: 1
                ) {
                    HStack {
                        Label("历史消息数量", systemImage: "clock.arrow.circlepath")
                        Spacer()
                        Text("\(historyMessageCount)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Text("设置每次对话时包含的历史消息数量，数量越多上下文越完整，但会增加 Token 消耗")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
        }
    }
    
    private var speechSettingsSection: some View {
        Section("语音设置") {
            NavigationLink {
                SpeechSettingView()
            } label: {
                Label("语音设置", systemImage: "speaker.wave.3")
                Spacer()
            }
        }
    }
    
    private var aboutSection: some View {
        Section("关于") {
            versionRow
            githubLink
            checkUpdateButton
        }
    }
    
    private var versionRow: some View {
        HStack {
            Label("版本", systemImage: "info.circle")
            Spacer()
            Text(appVersion)
                .foregroundColor(.secondary)
        }
    }
    
    private var githubLink: some View {
        Link(destination: URL(string: "https://github.com/DargonLee/DeepSeek")!) {
            HStack {
                Label("项目主页", systemImage: "link")
                Spacer()
                Image(systemName: "arrow.up.right.square")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var checkUpdateButton: some View {
        Button {
            checkForUpdates()
        } label: {
            Label("检查更新", systemImage: "arrow.triangle.2.circlepath")
        }
    }
    
    private var dataManagementSection: some View {
        Section("数据管理") {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("清除所有数据", systemImage: "trash")
                Spacer()
            }
        }
    }
    
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
    
    // MARK: - Methods
    private func checkForUpdates() {
        testResultMessage = "暂无新版本"
        showTestResult = true
    }
    
    private func deleteAllData() {
        isDeletingData = true
        
        Task {
            do {
                try await chatStore.deleteAllData()
                
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }
                
                apiKey = DeepSeekServiceConfiguration.apiKey
                baseURL = DeepSeekServiceConfiguration.baseURL
                
                await MainActor.run {
                    isDeletingData = false
                    testResultMessage = "数据已清除"
                    showTestResult = true
                }
            } catch {
                await MainActor.run {
                    isDeletingData = false
                    testResultMessage = "清除数据失败：\(error.localizedDescription)"
                    showTestResult = true
                }
            }
        }
    }
    
    private func testAPIConnection() {
        guard !apiKey.isEmpty && !baseURL.isEmpty else { return }
        
        isTestingAPI = true
        print("开始测试连接")
        Task {
            do {
                let service = DeepSeekService.shared
                let balance = try await service.checkBalance()
                print("balance: \(balance)")
                
                await MainActor.run {
                    testSuccess = true
                    testResultMessage =
                    "连接成功！余额：\(balance.balanceInfos.first?.totalBalance ?? "0.00")"
                }
            } catch {
                await MainActor.run {
                    testSuccess = false
                    testResultMessage = "连接失败：\(error.localizedDescription)"
                }
            }
            
            await MainActor.run {
                isTestingAPI = false
                showTestResult = true
            }
        }
    }
}

#Preview {
    SettingView(chatStore: ChatStore(modelContext: ModelContext(try! ModelContainer(for: Chat.self))))
}
