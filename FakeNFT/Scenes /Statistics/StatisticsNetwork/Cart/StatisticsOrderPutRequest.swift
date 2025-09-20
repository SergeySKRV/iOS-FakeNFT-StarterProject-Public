import Foundation

struct StatisticsOrderPutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var dto: Dto?
    var httpMethod: HttpMethod = .put
}

struct StatisticsOrderDtoObject: Dto {
    let param1: String
    func asDictionary() -> [String: String] {
        [
            "nfts": param1
        ]
    }
}
