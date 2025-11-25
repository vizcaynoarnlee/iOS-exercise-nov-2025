//
//  TabType.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import Foundation

enum TabType: Int, Identifiable {
    case cards = 0
    case visitors
    case chats

    var id: Int {
        rawValue
    }

    var title: String {
        switch self {
        case .cards:
            return "Cards"
        case .visitors:
            return "Visitors"
        case .chats:
            return "Chats"
        }
    }

    var sytemImage: String {
        switch self {
        case .cards:
            return "square.stack"
        case .visitors:
            return "heart.fill"
        case .chats:
            return "ellipsis.message.fill"
        }
    }
}
