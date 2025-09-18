//
//  OnboardingPresenter.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import UIKit

// MARK: - Onboarding Presenter

final class OnboardingPresenter {
    // MARK: - UI Properties
    weak var view: OnboardingViewProtocol?
    private let model: OnboardingModel
    private var totalSlides: Int {
        model.getSlides().count
    }

    // MARK: - Properties
    private var currentIndex = 0

    // MARK: - Lifecycle
    init(view: OnboardingViewProtocol) {
        self.view = view
        self.model = OnboardingModel()
        loadAllSlides()
    }

    // MARK: - Public Methods
    func nextSlide() {
        guard currentIndex < totalSlides - 1 else { return }
        currentIndex += 1
        view?.updateIndicator(position: currentIndex)
        if currentIndex == totalSlides - 1 {
            view?.showNextButton()
        }
    }

    func previousSlide() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        view?.updateIndicator(position: currentIndex)
        view?.hideNextButton()
    }

    func close() {
        UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.hasSeenOnboarding)
        view?.dismiss()
    }

    func goToNextScreen() {
        UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.hasSeenOnboarding)
        view?.goToNextScreen()
    }

    // MARK: - Private Methods
    private func loadAllSlides() {
        let slides = model.getSlides()

        for (index, slide) in slides.enumerated() where index < 3 {
            view?.showSlide(slide, at: index)
        }

        view?.updateIndicator(position: 0)
        view?.hideNextButton()
        view?.showCloseButton()
    }
}
