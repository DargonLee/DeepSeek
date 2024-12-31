    //
    //  SidebarSection.swift
    //  DeepSeek
    //
    //  Created by Harlans on 2024/12/1.
    //

import Foundation

struct SidebarItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let lastUpdated: Date
    var formattedLastUpdated: String {
        return lastUpdated.daysAgoString()
    }
}

struct SidebarSection: Identifiable, Hashable {
    let id: UUID
    let items: [SidebarItem]
    let lastUpdated: Date
    var formattedLastUpdated: String {
        return lastUpdated.daysAgoString()
    }
}

struct SidebarChatSection: Identifiable {
    let id: UUID
    let title: String
    let items: [Chat]
}
