//
//  CatalogSceneConfiguration.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 01.09.2025.
//

import UIKit

final class CatalogSceneConfiguration {
    // MARK: - Public Properties
    let catalogViewController: UIViewController
    
    // MARK: - Initializers
    init() {
        let networkClient = DefaultNetworkClient()
        let catalogService = CatalogService(networkClient: networkClient)
        let sortStorage = SortStorage()
        let catalogPresenter = CatalogPresenter(
            catalogService: catalogService,
            sortStorage: sortStorage)
        catalogViewController = CatalogViewController(presenter: catalogPresenter)
        catalogPresenter.catalogView = catalogViewController as? any CatalogViewControllerProtocol
    }
    
    // MARK: - Public Methods
    func assemblyCollection(_ collection: NFTCollection) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let catalogService = CatalogService(networkClient: networkClient)
        let presenter = CollectionPresenter(
            collectionNft: collection,
            catalogService: catalogService
        )
        let viewController = CollectionViewController(presenter: presenter)
        presenter.collectionView = viewController
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
