//
//  FavoriteNFTViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

protocol FavoriteNFTViewProtocol: AnyObject {
    func displayNFTs(_ nfts: [NFTItem])
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
    func showNFTDetails(_ viewController: UIViewController)
}
