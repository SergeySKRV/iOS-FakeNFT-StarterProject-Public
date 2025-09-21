import Foundation

struct StatisticsProfileRequest: StatisticsNetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var dto: StatisticsDto?
}
