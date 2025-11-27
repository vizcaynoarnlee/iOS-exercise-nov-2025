//
//  EmptyView.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/28/25.
//

import SwiftUI

struct EmptyView: View {
    var message: String?
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "xmark.bin.circle")
                .foregroundColor(.gray)
                .font(.largeTitle)
            Text(message ?? "Empty list.")
                .font(.caption)
        }
    }
}

#Preview {
    EmptyView()
}
