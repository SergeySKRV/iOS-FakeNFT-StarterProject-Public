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

    var dto: Encodable?
    var likes: Set<String>
    var body: Data? {
        return likesToString().data(using: .utf8)
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    // MARK: - Initializers
    init(dto: Encodable? = nil, likes: Set<String>) {
        self.dto = dto
        self.likes = likes
    }

    // MARK: - Public Methods
    func likesToString()->String{
        var likeString = "likes="

        if likes.isEmpty {
            likeString = ""
        } else {
            for (index , like) in likes.enumerated() {
                likeString += like
                if index != likes.count - 1 {
                    likeString += "&likes="
                }
            }
        }
        return likeString
    }
}

