import Foundation

struct StatisticsProfilePutRequest: StatisticsNetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: StatisticsDto?
}

struct StatisticsProfileDtoObject: StatisticsDto {
    let param1: String
    func asDictionary() -> [String: String] {
        [
            "likes": param1
        ]
    }
}
