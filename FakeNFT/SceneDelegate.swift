import UIKit

<<<<<<< HEAD
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - UI Properties
    var window: UIWindow?
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    // MARK: - Lifecycle
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let shouldShowOnboarding = !UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.hasSeenOnboarding)

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

    func sceneDidBecomeActive(_ scene: UIScene) {
        ReviewManager.incrementLaunchCountAndAskIfNeeded()
=======
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Lifecycle
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
>>>>>>> caffbd545bc9f65f8285d216a2fea4663b2fd6df
    }
}
