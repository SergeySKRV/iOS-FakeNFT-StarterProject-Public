//
//  MyNFTViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit

// MARK: - MyNFTViewProtocol

/// Контракт между Presenter и View для экрана «Мои NFT».
protocol MyNFTViewProtocol: AnyObject {
    /// Отображает список NFT.
    /// - Parameter nfts: Массив моделей NFT для отображения.
    func displayNFTs(_ nfts: [NFTItem])

    /// Показывает индикатор загрузки.
    func showLoading()

    /// Скрывает индикатор загрузки.
    func hideLoading()

    /// Отображает сообщение об ошибке.
    /// - Parameter error: Ошибка, возникшая при загрузке или обработке данных.
    func showError(_ error: Error)

    /// Показывает варианты сортировки для списка NFT.
    /// - Parameters:
    ///   - options: Доступные опции сортировки.
    ///   - selectedIndex: Индекс текущей выбранной опции.
    func showSortOptions(_ options: [NFTSortOption], selectedIndex: Int)

    /// Открывает экран с подробной информацией о выбранном NFT.
    /// - Parameter viewController: Экран деталей NFT.
    func showNFTDetails(_ viewController: UIViewController)
}
