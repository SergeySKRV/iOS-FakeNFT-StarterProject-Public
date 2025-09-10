//
//  MyNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit

protocol MyNFTPresenterProtocol: AnyObject {
    init(view: MyNFTViewProtocol, nftService: NftService, servicesAssembly: ServicesAssembly)
    
    func viewDidLoad()
    func viewWillAppear()
    func sortButtonTapped()
    func sortOptionSelected(_ option: NFTSortOption)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
