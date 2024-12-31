//
//  Preview.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/13.
//

import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer
    // any 表示任何遵守 PersistentModel 协议的类型
    // PersistentModel.Type 表示这些类型的元类型
    // ... 是可变参数（variadic parameter）
    init(_ models: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create preview container")
        }
    }
    
    func addExamples(_ examples: [any PersistentModel]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}
