//
//  GrayButton.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import SwiftUI

/// A circular gray button with a system image.
/// The button executes the provided action on tap.
struct GrayButton: View {
    let title: String
    let imageName: String
    let action: @MainActor () -> Void

    init(
        title: String,
        imageName: String,
        action: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.imageName = imageName
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 44, height: 44)

                    Image(systemName: imageName)
                        .foregroundStyle(.white)
                }
                
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    GrayButton(title: "Skip", imageName: "xmark") {
        // action
    }
}
