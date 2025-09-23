import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        if viewControllers?.isEmpty ?? true {
            setupViewControllers()
        }
    }

    // MARK: - Private Methods
    private func setupViewControllers() {
        // Catalog зависимости
        let networkClient = DefaultNetworkClient()
        let catalogStorage = CatalogStorage()
        let catalogService = CatalogService(
            networkClient: networkClient,
            catalogStorage: catalogStorage
        )
        let sortStorage = SortStorage()
        let catalogPresenter = CatalogPresenter(
            catalogService: catalogService,
            sortStorage: sortStorage
        )

        // Профиль
        let profileController = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileController)
        profileNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(resource: .profileIcon),
            tag: 0
        )

        // Каталог
        let catalogController = CatalogViewController(presenter: catalogPresenter)
        let catalogNav = UINavigationController(rootViewController: catalogController)
        catalogNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(resource: .catalogIcon),
            tag: 1
        )

        // Корзина
        let cartController = ShoppingCartViewController()
        let cartNav = UINavigationController(rootViewController: cartController)
        cartNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(resource: .cartIcon),
            tag: 2
        )

        // Статистика
        let statisticsController = StatisticViewController()
        let statisticsNav = UINavigationController(rootViewController: statisticsController)
        statisticsNav.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistics", comment: ""),
            image: UIImage(resource: .statisticsIcon),
            tag: 3
        )

        // Устанавливаем контроллеры
        viewControllers = [profileNav, catalogNav, cartNav, statisticsNav]
    }

    private func setupUI() {
        view.backgroundColor = .yaSecondary

        // Активный цвет (иконка + текст)
        tabBar.tintColor = .yaBlueUniversal

        // Неактивный цвет
        tabBar.unselectedItemTintColor = .yaPrimary

        // Цвет фона таббара
        tabBar.backgroundColor = .yaSecondary
        tabBar.isTranslucent = false
    }
}
