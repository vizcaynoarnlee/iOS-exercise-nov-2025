//
//  CachedAsyncImage.swift
//  DownCopy
//
// Source: https://medium.com/@jakir/enable-image-cache-in-asyncimage-swiftui-db4b9c34603f
// We need to modify a bit to fit our needs and minor improvement

import SwiftUI

public struct CachedAsyncImage: View {
    private let url: URL?
    @State private var image: Image? = nil
    @State private var isLoading = false
    @State private var loadTask: Task<Void, Never>?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ProgressView()
                .onAppear {
                    loadTask = Task { @MainActor in
                        await loadImage()
                    }
                }
                .onDisappear {
                    loadTask?.cancel()
                    loadTask = nil
                }
        }
    }

    @MainActor
    private func loadImage() async {
        guard let url = url, !isLoading else { return }

        // Check for cancellation
        guard Task.isCancelled == false else { return }

        isLoading = true
        defer { isLoading = false }

        // Check if the image is already cached
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            guard Task.isCancelled == false else { return }
            self.image = Image(uiImage: cachedImage)
            return
        }

        // Fetch the image from the network
        do {
            guard Task.isCancelled == false else { return }
            let (data, response) = try await URLSession.shared.data(for: request)

            guard Task.isCancelled == false else { return }

            // Cache the image
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)

            if let uiImage = UIImage(data: data) {
                guard Task.isCancelled == false else { return }
                self.image = Image(uiImage: uiImage)
            }
        } catch {
            // Handle any errors here (e.g., network failure)
            // Error is silently handled - image remains nil and ProgressView continues
            guard Task.isCancelled == false else { return }
        }
    }
}
