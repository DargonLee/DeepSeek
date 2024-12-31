//
//  DeepSeekService.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/2.
//

import Foundation
import Moya

enum DeepSeekError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
}

final class DeepSeekService {
    static let shared = DeepSeekService()

    private let provider: MoyaProvider<DeepSeekAPI>
    private let apiKey: String
    private let baseURL: String
    private let model: String

    init() {
        self.apiKey = DeepSeekServiceConfiguration.apiKey
        self.baseURL = DeepSeekServiceConfiguration.baseURL
        self.model = DeepSeekServiceConfiguration.model
        self.provider = MoyaProvider<DeepSeekAPI>()
    }

    func chat(parameters: ChatParameters) async throws -> DeepseekChatResponseModel {
        return try await withCheckedThrowingContinuation { continuation in
            
            provider.request(.chat(parameters: parameters)) { result in
                switch result {
                case .success(let response):
                    // 打印响应数据
                    #if DEBUG
                    if let responseString = String(data: response.data, encoding: .utf8) {
                        print("Response JSON: \(responseString)")
                    }
                    #endif
                    do {
                        let chatResponse = try response.map(DeepseekChatResponseModel.self)
                        continuation.resume(returning: chatResponse)
                    } catch {
                        continuation.resume(throwing: DeepSeekError.decodingError(error))
                    }
                case .failure(let error):
                    continuation.resume(throwing: DeepSeekError.networkError(error))
                }
            }
        }
    }

    func stream(parameters: ChatParameters) -> AsyncThrowingStream<DeepseekChatResponseModel.StreamChunk, Error> {
        return AsyncThrowingStream { continuation in
            let streamParameters = parameters.toStreamParameters()
            provider.request(.stream(parameters: streamParameters)) { result in
                switch result {
                case .success(let response):
                    let responseString = String(data: response.data, encoding: .utf8) ?? ""
                    let events = responseString.components(separatedBy: "\n")
                    
                    for event in events {
                        guard !event.isEmpty else { continue }
                        
                        if event.hasPrefix("data: ") {
                            let jsonString = String(event.dropFirst(6))
                            if jsonString == "[DONE]" {
                                continuation.finish()
                                return
                            }
                            
                            do {
                                if let data = jsonString.data(using: .utf8) {
                                    let chunk = try JSONDecoder().decode(
                                        DeepseekChatResponseModel.StreamChunk.self,
                                        from: data
                                    )
                                    continuation.yield(chunk)
                                }
                            } catch {
                                continuation.finish(throwing: DeepSeekError.decodingError(error))
                                return
                            }
                        }
                    }
                    
                    continuation.finish()
                    
                case .failure(let error):
                    continuation.finish(throwing: DeepSeekError.networkError(error))
                }
            }
        }
    }

    func checkBalance() async throws -> BalanceResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.checkBalance) { result in
                switch result {
                case .success(let response):
                    do {
                        let balanceResponse = try response.map(BalanceResponse.self)
                        continuation.resume(returning: balanceResponse)
                    } catch {
                        continuation.resume(throwing: DeepSeekError.decodingError(error))
                    }
                case .failure(let error):
                    continuation.resume(throwing: DeepSeekError.networkError(error))
                }
            }
        }
    }
}
/*
 {
     "id": "ece4c225-5d96-4414-8e01-ddec1b413711",
     "object": "chat.completion",
     "created": 1733141850,
     "model": "deepseek-chat",
     "choices": [{
         "index": 0,
         "message": {
             "role": "assistant",
             "content": "你好！很高兴见到你。今天有什么特别的事情或者问题需要我帮忙吗？"
         },
         "logprobs": null,
         "finish_reason": "stop"
     }],
     "usage": {
         "prompt_tokens": 10,
         "completion_tokens": 18,
         "total_tokens": 28,
         "prompt_cache_hit_tokens": 0,
         "prompt_cache_miss_tokens": 10
     },
     "system_fingerprint": "fp_1c141eb703"
 }
 */
