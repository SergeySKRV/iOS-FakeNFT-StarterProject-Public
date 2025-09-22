//
//  ExtentionsTabBarVC.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 22.09.2025.
//

import UIKit

// MARK: - Appearance Setup
extension TabBarController {
    
    func setupAppearance() {
        // Настройка цветов таббара
        tabBar.tintColor = UIColor(named: "blueUniversal") ?? .systemBlue
        tabBar.unselectedItemTintColor = UIColor(named: "blackDayNight") ?? .yaBlackUniversal
        
        // Настройка фона
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = true
    }
}
