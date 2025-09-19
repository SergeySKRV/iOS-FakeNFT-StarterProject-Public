//
//  FavoriteNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

// MARK: - FavoriteNFTPresenterProtocol

/// Контракт Presenter’а для экрана «Избранные NFT».
protocol FavoriteNFTPresenterProtocol: AnyObject {
    // MARK: - Lifecycle

    /// Вызывается, когда View загрузилась.
    func viewDidLoad()

    /// Вызывается перед тем, как View появится на экране.
    func viewWillAppear()

    // MARK: - Collection View Handling

    /// Обработка выбора элемента коллекции.
    /// - Parameters:
    ///   - collectionView: Коллекция, содержащая список избранных NFT.
    ///   - indexPath: Индекс выбранного элемента.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)

    // MARK: - Heart Tap Handling

    /// Обработка нажатия на иконку «сердце» для добавления/удаления NFT из избранного.
    /// - Parameters:
    ///   - nftId: Идентификатор NFT.
    ///   - isSelected: Текущее состояние (true — NFT уже в избранном).
    func handleHeartTap(for nftId: String, isSelected: Bool)
}
