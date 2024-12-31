//
//  ChatCheckBalance.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/3.
//

import Foundation

// MARK: - 余额查询API
enum DeepSeekCheckAPI {
    case checkBalance
}

// MARK: - 余额信息模型
struct BalanceResponse: Codable {
    let isAvailable: Bool
    let balanceInfos: [BalanceInfo]
    
    enum CodingKeys: String, CodingKey {
        case isAvailable = "is_available"
        case balanceInfos = "balance_infos"
    }
}

struct BalanceInfo: Codable {
    let currency: Currency
    let totalBalance: String
    let grantedBalance: String
    let toppedUpBalance: String
    
    enum CodingKeys: String, CodingKey {
        case currency
        case totalBalance = "total_balance"
        case grantedBalance = "granted_balance"
        case toppedUpBalance = "topped_up_balance"
    }
}

enum Currency: String, Codable {
    case cny = "CNY"
    case usd = "USD"
}
