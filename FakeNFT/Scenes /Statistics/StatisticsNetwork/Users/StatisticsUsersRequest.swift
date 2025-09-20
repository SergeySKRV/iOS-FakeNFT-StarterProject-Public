import Foundation

struct StatisticsUsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?sortBy=name")
    }
    var dto: Dto?
}
