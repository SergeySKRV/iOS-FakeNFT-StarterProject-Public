import Foundation

enum StatisticsHttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol StatisticsNetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: StatisticsDto? { get }
}

protocol StatisticsDto {
    func asDictionary() -> [String: String]
}

extension StatisticsNetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}
