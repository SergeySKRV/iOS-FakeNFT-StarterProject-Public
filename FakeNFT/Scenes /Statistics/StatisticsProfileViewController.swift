import UIKit

final class StatisticsProfileViewController: UIViewController {
    private let navigationBar =  {
        let navigationBar = UINavigationBar()
        navigationBar.backgroundColor = UIColor.yaBlueUniversal
        return navigationBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    private func configureView() {
        view.addSubview(navigationBar)
    }
}
