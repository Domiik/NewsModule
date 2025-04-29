//
//  NewsView.swift
//  CHSURasp
//
//  Created by Domiik on 09.01.2023.
//

import SwiftUI

struct NewsView: View {
    
    // MARK: - Properties
    @State private var searchText = ""
    @StateObject private var viewModel: NewsViewModel
    @StateObject private var viewModelStories = StoriesViewModel()
    @State private var currentPage: Int = 1
    @Binding var hideTab: Bool
    @State private var presentStories = false
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    
    init(hideTab: Binding<Bool>, viewModel: @autoclosure @escaping () -> NewsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
        self._hideTab = hideTab
    }
    
    var body: some View {
            switch viewModel.state {
            case .idle:
                Color.clear.onAppear { viewModel.getNews() }
            case .loading:
                LoadingView()
            case .end:
                loadedContent
            case .error:
                ErrorView(error: viewModel.alertItem, retryAction: {
                    viewModel.getNews()
                })
            }
    }
    
    private var loadedContent: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                StoriesHorizontalView(viewModel: viewModelStories, presentStories: $presentStories)
                NewsListView(viewModel: viewModel, currentPage: $currentPage, hideTab: $hideTab, offset: $offset, lastOffset: $lastOffset)
            }
            .refreshable {
                currentPage = 1
                viewModel.resetNews()
                viewModel.fetchNextPage(page: currentPage)
            }
            .coordinateSpace(name: "SCROLL")
            .navigationTitle(L10n.news)
        }
        .accentColor(Color(asset: .textColorWhite))
    }
}
