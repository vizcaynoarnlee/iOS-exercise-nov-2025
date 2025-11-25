//
//  WhiteButton.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import SwiftUI

struct WhiteButton: View {
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
                        .strokeBorder(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    .red, .orange, .yellow, .green, .blue, .indigo, .purple
                                ]),
                                center: .center
                            ),
                            lineWidth: 2
                        )
                        .background(
                            Circle()
                                .fill(Color.white)
                        )
                        .frame(width: 75, height: 75)
                    
                    Image(systemName: imageName)
                        .foregroundStyle(.red)
                        .font(.system(size: 30))
                }
                
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    WhiteButton(title: "Date", imageName: "heart.fill") {
        // action
    }
}
