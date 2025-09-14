import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let shouldShowOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

        if shouldShowOnboarding {
            let onboardingVC = OnboardingViewController()
            window?.rootViewController = onboardingVC
        } else {
            let tabBarController = TabBarController()
            tabBarController.servicesAssembly = servicesAssembly
            window?.rootViewController = tabBarController
        }
        window?.makeKeyAndVisible()
    }
}
