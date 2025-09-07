import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setUpViewControllers()
        setupDelegate()
        setupObservers()
        setBadgeValue(getCartItemsCount() > 0 ? "\(getCartItemsCount())" : nil, at: 2)
    }
    
    deinit {
        // Важно: удаляем наблюдатели при деинициализации
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: -  Appearance Setup

extension TabBarController {
    
    private func setupAppearance() {
        // Настройка цветов таббара
        tabBar.tintColor = UIColor(named: "blueUniversal") ?? .systemBlue
        tabBar.unselectedItemTintColor = UIColor(named: "blackDayNight") ?? .yaBlackUniversal
        
        // Настройка фона
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = true
        /* с этим кодом не чернит иконки :(
         // Современная настройка для iOS 15+
         if #available(iOS 15.0, *) {
         let appearance = UITabBarAppearance()
         appearance.configureWithOpaqueBackground()
         appearance.backgroundColor = .systemBackground
         
         // Настройка текста
         appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
         .foregroundColor: UIColor(named: "blueUniversal") ?? .systemBlue,
         .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
         ]
         
         appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
         .foregroundColor: UIColor(named: "blackDayNight") ?? .yaBlackUniversal,
         .font: UIFont.systemFont(ofSize: 10, weight: .regular)
         ]
         
         tabBar.standardAppearance = appearance
         tabBar.scrollEdgeAppearance = appearance
         }
         */
    }
}

// MARK: - ViewControllers Factory

extension TabBarController {
    
    private func setUpViewControllers() {
        
        let networkClient = DefaultNetworkClient()
        let catalogService = CatalogService(networkClient: networkClient)
        let sortStorage = SortStorage()
        let catalogPresenter = CatalogPresenter(catalogService: catalogService, sortStorage: sortStorage)
        
        // Создаем контроллеры для каждой вкладки
        let profileVC = ProfileViewController()
        let catalogVC = CatalogViewController(
            presenter: catalogPresenter
        )
        let shoppingCartVC = ShoppingCartViewController()
        let statisticVC = StatisticViewController()
        
        // 2. Обертываем каждый контроллер в NavigationController
        let catalogNav = wrapInNavigationController(catalogVC, tab: .catalog)
        let cartNav = wrapInNavigationController(shoppingCartVC, tab: .cart)
        let profileNav = wrapInNavigationController(profileVC, tab: .profile)
        let statisticsNav = wrapInNavigationController(statisticVC, tab: .statistics)
        
        // 3. Устанавливаем контроллеры в таббар
        viewControllers = [profileNav, catalogNav, cartNav, statisticsNav]
        
        // 4. Устанавливаем начальную вкладку
        selectedIndex = 0
    }
    
    private func setupDelegate() {
        //delegate = self
    }
}

// MARK: - TabBar Items Setup

extension TabBarController {
    
    private func wrapInNavigationController(_ controller: UIViewController, tab: Tab) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem = createTabBarItem(for: tab)
        
        return navController
    }
    
    private func createTabBarItem(for tab: Tab) -> UITabBarItem {
        
        return UITabBarItem(
            title: NSLocalizedString(tab.titleKey, comment: ""),
            image: UIImage(named: tab.inactiveImageName),
            selectedImage: UIImage(named: tab.activeImageName)
        )
    }
    
    // Установка badgeValue для кор вкладки
    func setBadgeValue(_ value: String?, at index: Int) {
        guard let tabItems = tabBar.items, index < tabItems.count else {
            print("❌ Неверный индекс для установки badgeValue")
            return
        }
        
        let tabItem = tabItems[index]
        tabItem.badgeValue = value
        
        // Дополнительные настройки badge (iOS 10+)
        if #available(iOS 10.0, *) {
            tabItem.badgeColor = .red // Цвет фона badge
            tabItem.setBadgeTextAttributes(
                [.foregroundColor: UIColor.white], // Цвет текста
                for: .normal
            )
        }
    }
    
    private func setTabBarItem(
        for viewController: UIViewController,
        title: String,
        imageName: String,
        selectedImageName: String,
        badgeValue: String? = nil
    ) {
        let image = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: selectedImageName)
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: selectedImage
        )
        viewController.tabBarItem.badgeValue = badgeValue
        viewController.tabBarItem.badgeColor = .systemRed
    }
    
    private func getCartItemsCount() -> Int {
        // TODO: количество предметов в корзине
        return 5
    }
}

// MARK: - Additional Setup

extension TabBarController {
    
    // MARK: - Observers
    private func setupObservers() {
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
    @objc private func handleCartItemCountChange(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        
        // Обновляем badge на вкладке корзины
        updateBadge(for: .cart, count: count)
    }
    
    @objc private func handleUnreadMessagesCountChange(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        
        // Обновляем badge на вкладке профиля (или другой, где показываются уведомления)
        updateBadge(for: .profile, count: count)
    }
    
    // MARK: - Badge Update Methods
    private func updateBadge(for tab: Tab, count: Int) {
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
        setBadgeValue(badgeValue, at: 2)
    }
    
    // Виброотдача при переключении
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
// MARK: - Tab Enum
private enum Tab {
    case catalog
    case cart
    case profile
    case statistics
    
    var titleKey: String {
        switch self {
        case .catalog: return "Tab.catalog"
        case .cart: return "Tab.cart"
        case .profile: return "Tab.profile"
        case .statistics: return "Tab.statistics"
        }
    }
    
    var inactiveImageName: String {
        switch self {
        case .catalog: return "catalogNoActive"
        case .cart: return "basketNoActive"
        case .profile: return "profileNoActive"
        case .statistics: return "tabStatistic"
        }
    }
    
    var activeImageName: String {
        switch self {
        case .catalog: return "catalogActive"
        case .cart: return "basketActive"
        case .profile: return "profileActive"
        case .statistics: return "tabStatistic"
        }
    }
}

extension Notification.Name {
    static let cartItemCountDidChange = Notification.Name("cartItemCountDidChange")
    static let unreadMessagesCountDidChange = Notification.Name("unreadMessagesCountDidChange")
}

