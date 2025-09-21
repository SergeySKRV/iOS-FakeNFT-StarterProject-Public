import Foundation

<<<<<<< HEAD
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
=======
// MARK: - App Constants
enum AppConstants {

    // MARK: - User Defaults Keys
    enum UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }

    // MARK: - Onboarding
    enum Onboarding {
        static let autoScrollInterval: TimeInterval = 5.0
        static let slideCount = 3
>>>>>>> caffbd545bc9f65f8285d216a2fea4663b2fd6df
    }
}
