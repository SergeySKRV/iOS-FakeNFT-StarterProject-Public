//
//  MyNFTViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit

// MARK: - MyNFTViewProtocol
protocol MyNFTViewProtocol: AnyObject {
    // MARK: - Public Methods
    func displayNFTs(_ nfts: [NFTItem])
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
    func showSortOptions(_ options: [NFTSortOption], selectedIndex: Int)
    func showNFTDetails(_ viewController: UIViewController)
}
