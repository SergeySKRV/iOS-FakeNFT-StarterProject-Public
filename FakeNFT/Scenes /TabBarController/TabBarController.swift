import UIKit

final class TabBarController: UITabBarController {

    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewControllers()
    }
       
    private func setUpViewControllers() {
        let networkClient = DefaultNetworkClient()
        let catalogService = CatalogService(networkClient: networkClient)
        let sortStorage = SortStorage()
        
        let catalogPresenter = CatalogPresenter(catalogService: catalogService, sortStorage: sortStorage)
        /*
        let catalogVC = CatalogViewController(
            servicesAssembly: servicesAssembly
        )
        */
        let catalogVC = CatalogViewController(
            presenter: catalogPresenter
        )
        
        let shoppingCartVC = ShoppingCartViewController(
            servicesAssembly: servicesAssembly
        )
        let profileVC = ProfileViewController(
            servicesAssembly: servicesAssembly
        )
        
        let statisticVC = StatisticViewController(
            servicesAssembly: servicesAssembly
        )
        
        
        catalogVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab.catalog", comment: ""),
                                                        image: UIImage(named: "catalogNoActive"),
                                                        selectedImage: UIImage(named: "catalogActive"))
        shoppingCartVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab.cart", comment: ""),
                                                      image: UIImage(named: "basketNoActive"),
                                                      selectedImage: UIImage(named: "basketActive"))
        profileVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab.profile", comment: ""),
                                                      image: UIImage(named: "profileNoActive"),
                                                      selectedImage: UIImage(named: "profileActive"))
        statisticVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Tab.statistic", comment: ""),
                                                      image: UIImage(named: "tabStatistic"),
                                                      selectedImage: UIImage(named: "tabStatistic"))
        
        
        viewControllers = [profileVC, catalogVC, shoppingCartVC, statisticVC]
    }
}
