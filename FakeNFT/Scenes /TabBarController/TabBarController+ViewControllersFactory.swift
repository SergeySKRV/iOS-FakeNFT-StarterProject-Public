//
//  TabBarController+ViewControllersFactory.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 22.09.2025.
//

import UIKit

// MARK: - ViewControllers Factory
extension TabBarController {
    
    func setUpViewControllers() {
        
        let networkClient = DefaultNetworkClient()
        let catalogStorage = CatalogStorage()
        let catalogService = CatalogService(networkClient: networkClient, catalogStorage: catalogStorage)
        let sortStorage = SortStorage()
        let catalogPresenter = CatalogPresenter(catalogService: catalogService, sortStorage: sortStorage)
        
        // Создаем контроллеры для каждой вкладки
        let profileVC = ProfileViewController()
        let catalogVC = CatalogViewController(presenter: catalogPresenter)
        let shoppingCartVC = ShoppingCartViewController()
        let statisticVC = StatisticViewController()
        
        // Обертываем каждый контроллер в NavigationController
        // Явно указываем тип Tab для каждого случая
        let catalogNav = wrapInNavigationController(catalogVC, tab: Tab.catalog)
        let cartNav = wrapInNavigationController(shoppingCartVC, tab: Tab.cart)
        let profileNav = wrapInNavigationController(profileVC, tab: Tab.profile)
        let statisticsNav = wrapInNavigationController(statisticVC, tab: Tab.statistics)
        
        // Устанавливаем контроллеры в таббар
        viewControllers = [profileNav, catalogNav, cartNav, statisticsNav]
        
        // Устанавливаем начальную вкладку
        selectedIndex = 0
    }
    
    func setupDelegate() {
        // delegate = self
    }
    
    // Убираем private - делаем метод доступным внутри модуля
    func wrapInNavigationController(_ controller: UIViewController, tab: Tab) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem = createTabBarItem(for: tab)
        
        return navController
    }
    
    // Также делаем доступным
    func createTabBarItem(for tab: Tab) -> UITabBarItem {
        return UITabBarItem(
            title: NSLocalizedString(tab.titleKey, comment: ""),
            image: UIImage(named: tab.inactiveImageName),
            selectedImage: UIImage(named: tab.activeImageName)
        )
    }
}
