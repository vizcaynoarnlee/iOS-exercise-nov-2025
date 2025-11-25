//
//  UserCardView.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import SwiftUI

struct UserCardView: View {
    let user: User

    @State private var offset: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CachedAsyncImage(url: user.profilePicUrl)
                    .frame(width: geometry.size.width - 8, height: geometry.size.height - 8)
                    .cornerRadius(16)
                    .clipped()

                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .cornerRadius(16)
                .frame(width: geometry.size.width - 8, height: geometry.size.height - 8)

                userContentView
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    var userContentView: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()

                Text("\(user.name), \(user.age)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                if user.loc.isEmpty == false {
                    locationView
                }

                if user.aboutMe.isEmpty == false {
                    aboutMeView
                }
            }

            Spacer()
        }
        .padding(20)
        .padding(.bottom, 40)
    }

    var locationView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(.white)
                Text("Location")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            Text(user.loc)
                .font(.title3)
                .foregroundStyle(.white)
        }
        .padding(8)
    }

    var aboutMeView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "info.square")
                    .foregroundStyle(.white)
                Text("About me")
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            Text(user.aboutMe)
                .font(.title3)
                .foregroundStyle(.white)
        }
        .padding(8)
    }
}

#Preview {
    UserCardView(
        user: User(
            userId: 1,
            name: "Test",
            age: 23,
            loc: "Cebu",
            aboutMe: "About Me",
            profilePicUrl: URL(string: "https://picsum.photos/200")
        )
    )
}
