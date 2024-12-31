//
//  ChatGrouper.swift
//  DeepSeek
//
//  Created by Harlans on 2024/12/5.
//

import Foundation

enum ChatGrouper {
    static func groupChats(_ chats: [Chat]) -> [SidebarChatSection] {
        let calendar = Calendar.current
        let now = Date()
        
        let grouped = Dictionary(grouping: chats) { chat in
            getTimeGroup(for: chat.startTime, relativeTo: now, calendar: calendar)
        }
        
        return grouped.map { key, chats in
            SidebarChatSection(
                id: UUID(),
                title: key,
                items: chats.sorted { $0.startTime > $1.startTime }
            )
        }.sorted { $0.title < $1.title }
    }
    
    private static func getTimeGroup(for date: Date, relativeTo now: Date, calendar: Calendar) -> String {
        let components = calendar.dateComponents([.day, .weekOfYear, .month], from: date, to: now)
        
        if calendar.isDateInToday(date) {
            return "今天"
        } else if calendar.isDateInYesterday(date) {
            return "昨天"
        } else if let days = components.day, days < 7 {
            return "\(days)天前"
        } else if let weeks = components.weekOfYear, weeks < 4 {
            return "\(weeks)周前"
        } else if let months = components.month {
            return "\(months)个月前"
        } else {
            return "更早"
        }
    }
}
