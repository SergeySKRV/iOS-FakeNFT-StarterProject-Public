//
//  ProfilePutRequest.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 17.09.2025.
//

import Foundation

struct ProfilePutRequest: NetworkRequest {
    // MARK: - Public Properties
    let httpMethod: HttpMethod = .put
    let likes: Set<String>
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var body: RequestBodyConvertible? {
        ProfileRequestBody(likes: likes)
    }
    
    // MARK: - Initializers
    init(likes: Set<String>) {
        self.likes = likes
    }
}

struct ProfileRequestBody: RequestBodyConvertible {
    let likes: Set<String>
    
    func asDictionary() -> [String: String] {
        if likes.isEmpty {
            return ["likes": "null"]
        } else {
            return ["likes": likes.joined(separator: ",")]
        }
    }
    
    func asJSONData() -> Data? {
        return nil
    }
    
    var contentType: String {
        return "application/x-www-form-urlencoded"
    }
}

