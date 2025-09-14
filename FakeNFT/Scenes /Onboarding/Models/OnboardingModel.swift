//
//  OnboardingModel.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import UIKit

// MARK: - Onboarding Model
final class OnboardingModel {
    // MARK: - UI Properties
    private let slides: [OnboardingSlide]

    // MARK: - Lifecycle
    init() {
        let slide1 = OnboardingSlide(
            title: NSLocalizedString("Onboarding.slide1.title", comment: "First slide title"),
            subtitle: NSLocalizedString("Onboarding.slide1.subtitle", comment: "First slide subtitle"),
            image: UIImage(resource: .slide1)
        )

        let slide2 = OnboardingSlide(
            title: NSLocalizedString("Onboarding.slide2.title", comment: "Second slide title"),
            subtitle: NSLocalizedString("Onboarding.slide2.subtitle", comment: "Second slide subtitle"),
            image: UIImage(resource: .slide2)
        )

        let slide3 = OnboardingSlide(
            title: NSLocalizedString("Onboarding.slide3.title", comment: "Third slide title"),
            subtitle: NSLocalizedString("Onboarding.slide3.subtitle", comment: "Third slide subtitle"),
            image: UIImage(resource: .slide3)
        )

        slides = [slide1, slide2, slide3]
    }

    // MARK: - Public Methods
    func getSlides() -> [OnboardingSlide] {
        slides
    }
}
