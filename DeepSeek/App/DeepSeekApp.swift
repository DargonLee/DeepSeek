//
//  DeepSeekApp.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/1.
//

import SwiftUI
import SwiftData

@main
struct DeepSeekApp: App {
    let container = AppContainer.shared
    
    var body: some Scene {
        WindowGroup {
            AppEntryView()
        }
        .modelContainer(container.modelContainer)
    }
}
