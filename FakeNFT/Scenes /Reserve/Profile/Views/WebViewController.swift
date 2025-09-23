import UIKit
import WebKit

// MARK: - WebViewController
final class WebViewController: UIViewController {
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()

    // MARK: - Loading Indicator
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .yaBlueUniversal
        progressView.trackTintColor = .clear
        progressView.isHidden = true
        return progressView
    }()

    // MARK: - Properties
    private var urlString: String
    private var progressObservation: NSKeyValueObservation?

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
        setupKVO()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .yaSecondary

        view.addSubview(webView)
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
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

    private func setupKVO() {
        progressObservation = webView.observe(\.estimatedProgress) { [weak self] _, _ in
            self?.updateProgress()
        }
    }

    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }

    // MARK: - Progress Methods
    private func updateProgress() {
        let progress = Float(webView.estimatedProgress)
        if !progressView.isHidden {
            progressView.setProgress(progress, animated: true)
        }

        if webView.estimatedProgress >= 1.0 {
            hideProgressIndicator()
        }
    }

    private func showProgressIndicator() {
        progressView.isHidden = false
        progressView.setProgress(0.0, animated: false)
    }

    private func hideProgressIndicator() {
        progressView.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.progressView.isHidden = true
            self.progressView.setProgress(0.0, animated: false)
        }
    }

    deinit {
        progressObservation = nil
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressIndicator()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hideProgressIndicator()
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressIndicator()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideProgressIndicator()
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        hideProgressIndicator()
    }
}
