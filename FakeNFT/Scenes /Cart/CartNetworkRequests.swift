import Foundation

struct CartNetworkRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod
    let dto: Dto?
    
    init(endpoint: URL?, httpMethod: HttpMethod, dto: Dto? = nil) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.dto = dto
    }
}

struct DeleteCartItemDto: Dto {
    let itemId: String
    
    func asDictionary() -> [String: String] {
        return ["id": itemId]
    }
}
