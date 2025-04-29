
import Foundation
import Network

protocol ConnectivityProtocol {
    var isConnected: Bool { get }
}


final class Connectivity: ObservableObject, ConnectivityProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Connectivity")
    
    @Published var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
