//
//  UserModel.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 17.09.2025.
//

import Foundation

struct UserModel {
    let id: String
    let name: String
    let website: String

    init(with user: UserResult) {
        self.id = user.id
        self.name = user.name
        self.website = user.website
    }
}

