import Foundation

// MARK: - Public Protocol
/// Протокол сетевой задачи.
///
/// Используется для управления запросом после его запуска (например, отмены).
protocol NetworkTask {
    /// Отмена выполнения сетевой задачи.
    func cancel()
}


// MARK: - Implementation
struct DefaultNetworkTask: NetworkTask {

    // MARK: - UI Properties
    let dataTask: URLSessionDataTask

    // MARK: - Public Methods
    func cancel() { dataTask.cancel() }
}
