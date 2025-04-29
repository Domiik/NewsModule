//
//  NewsListView.swift
//  CHSURasp
//
//  Created by Владимир Иванов on 28.04.2025.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var viewModel: NewsViewModel
    @Binding var currentPage: Int
    @Binding var hideTab: Bool
    @Binding var offset: CGFloat
    @Binding var lastOffset: CGFloat
    
    var body: some View {
        LazyVStack {
            if viewModel.news.isEmpty {
                ForEach(0..<3) { _ in
                    NewsCellPlaceholder()
                }
            } else {
                ForEach(viewModel.news, id: \.id) { news in
                    Navigator.navigate(.newsDetail($hideTab, news.code)) {
                        NewsCell(
                            titleText: news.name,
                            date: news.date,
                            imageUrl: Constants.baseURLNews + news.previewPicture.src,
                            code: news.code,
                            tag: news.tags?.stringValue ?? "#тэг"
                        )
                        .padding([.horizontal], 8)
                    }
                    .onAppear {
                        if viewModel.shouldLoadData(id: news.id) && !viewModel.isLoadingNextPage {
                            viewModel.isLoadingNextPage = true
                            viewModel.fetchNextPage(page: currentPage + 1)
                            currentPage += 1
                        }
                    }
                }
            }
            
            if viewModel.isLoadingNextPage {
                ProgressView().padding()
            }
        }
        .overlay(
            scrollOffsetReader
        )
        .padding(.top, 3)
    }
    
    private var scrollOffsetReader: some View {
        GeometryReader { proxy -> Color in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let threshold: CGFloat = 35
            
            DispatchQueue.main.async {
                if minY < offset, offset < 0, -minY > (lastOffset + threshold) {
                    withAnimation(.easeOut.speed(0.7)) { hideTab = true }
                    lastOffset = -offset
                }
                if minY > offset, -minY < (lastOffset - threshold) {
                    withAnimation(.easeOut.speed(0.7)) { hideTab = false }
                    lastOffset = -offset
                }
                offset = minY
            }
            return Color.clear
        }
    }
}

