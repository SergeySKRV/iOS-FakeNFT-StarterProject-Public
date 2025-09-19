//
//  FavoriteNFTViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

// MARK: - FavoriteNFTViewProtocol

/// Контракт между Presenter и View для экрана «Избранные NFT».
protocol FavoriteNFTViewProtocol: AnyObject {
    /// Отображает список избранных NFT.
    /// - Parameter nfts: Массив моделей NFT для отображения.
    func displayNFTs(_ nfts: [NFTItem])

    /// Показывает индикатор загрузки.
    func showLoading()

    /// Скрывает индикатор загрузки.
    func hideLoading()

    /// Отображает сообщение об ошибке.
    /// - Parameter error: Ошибка, возникшая при загрузке или обработке данных.
    func showError(_ error: Error)

    /// Открывает экран с подробной информацией о выбранном NFT.
    /// - Parameter viewController: Экран деталей NFT.
    func showNFTDetails(_ viewController: UIViewController)
}
