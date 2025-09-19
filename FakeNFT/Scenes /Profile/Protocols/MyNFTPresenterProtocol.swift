//
//  MyNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit

// MARK: - MyNFTPresenterProtocol

/// Контракт Presenter’а для экрана «Мои NFT».
protocol MyNFTPresenterProtocol: AnyObject {
    // MARK: - Lifecycle

    /// Вызывается, когда View загрузилась.
    func viewDidLoad()

    /// Вызывается перед тем, как View появится на экране.
    func viewWillAppear()

    // MARK: - User Actions

    /// Обработка нажатия на кнопку сортировки.
    func sortButtonTapped()

    /// Обработка выбора варианта сортировки.
    /// - Parameter option: Выбранная опция сортировки.
    func sortOptionSelected(_ option: NFTSortOption)

    /// Обработка выбора NFT в списке.
    /// - Parameters:
    ///   - tableView: Таблица, содержащая список NFT.
    ///   - indexPath: Индекс выбранного элемента.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)

    // MARK: - Heart Tap Handling

    /// Обработка нажатия на иконку «сердце» для добавления/удаления NFT из избранного.
    /// - Parameters:
    ///   - nftId: Идентификатор NFT.
    ///   - isSelected: Текущее состояние (true — NFT уже в избранном).
    func handleHeartTap(for nftId: String, isSelected: Bool)
}
