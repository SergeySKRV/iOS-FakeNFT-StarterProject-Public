//
//  FavoriteNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

// MARK: - FavoriteNFTPresenterProtocol

protocol FavoriteNFTPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func handleHeartTap(for nftId: String, isSelected: Bool)
}
