//
//  Protocols.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 13.09.2025.
//

import Foundation

// MARK: - Presenter Output Contract - для вызова веб вью
protocol CatalogProfilePresenterOutput: AnyObject {
    func showWebViewController(urlString: String)
}

protocol CollectionViewCellDelegate: AnyObject {
    func likeButtonDidChange(for indexPath: IndexPath, isLiked: Bool)
    func cartButtonDidChange(for indexPath: IndexPath)
}
