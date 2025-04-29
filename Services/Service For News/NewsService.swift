
import UIKit
import SwiftUI


final class NewsService: NewsServiceProtocol {

    private let network: NetworkServiceProtocol
    private let connectivity: ConnectivityProtocol

    init(
        network: NetworkServiceProtocol = BaseNetworkService(),
        connectivity: ConnectivityProtocol = Connectivity()
    ) {
        self.network = network
        self.connectivity = connectivity
    }

    func getNews(page: Int, completion: @escaping (Result<News, APError>) -> Void) {
        guard let url = URL(string: Constants.baseURLFirstPageNews + "\(page)") else {
            return completion(.failure(.invalidURL))
        }
        let request = RequestDefaultValue.shared.requestNews(url: url)
        network.request(request, connectivity: connectivity, completion: completion)
    }
}
