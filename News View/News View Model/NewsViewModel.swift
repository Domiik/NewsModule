//
//  NewsViewModel.swift
//  CHSURasp
//
//  Created by Domiik on 24.05.2023.
//

import SwiftUI
import Kingfisher
import Combine

final class NewsViewModel: ObservableObject {
    
    enum State {
        case idle, loading, end, error
    }
    
    @Published var alertItem: APError?
    @Published private(set) var state = State.idle
    @Published var news: [Item] = []
    @Published var currentPage = 1
    @Published var isLoadingNextPage = false
    @Published var countPage = 0
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }
    
    func getNews() {
        state = .loading
        fetchNextPage(page: currentPage)
    }
    
    func fetchNextPage(page: Int) {
        newsService.getNews(page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let news):
                    self.news.append(contentsOf: news.items)
                    self.countPage = news.pager.pages
                    self.state = .end
                    self.isLoadingNextPage = false
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func shouldLoadData(id: String) -> Bool {
        news.last?.id == id
    }
    
    func resetNews() {
        news.removeAll()
        currentPage = 1
    }
    
    private func handleError(_ error: APError) {
        alertItem = error
        state = .error
    }
}
