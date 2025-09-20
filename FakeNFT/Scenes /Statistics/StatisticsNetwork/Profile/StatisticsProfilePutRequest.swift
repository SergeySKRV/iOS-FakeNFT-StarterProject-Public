import Foundation

struct StatisticsProfilePutRequest: NetworkRequest {
   var endpoint: URL? {
       URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
   }
   var httpMethod: HttpMethod = .put
   var dto: Dto?
}

struct StatisticsProfileDtoObject: Dto {
   let param1: String
   func asDictionary() -> [String: String] {
        [
            "likes": param1
        ]
    }
}

struct StatisticsProfilePutResponse: Decodable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let likes: [String]?
    let id: String?
}
