import UIKit

final class TabBarController: UITabBarController {
    // var servicesAssembly: ServicesAssembly!
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "ProfileIcon"),
       tag: 0
    )
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "CatalogIcon"),
        tag: 1
    )
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "CartIcon"),
        tag: 2
    )
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "StatisticsIcon"),
        tag: 3
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yaSecondary
        tabBar.tintColor = UIColor.yaBlueUniversal
        tabBar.unselectedItemTintColor = UIColor.yaPrimary
        let profileController = ProfileViewController()
        let catalogController = CatalogViewController()
        let cartController = CartViewController()
        // TODO:  Вернуть обратно перед ревью let statisticsController = StatisticsViewController()
        let statisticsController = StatisticsCollectionViewController()
        profileController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        cartController.tabBarItem = cartTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem
        viewControllers = [profileController, catalogController, cartController, statisticsController]
    }
}
