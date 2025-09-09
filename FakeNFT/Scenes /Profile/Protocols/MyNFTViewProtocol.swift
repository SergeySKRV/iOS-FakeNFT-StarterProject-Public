//
//  MyNFTViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import Foundation

protocol MyNFTViewProtocol: AnyObject {
    func displayNFTs(_ nfts: [NFTItem])
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
}
