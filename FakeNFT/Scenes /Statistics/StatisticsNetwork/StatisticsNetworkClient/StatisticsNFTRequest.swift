import Foundation

struct StatisticsNFTRequest: StatisticsNetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)?sortBy=name")
    }
    var dto: StatisticsDto?
}
