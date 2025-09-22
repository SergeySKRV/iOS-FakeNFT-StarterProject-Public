//
//  TabBarController+TabBarItemsSetup.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 22.09.2025.
//

import UIKit

// MARK: - TabBar Items Setup
extension TabBarController {
    
    // Установка badgeValue для вкладки
    func setBadgeValue(_ value: String?, at index: Int) {
        guard let tabItems = tabBar.items, index < tabItems.count else {
            print("❌ Неверный индекс для установки badgeValue")
            return
        }
        
        let tabItem = tabItems[index]
        tabItem.badgeValue = value
        
        // Дополнительные настройки badge (iOS 10+)
        if #available(iOS 10.0, *) {
            tabItem.badgeColor = .red
            tabItem.setBadgeTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        }
    }
    
    // Этот метод теперь доступен из основного класса
    func getCartItemsCount() -> Int {
        // TODO: количество предметов в корзине
        return 0
    }
}
