import Foundation

struct CartNetworkRequest: StatisticsNetworkRequest {
    let endpoint: URL?
    let httpMethod: StatisticsHttpMethod
    let dto: StatisticsDto?
    
    init(endpoint: URL?, httpMethod: StatisticsHttpMethod, dto: StatisticsDto? = nil) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.dto = dto
    }
}

struct DeleteCartItemDto: StatisticsDto {
    let itemId: String
    
    func asDictionary() -> [String: String] {
        return ["id": itemId]
    }
}
