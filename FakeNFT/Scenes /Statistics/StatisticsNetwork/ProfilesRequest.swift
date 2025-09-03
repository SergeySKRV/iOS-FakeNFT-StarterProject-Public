import Foundation

struct ProfilesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
    var dto: Dto?
}


