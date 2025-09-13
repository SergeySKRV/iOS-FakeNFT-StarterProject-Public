import UIKit
import ProgressHUD
@preconcurrency import WebKit

final class WebViewController: UIViewController {
    // MARK: private properties
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private var urlString: String
    // MARK: public methods
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebsite()
    }
    // MARK: private methods
    private func setupUI() {
        view.backgroundColor = UIColor.yaSecondary
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .chevronBackward),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = UIColor.yaPrimary
        navigationItem.leftBarButtonItem = backButton
    }
    private func loadWebsite() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
