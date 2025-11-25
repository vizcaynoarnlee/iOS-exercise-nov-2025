//
//  TabRouter.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import Foundation
import Observation

protocol TabRouterProtocol: ObservableObject {
    var tabs: [TabType] { get }
    var selectedIndex: Int { get }

    func switchTab(_ tab: TabType)
}

final class TabRouter: TabRouterProtocol {
    let tabs: [TabType] = [
        .cards,
        .visitors,
        .chats
    ]
    @Published var selectedIndex: Int = 0

    func switchTab(_ tab: TabType) {
        selectedIndex = tab.id
    }
}
