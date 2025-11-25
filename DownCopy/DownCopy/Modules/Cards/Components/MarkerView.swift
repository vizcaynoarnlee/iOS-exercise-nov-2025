//
//  MarkerView.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import SwiftUI

struct MarkerView: View {
    var title: String

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 120, height: 60)
                .cornerRadius(75)

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .shadow(color: .gray, radius: 10)
        }
    }
}

#Preview {
    MarkerView(title: "Down")
}
