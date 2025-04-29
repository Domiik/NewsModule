//
//  BaseNetworkService.swift
//  CHSURasp
//
//  Created by Владимир Иванов on 27.04.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ request: URLRequest,
        connectivity: ConnectivityProtocol,
        completion: @escaping (Result<T, APError>) -> Void
    )
    
    func requestRaw(
        _ request: URLRequest,
        connectivity: ConnectivityProtocol,
        completion: @escaping (Result<String, APError>) -> Void
    )
}

final class BaseNetworkService: NetworkServiceProtocol {
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        _ request: URLRequest,
        connectivity: ConnectivityProtocol,
        completion: @escaping (Result<T, APError>) -> Void
    ) {
        guard connectivity.isConnected else {
            return complete(.internetConnection, completion)
        }
        
        session.dataTask(with: request) { data, response, error in
            if let _ = error {
                return self.complete(.unableToComplete, completion)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return self.complete(.invalidResponse, completion)
            }
            
            guard let data = data else {
                return self.complete(.invalidData, completion)
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                self.debugDecoding(error)
                self.complete(.invalidData, completion)
            }
        }.resume()
    }
    
    func requestRaw(
        _ request: URLRequest,
        connectivity: ConnectivityProtocol,
        completion: @escaping (Result<String, APError>) -> Void
    ) {
        guard connectivity.isConnected else {
            return complete(.internetConnection, completion)
        }
        
        session.dataTask(with: request) { data, response, error in
            if let _ = error {
                return self.complete(.unableToComplete, completion)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return self.complete(.invalidResponse, completion)
            }
            
            guard let data = data, let string = String(data: data, encoding: .utf8) else {
                return self.complete(.invalidData, completion)
            }
            
            completion(.success(string))
        }.resume()
    }
    
    private func complete<T>(_ error: APError, _ completion: (Result<T, APError>) -> Void) {
        CrashManager.shared.sendErrorMessage(error: error)
        completion(.failure(error))
    }
    
    private func debugDecoding(_ error: Error) {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .dataCorrupted(let context):
                print("Data corrupted:", context.debugDescription)
            case .keyNotFound(let key, let context):
                print("Missing key '\(key.stringValue)':", context.debugDescription)
            case .typeMismatch(let type, let context):
                print("Type mismatch at \(context.codingPath.map(\.stringValue).joined(separator: " > "))", "Expected: \(type)")
            case .valueNotFound(let type, let context):
                print("Missing value for type '\(type)':", context.debugDescription)
            @unknown default:
                print("Unknown decoding error")
            }
        } else {
            print("Decoding error:", error.localizedDescription)
        }
    }
}

