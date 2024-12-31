//
//  ChatServicesModel.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/2.
//

import Foundation

struct DeepseekChatRequestModel: Codable {
    let model: String = DeepSeekServiceConfiguration.model
    let messages: [ChatMessageModel]
    let frequencyPenalty: Double = 0
    let maxTokens: Int = 4096
    let presencePenalty: Double = 0
    let responseFormat: ResponseFormat = .text
    let stop: [String] = []
    let stream: Bool = false
    let temperature: Double = 1
    let topP: Double = 1

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case stream
    }

    enum ResponseFormat: String, Codable {
        case jsonObject
        case text
    }
}

struct DeepseekChatResponseModel: Codable {
    let id: String
    let choices: [Choice]
    let created: Int
    let model: String
    let systemFingerprint: String
    let object: String
    let usage: Usage

    enum CodingKeys: String, CodingKey {
        case id
        case choices
        case created
        case model
        case systemFingerprint = "system_fingerprint"
        case object
        case usage
    }

    struct Choice: Codable {
        let finishReason: String
        let index: Int
        let message: ChatMessageModel
        let logprobs: Logprobs?

        enum CodingKeys: String, CodingKey {
            case finishReason = "finish_reason"
            case index
            case message
            case logprobs
        }
    }

    struct Message: Codable {
        let content: String
        let toolCalls: [ToolCall]?
        let role: ChatMessageModel

        enum CodingKeys: String, CodingKey {
            case content
            case toolCalls = "tool_calls"
            case role
        }
    }

    struct ToolCall: Codable {
        let id: String
        let type: String
        let function: Function
    }

    struct Function: Codable {
        let name: String
        let arguments: String
    }

    struct Logprobs: Codable {
        let content: [String]?
    }

    struct Usage: Codable {
        let completionTokens: Int
        let promptTokens: Int
        let promptCacheHitTokens: Int
        let promptCacheMissTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case completionTokens = "completion_tokens"
            case promptTokens = "prompt_tokens"
            case promptCacheHitTokens = "prompt_cache_hit_tokens"
            case promptCacheMissTokens = "prompt_cache_miss_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

extension DeepseekChatResponseModel {
    struct StreamChunk: Decodable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let systemFingerprint: String
        let choices: [StreamChoice]

        enum CodingKeys: String, CodingKey {
            case id
            case object
            case created
            case model
            case systemFingerprint = "system_fingerprint"
            case choices
        }
    }
    
    struct StreamChoice: Decodable {
        let delta: StreamDelta
        let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case delta
            case finishReason = "finish_reason"
        }
    }
    
    struct StreamDelta: Decodable {
        let role: String?
        let content: String?
    }
}

// 扩展Choice的finishReason为枚举类型
extension DeepseekChatResponseModel.Choice {
    enum FinishReason: String, Codable {
        case stop = "stop"
        case length = "length"
        case contentFilter = "content_filter"
        case toolCalls = "tool_calls"
        case insufficientSystemResource = "insufficient_system_resource"
    }
}

// 扩展Message的role为枚举类型
extension DeepseekChatResponseModel.Message {
    enum Role: String, Codable {
        case assistant
        case user
        case system
    }
}
