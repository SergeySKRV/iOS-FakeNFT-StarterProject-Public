//
//  Protocols.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 13.09.2025.
//

import Foundation

// MARK: - Presenter Output Contract
protocol ProfilePresenterOutput: AnyObject {
    func showWebViewController(urlString: String)
}
