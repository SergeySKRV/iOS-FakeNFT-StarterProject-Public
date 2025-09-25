import Foundation

struct StatisticsOrderPutRequest: StatisticsNetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var dto: StatisticsDto?
    var httpMethod: HttpMethod = .put
}

struct StatisticsOrderDtoObject: StatisticsDto {
    let param1: String
    func asDictionary() -> [String: String] {
                        ["nfts": param1] }
}
