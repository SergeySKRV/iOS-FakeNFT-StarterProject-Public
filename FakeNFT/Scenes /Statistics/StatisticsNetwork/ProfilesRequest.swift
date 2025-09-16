import Foundation

struct ProfilesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?sortBy=name")
    }
    var dto: Dto?
}
