//
//  DeepSeekServiceConfiguration.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/2.
//

import Foundation
import SwiftUI

struct DeepSeekServiceConfiguration {
    @AppStorage("deepseek_apiKey") static var apiKey = "sk-06c07aa503b34942ad93500f04175a14"
    @AppStorage("deepseek_baseURL") static var baseURL = "https://api.deepseek.com"
    @AppStorage("deepseek_model") static var model = "deepseek-chat"
    static let historyMessageCount = 10
}
