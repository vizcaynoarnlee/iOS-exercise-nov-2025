//
//  DownCopyApp.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import SwiftData
import SwiftUI

@main
struct DownCopyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            // Implement model caching
            // Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            ErrorReporter.log(error: error)
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
