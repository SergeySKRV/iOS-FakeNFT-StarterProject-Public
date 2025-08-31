//
//  Profile.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 30.08.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

