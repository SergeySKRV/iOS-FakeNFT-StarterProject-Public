//
//  FavoriteNFTAssembly.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

// MARK: - FavoriteNFTAssembly
final class FavoriteNFTAssembly {

    // MARK: - Dependencies
    private let services: ServicesAssembly

    // MARK: - Init
    init(services: ServicesAssembly) {
        self.services = services
    }

    // MARK: - Public Methods
    func build() -> UIViewController {
        let viewController = FavoriteNFTViewController()
        let presenter = FavoriteNFTPresenter(
            view: viewController,
            nftService: services.nftService,
            userService: services.userService,
            nftDetailAssembly: NftDetailAssembly(servicesAssembler: services)
        )
        viewController.presenter = presenter
        return viewController
    }
}
