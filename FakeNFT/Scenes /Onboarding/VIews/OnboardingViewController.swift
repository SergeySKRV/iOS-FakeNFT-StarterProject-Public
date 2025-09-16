//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import UIKit

// MARK: - Onboarding View Controller
final class OnboardingViewController: UIViewController, OnboardingViewProtocol {

    // MARK: - UI Elements
    private lazy var presenter: OnboardingPresenter = {
        OnboardingPresenter(view: self)
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var paginationView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .close), for: .normal)
        button.tintColor = .yaWhiteUniversal
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(OnboardingLocalizationHelper.nextButtonTitle(), for: .normal)
        button.titleLabel?.font = Fonts.sfProBold17
        button.setTitleColor(.yaWhiteUniversal, for: .normal)
        button.backgroundColor = .yaBlackUniversal
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties
    private var slideViews: [SlideView] = []
    private var currentPageIndex = 0
    private var autoScrollTimer: Timer?
    private let autoScrollInterval: TimeInterval = 5.0
    private var isUserInteracting = false

    // MARK: - Simple Pagination Indicators
    private var paginationIndicators: [UIView] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAutoScrollTimer()
        _ = presenter
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScrollTimer()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black

        createSlides()

        setupPagination()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [paginationView, closeButton, nextButton].forEach {
            view.addSubview($0)
        }

        setupConstraints()
    }

    private func createSlides() {
        for _ in 0..<3 {
            let slideView = SlideView()
            slideView.translatesAutoresizingMaskIntoConstraints = false
            slideViews.append(slideView)
            contentView.addSubview(slideView)
        }
    }

    private func setupPagination() {
        for i in 0..<3 {
            let indicator = UIView()
            indicator.backgroundColor = i == 0 ? .white : UIColor.white.withAlphaComponent(0.3)
            indicator.layer.cornerRadius = 4
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.heightAnchor.constraint(equalToConstant: 4).isActive = true

            paginationView.addArrangedSubview(indicator)
            paginationIndicators.append(indicator)
        }
    }

    private func setupConstraints() {
        guard slideViews.count == 3 else { return }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            slideViews[0].topAnchor.constraint(equalTo: contentView.topAnchor),
            slideViews[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            slideViews[0].heightAnchor.constraint(equalTo: contentView.heightAnchor),
            slideViews[0].widthAnchor.constraint(equalTo: view.widthAnchor),

            slideViews[1].topAnchor.constraint(equalTo: contentView.topAnchor),
            slideViews[1].leadingAnchor.constraint(equalTo: slideViews[0].trailingAnchor),
            slideViews[1].heightAnchor.constraint(equalTo: contentView.heightAnchor),
            slideViews[1].widthAnchor.constraint(equalTo: view.widthAnchor),

            slideViews[2].topAnchor.constraint(equalTo: contentView.topAnchor),
            slideViews[2].leadingAnchor.constraint(equalTo: slideViews[1].trailingAnchor),
            slideViews[2].heightAnchor.constraint(equalTo: contentView.heightAnchor),
            slideViews[2].widthAnchor.constraint(equalTo: view.widthAnchor),
            slideViews[2].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            paginationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            paginationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            paginationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            paginationView.heightAnchor.constraint(equalToConstant: 4),

            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42),

            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.widthAnchor.constraint(equalToConstant: 343),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Auto Scroll
    private func startAutoScrollTimer() {
        stopAutoScrollTimer()
        autoScrollTimer = Timer.scheduledTimer(timeInterval: autoScrollInterval, target: self, selector: #selector(autoScrollToNext), userInfo: nil, repeats: true)
    }

    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    // MARK: - Actions
    @objc
    private func autoScrollToNext() {
        guard !isUserInteracting else { return }

        if currentPageIndex < 2 {
            let nextPageIndex = currentPageIndex + 1
            scrollToPage(nextPageIndex)
        }
    }

    @objc
    private func closeTapped() {
        presenter.close()
    }

    @objc
    private func nextButtonTapped() {
        presenter.goToNextScreen()
    }

    private func scrollToPage(_ pageIndex: Int) {
        let clampedPageIndex = max(0, min(2, pageIndex))
        let xOffset = CGFloat(clampedPageIndex) * view.frame.width
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }

    // MARK: - OnboardingViewProtocol
    func showSlide(_ slide: OnboardingSlide, at index: Int) {
        guard index < slideViews.count else { return }
        slideViews[index].configure(with: slide)
    }

    func updateIndicator(position: Int) {
        currentPageIndex = position

        for (i, indicator) in paginationIndicators.enumerated() {
            indicator.backgroundColor = i == position ? .white : UIColor.white.withAlphaComponent(0.3)
        }

        if position == 2 {
            hideCloseButton()
        } else {
            showCloseButton()
        }
    }

    func showNextButton() {
        nextButton.isHidden = false
    }

    func hideNextButton() {
        nextButton.isHidden = true
    }

    func showCloseButton() {
        closeButton.isHidden = false
    }

    func hideCloseButton() {
        closeButton.isHidden = true
    }

    func dismiss() {
        goToMainApp()
    }

    func goToNextScreen() {
        stopAutoScrollTimer()
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        goToMainApp()
    }

    private func goToMainApp() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }

        let tabBarController = TabBarController()
        tabBarController.servicesAssembly = sceneDelegate.servicesAssembly

        UIView.transition(with: sceneDelegate.window!, duration: 0.2, options: .transitionCrossDissolve, animations: {
            sceneDelegate.window?.rootViewController = tabBarController
        })
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserInteracting = true
        stopAutoScrollTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isUserInteracting = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startAutoScrollTimer()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        let clampedPageIndex = max(0, min(2, pageIndex))
        updateIndicator(position: clampedPageIndex)

        if clampedPageIndex == 2 {
            showNextButton()
        } else {
            hideNextButton()
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetIndex = Int(targetContentOffset.pointee.x / view.frame.width)
        let clampedTargetIndex = max(0, min(2, targetIndex))
        targetContentOffset.pointee.x = CGFloat(clampedTargetIndex) * view.frame.width
    }
}
