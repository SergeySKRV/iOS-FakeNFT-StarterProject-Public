//
//  FavoriteNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

protocol FavoriteNFTPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
