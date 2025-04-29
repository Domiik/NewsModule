

import SwiftUI
import SwiftKeychainWrapper

final class NetworkDateService: NetworkDateProtocol {

    private let network: NetworkServiceProtocol
    private let connectivity: ConnectivityProtocol
    private let keychain: KeychainWrapper.Type

    init(
        network: NetworkServiceProtocol = BaseNetworkService(),
        connectivity: ConnectivityProtocol = Connectivity(),
        keychain: KeychainWrapper.Type = KeychainWrapper.self
    ) {
        self.network = network
        self.connectivity = connectivity
        self.keychain = keychain
    }

    func getWeekByDate(date: String, completion: @escaping (Result<String, APError>) -> Void) {
        guard let token = keychain.standard.string(forKey: "access-token"),
              let url = URL(string: Constants.baseURLWeekByDate + "\(date)/") else {
            return completion(.failure(.invalidData))
        }
        
        let request = RequestDefaultValue.shared.requestDefault(url: url, token: token)
        network.requestRaw(request, connectivity: connectivity, completion: completion)
    }
}
