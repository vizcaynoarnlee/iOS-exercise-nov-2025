//
//  ChatsView.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import SwiftUI

struct ChatsView: View {
    @EnvironmentObject var tabRouter: TabRouter
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Visitors Tab") {
                    tabRouter.switchTab(.visitors)
                }
            }
            .navigationTitle("Chats")
        }
    }
}

#Preview {
    ChatsView()
}
