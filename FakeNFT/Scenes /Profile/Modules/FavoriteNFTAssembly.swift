//
//  FavoriteNFTAssembly.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

// MARK: - FavoriteNFTAssembly

public final class FavoriteNFTAssembly {
    private let servicesAssembler: ServicesAssembly

    internal init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    public func build() -> UIViewController {
        let viewController = FavoriteNFTViewController(servicesAssembly: servicesAssembler)
        let presenter = FavoriteNFTPresenter(
            view: viewController,
            nftService: servicesAssembler.nftService,
            userService: servicesAssembler.userService,
            servicesAssembly: servicesAssembler
        )
        viewController.presenter = presenter
        return viewController
    }
}
