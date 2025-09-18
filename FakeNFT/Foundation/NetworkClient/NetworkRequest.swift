import Foundation

// MARK: - Public Protocol
protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Dto? { get }
}

// MARK: - Default Implementation
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

// MARK: - DTO Protocol
/// Transport DTO for request bodies.
/// By default behaves like x-www-form-urlencoded via `asDictionary()`.
protocol Dto {
    /// Used for x-www-form-urlencoded bodies.
    func asDictionary() -> [String: String]
    /// If provided, will be used as raw HTTP body (e.g. JSON).
    func asJSONData() -> Data?
    /// Corresponding Content-Type for the chosen body.
    var contentType: String { get }
}

// MARK: - DTO Default Implementation
extension Dto {
    func asJSONData() -> Data? { nil }

    var contentType: String { "application/x-www-form-urlencoded" }
}
