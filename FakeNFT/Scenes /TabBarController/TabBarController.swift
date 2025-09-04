import UIKit

final class TabBarController: UITabBarController {
    
    init() {
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewControllers()
        setupTabBarAppearance()
    }
    
    private  func setupTabBarAppearance() {
        // Базовые настройки цветов
        tabBar.tintColor = UIColor(named: "blueUniversal") ?? .systemBlue
        tabBar.unselectedItemTintColor = UIColor(named: "blackDayNight") ?? .yaBlackUniversal
        // Дополнительные настройки
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = true
    }
    
    private func setUpViewControllers() {
        let networkClient = DefaultNetworkClient()
        let catalogService = CatalogService(networkClient: networkClient)
        let sortStorage = SortStorage()
        
        let catalogPresenter = CatalogPresenter(catalogService: catalogService, sortStorage: sortStorage)
        
        let catalogVC = CatalogViewController(
            presenter: catalogPresenter
        )
        
        let shoppingCartVC = ShoppingCartViewController()
        let profileVC = ProfileViewController()
        
        let statisticVC = StatisticViewController()
        
        
        catalogVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(named: "catalogNoActive"),
            selectedImage: UIImage(named: "catalogActive")
        )
        
        shoppingCartVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(named: "basketNoActive"),
            selectedImage: UIImage(named: "basketActive")
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(named: "profileNoActive"),
            selectedImage: UIImage(named: "profileActive")
        )
        
        statisticVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistic", comment: ""),
            image: UIImage(named: "tabStatistic"),
            selectedImage: UIImage(named: "tabStatistic")
        )
        
        viewControllers = [profileVC, catalogVC, shoppingCartVC, statisticVC]
    }
}
