import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "catalogImg"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "cartImg"),
        tag: 1
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(named: "statisticsImg"),
        tag: 2
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "profileImg"),
        tag: 3
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let profileController = createPlaceholderController(title: "Профиль")
        profileController.tabBarItem = profileTabBarItem
        
        let cartService = CartService()
        let cartController = CartViewController()
        let cartPresenter = CartPresenter(view: cartController, cartService: cartService)
        cartController.presenter = cartPresenter
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        cartNavigationController.tabBarItem = cartTabBarItem
        
        let statisticsController = createPlaceholderController(title: "Статистика")
        statisticsController.tabBarItem = statisticsTabBarItem
        
        
        viewControllers = [
            profileController,
            catalogController,
            cartNavigationController,
            statisticsController
        ]
        
        view.backgroundColor = .systemBackground
    }
    
    private func createPlaceholderController(title: String) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "\(title) в разработке"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor)
        ])
        
        return controller
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "ypBlack")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(named: "ypBlack") ?? .black
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = .yaBlueUniversal
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.yaBlueUniversal
        ]
        
        appearance.backgroundColor = .background
        
        UITabBar.appearance().standardAppearance = appearance
    }
}
