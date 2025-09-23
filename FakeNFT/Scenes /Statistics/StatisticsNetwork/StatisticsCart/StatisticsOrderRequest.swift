import Foundation

struct StatisticsOrderRequest: StatisticsNetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var dto: StatisticsDto?
}
