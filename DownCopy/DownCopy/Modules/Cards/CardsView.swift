//
//  CardsView.swift
//  DownCopy
//
//  Created by Arnlee Vizcayno on 11/25/25.
//

import SwiftUI

struct CardsView: View {
    @EnvironmentObject var tabRouter: TabRouter

    @State var viewModel: CardsViewModel = .init()
    @State var showDateMarkerView: Bool = false
    @State var showDownMarkerView: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.viewState {
                case .initial, .loading:
                    ProgressView("loading...")

                case .loaded:
                    contentView

                case let .error(error):
                    ErrorView(errorMessage: error.localizedDescription)
                }
            }
            .task {
                if viewModel.viewState == .initial {
                    await viewModel.loadUsers()
                }
            }
        }
    }

    var contentView: some View {
        ZStack {
            tabView

            controlView

            if showDateMarkerView {
                MarkerView(title: "Date")
            }

            if showDownMarkerView {
                MarkerView(title: "Down")
            }
        }
        .shadow(color: .gray, radius: 4)
    }

    var tabView: some View {
        TabView(selection: $viewModel.selectedUserIndex) {
            ForEach(Array(viewModel.users.enumerated()), id: \.1.id) { index, user in
                UserCardView(user: user)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .padding(.bottom, 60)
    }

    var controlView: some View {
        VStack {
            Spacer()

            HStack(alignment: .center, spacing: 20) {
                // Skip Button
                GrayButton(title: "Skip", imageName: "xmark") {
                    moveToNext()
                }

                // Date Button
                WhiteButton(title: "Date", imageName: "heart.fill") {
                    dateUser()
                }

                // Down Button
                WhiteButton(title: "Down", imageName: "flame") {
                    downUser()
                }

                // Flirt Button
                GrayButton(title: "Flirt", imageName: "message.fill") {
                    tabRouter.switchTab(.chats)
                }
            }
            .padding(.bottom, 10)
        }
    }

    func dateUser() {
        withAnimation(.easeIn(duration: 0.5)) {
            showDateMarkerView = true
        } completion: {
            moveToNext()
        }
    }

    func downUser() {
        withAnimation(.easeIn(duration: 0.5)) {
            showDownMarkerView = true
        } completion: {
            moveToNext()
        }
    }

    func moveToNext() {
        withAnimation {
            showDateMarkerView = false
            showDownMarkerView = false
            viewModel.moveToNext()
        }
    }
}

#Preview {
    CardsView()
}
