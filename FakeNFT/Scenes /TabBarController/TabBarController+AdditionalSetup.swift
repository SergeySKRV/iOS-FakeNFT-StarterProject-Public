//
//  TabBarController+AdditionalSetup.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 22.09.2025.
//

import UIKit

// MARK: - Additional Setup
extension TabBarController {
    
    // MARK: - Observers
    func setupObservers() {
        // Наблюдатель для изменений количества товаров в корзине
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCartItemCountChange(_:)),
            name: .cartItemCountDidChange,
            object: nil
        )
        
        // Наблюдатель для изменений количества непрочитанных сообщений
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUnreadMessagesCountChange(_:)),
            name: .unreadMessagesCountDidChange,
            object: nil
        )
    }
    
    // MARK: - Notification Handlers
    @objc func handleCartItemCountChange(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        
        // Обновляем badge на вкладке корзины
        updateBadge(for: Tab.cart, count: count) // Явно указываем Tab.cart
    }
    
    @objc func handleUnreadMessagesCountChange(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        
        // Обновляем badge на вкладке профиля
        updateBadge(for: Tab.profile, count: count) // Явно указываем Tab.profile
    }
    
    // MARK: - Badge Update Methods
    private func updateBadge(for tab: Tab, count: Int) { // Принимаем Tab вместо случая enum
        let badgeValue: String?
        
        if count > 0 {
            // Форматируем значение для badge
            if count > 99 {
                badgeValue = "99+"
            } else {
                badgeValue = "\(count)"
            }
        } else {
            badgeValue = nil
        }
        
        // Определяем индекс вкладки на основе переданного Tab
        let index: Int
        switch tab {
        case .profile: index = 0
        case .catalog: index = 1
        case .cart: index = 2
        case .statistics: index = 3
        }
        
        setBadgeValue(badgeValue, at: index)
    }
    
    // Виброотдача при переключении
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
