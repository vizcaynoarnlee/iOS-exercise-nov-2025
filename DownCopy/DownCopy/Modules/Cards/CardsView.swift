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
    @State private var isProcessingAction: Bool = false

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
            if viewModel.users.isEmpty {
                EmptyView(message: "No users found.")
            } else {
                tabView
                
                controlView
            }

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
                    handleSkipAction()
                }
                .disabled(isProcessingAction)

                // Date Button
                WhiteButton(title: "Date", imageName: "heart.fill") {
                    dateUser()
                }
                .disabled(isProcessingAction)

                // Down Button
                WhiteButton(title: "Down", imageName: "flame") {
                    downUser()
                }
                .disabled(isProcessingAction)

                // Flirt Button
                GrayButton(title: "Flirt", imageName: "message.fill") {
                    handleFlirtAction()
                }
                .disabled(isProcessingAction)
            }
            .padding(.bottom, 10)
        }
    }

    func dateUser() {
        guard !isProcessingAction else { return }
        
        isProcessingAction = true
        withAnimation(.easeIn(duration: 0.5)) {
            showDateMarkerView = true
        } completion: {
            moveToNext()
        }
    }

    func downUser() {
        guard !isProcessingAction else { return }
        
        isProcessingAction = true
        withAnimation(.easeIn(duration: 0.5)) {
            showDownMarkerView = true
        } completion: {
            moveToNext()
        }
    }

    func handleSkipAction() {
        guard !isProcessingAction else { return }
        
        isProcessingAction = true
        moveToNext()
    }

    func handleFlirtAction() {
        guard !isProcessingAction else { return }
        
        tabRouter.switchTab(.chats)
        isProcessingAction = false
    }

    func moveToNext() {
        withAnimation {
            showDateMarkerView = false
            showDownMarkerView = false
            viewModel.moveToNext()
        } completion: {
            isProcessingAction = false
        }
    }
}

#Preview {
    CardsView()
}
