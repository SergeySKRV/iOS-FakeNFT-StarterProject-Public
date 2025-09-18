import Foundation

// MARK: - Public Protocol
protocol NetworkTask {
    func cancel()
}

// MARK: - Implementation
struct DefaultNetworkTask: NetworkTask {

    // MARK: - UI Properties
    let dataTask: URLSessionDataTask

    // MARK: - Public Methods
    func cancel() { dataTask.cancel() }
}
