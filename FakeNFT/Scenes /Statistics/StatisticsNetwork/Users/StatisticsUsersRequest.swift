import Foundation

struct StatisticsUsersRequest: StatisticsNetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?sortBy=name")
    }
    var dto: StatisticsDto?
}
