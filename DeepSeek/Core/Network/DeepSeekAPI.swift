//
//  DeepSeekAPI.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/2.
//

import Foundation
import Moya

enum DeepSeekAPI {
    // Chat APIS
    case chat(parameters: ChatParameters)
    case stream(parameters: ChatParameters)
    case abort(parameters: ChatParameters)

    // Check APIS
    case checkBalance
}

extension DeepSeekAPI: TargetType {
    var baseURL: URL {
        return URL(string: DeepSeekServiceConfiguration.baseURL)!
    }

    var path: String {
        switch self {
        case .chat, .stream, .abort:
            let version = "v1"
            return "/\(version)/chat/completions"
        case .checkBalance:
            return "/user/balance"
        }
    }

    var method: Moya.Method {
        switch self {
        case .chat, .stream, .abort:
            return .post
        case .checkBalance:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .chat(let parameters):
            let messages = parameters.messages.map { ["role": $0.role.rawValue, "content": $0.content] }
            let requestParameters: [String: Any] = [
                "model": parameters.model,
                "messages": messages,
                "stream": false
            ]
            return .requestParameters(parameters: requestParameters, encoding: JSONEncoding.default)
        case .stream(let parameters):
            let messages = parameters.messages.map { ["role": $0.role.rawValue, "content": $0.content] }
            let requestParameters: [String: Any] = [
                "model": parameters.model,
                "messages": messages,
                "stream": true
            ]
            return .requestParameters(parameters: requestParameters, encoding: JSONEncoding.default)
        case .abort(_):
            let requestParameters: [String: Any] = [
                "id": ""
            ]
            return .requestParameters(parameters: requestParameters, encoding: JSONEncoding.default)
        case .checkBalance:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return [
            "Authorization": "Bearer \(DeepSeekServiceConfiguration.apiKey)",
            "Content-Type": "application/json",
        ]
    }
}

struct ChatParameters {
    let model: String
    let messages: [ChatMessage]
    let stream: Bool

    init(
        model: String = DeepSeekServiceConfiguration.model,
        messages: [ChatMessage],
        stream: Bool = true
    ) {
        self.model = model
        self.messages = messages
        self.stream = stream
    }
}

extension ChatParameters {
    func toStreamParameters() -> Self {
        ChatParameters(
            model: self.model,
            messages: self.messages,
            stream: true  // 确保stream参数为true
        )
    }
}
