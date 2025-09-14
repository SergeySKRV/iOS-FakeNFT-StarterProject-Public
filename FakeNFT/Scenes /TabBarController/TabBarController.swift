import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {
    // MARK: - Properties
    var servicesAssembly: ServicesAssembly!

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupUI()
    }

    // MARK: - Private Methods
    private func setupViewControllers() {
        guard let servicesAssembly = self.servicesAssembly else {
            assertionFailure("ServicesAssembly is not set")
            return
        }

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        let profileController = ProfileViewController()
        profileController.tabBarItem = profileTabBarItem
        profileController.servicesAssembly = servicesAssembly

        viewControllers = [profileController, catalogController]
    }

    private func setupUI() {
        view.backgroundColor = .yaSecondary
        tabBar.tintColor = .yaBlueUniversal
        tabBar.unselectedItemTintColor = .yaPrimary
    }
}
