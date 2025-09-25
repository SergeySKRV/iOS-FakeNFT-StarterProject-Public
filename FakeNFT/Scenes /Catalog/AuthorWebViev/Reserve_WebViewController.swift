//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 08.09.2025.
//
/*import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.alpha = 0
        return webView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private var urlString: String
    
    // MARK: - Lifecycle
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
        loadInitialContent()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .yaPrimary
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func loadInitialContent() {
        // Сначала показываем локальную HTML-заглушку с тем же фоном, что и приложение
        let loadingHTML = """
        <!DOCTYPE html>
        <html>
            <head>
                <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
                <style>
                    body {
                        background-color: #F8F8F8;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        height: 100vh;
                        margin: 0;
                        font-family: -apple-system, sans-serif;
                    }
                    .loading {
                        text-align: center;
                        color: #888;
                        font-size: 16px;
                    }
                </style>
            </head>
            <body>
                <div class="loading">Загрузка...</div>
            </body>
        </html>
        """
        
        webView.loadHTMLString(loadingHTML, baseURL: nil)
        activityIndicator.startAnimating()
        
        // Загружаем реальный контент с небольшой задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.loadWebsite()
        }
    }
    
    private func loadWebsite() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Плавно показываем WebView после загрузки контента
        UIView.animate(withDuration: 0.3) {
            webView.alpha = 1
        }
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
        // Все равно показываем WebView, даже если произошла ошибка
        UIView.animate(withDuration: 0.3) {
            webView.alpha = 1
        }
        
        // обработка ошибки
        print("Ошибка загрузки: \(error.localizedDescription)")
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}
/* это код общего веб вью контроллера
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    // MARK: - Properties
    private var urlString: String
    
    // MARK: - Lifecycle
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
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .yaPrimary
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func loadWebsite() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}
*/
*/
