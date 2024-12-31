//
//  JSON+Extension.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import Foundation

extension Array where Element == Prompt {
    func toJSONString() -> String {
        if let data = try? JSONEncoder().encode(self),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "[]"
    }
}

extension Prompt {
    func toJSONString() -> String {
        if let data = try? JSONEncoder().encode(self),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return ""
    }
}


extension String {
    func toPrompts() -> [Prompt] {
        if let data = self.data(using: .utf8),
           let decodedPrompts = try? JSONDecoder().decode([Prompt].self, from: data) {
            return decodedPrompts
        }
        return []
    }

    func toPrompt() -> Prompt? {
        if let data = self.data(using: .utf8),
           let prompt = try? JSONDecoder().decode(Prompt.self, from: data) {
            return prompt
        }
        return nil
    }
}
