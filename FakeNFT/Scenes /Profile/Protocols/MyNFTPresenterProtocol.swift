//
//  MyNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit

protocol MyNFTPresenterProtocol: AnyObject {
    init(view: MyNFTViewProtocol, nftService: NftService)
    
    func viewDidLoad()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
