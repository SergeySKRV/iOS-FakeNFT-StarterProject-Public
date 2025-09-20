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
