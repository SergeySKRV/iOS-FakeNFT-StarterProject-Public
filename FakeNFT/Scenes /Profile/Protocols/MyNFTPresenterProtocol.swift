//
//  MyNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit

// MARK: - MyNFTPresenterProtocol
protocol MyNFTPresenterProtocol: AnyObject {
    // MARK: - Lifecycle
    func viewDidLoad()
    func viewWillAppear()

    // MARK: - Public Methods
    func sortButtonTapped()
    func sortOptionSelected(_ option: NFTSortOption)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
