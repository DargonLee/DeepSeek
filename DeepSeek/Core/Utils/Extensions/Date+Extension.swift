//
//  Date+Extension.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/1.
//

import Foundation

extension Date {
    func daysAgoString() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.day, .month], from: self, to: now)
        
        guard let days = components.day else {
            return "Unknown"
        }
        
        switch days {
            case 0:
                return "Today"
            case 1...7:
                return "\(days) day\(days > 1 ? "s" : "") ago"
            case 8...30:
                return "This Month"
            default:
                return "Earlier"
        }
    }
}
