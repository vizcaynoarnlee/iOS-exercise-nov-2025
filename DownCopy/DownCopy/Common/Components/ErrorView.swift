//
//  ErrorView.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/28/25.
//

import SwiftUI

struct ErrorView: View {
    var errorMessage: String?

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
                .font(.largeTitle)
            Text(errorMessage ?? "Unknown error occurred.")
                .font(.caption)
        }
    }
}

#Preview {
    ErrorView()
}
