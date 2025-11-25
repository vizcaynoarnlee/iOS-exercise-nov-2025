//
//  VisitorsView.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import SwiftUI

struct VisitorsView: View {
    @EnvironmentObject var tabRouter: TabRouter
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Chats Tab") {
                    tabRouter.switchTab(.chats)
                }
            }
            .navigationTitle("Visitors")
        }
    }
}

#Preview {
    VisitorsView()
}
