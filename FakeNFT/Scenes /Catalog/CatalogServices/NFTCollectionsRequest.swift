//
//  NFTCollectionsRequest.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 31.08.2025.
//

 import Foundation

 struct NFTCollectionRequest: NetworkRequest {
     let id: String
     var endpoint: URL? {
         URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
     }
     var body: RequestBodyConvertible?
 }

 struct NFTCollectionsRequest: NetworkRequest {
     var endpoint: URL? {
         URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
     }
     var body: RequestBodyConvertible?
 }
