//
//  OnboardingModel.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import UIKit

// MARK: - Onboarding Model
final class OnboardingModel {

    // MARK: - Private Properties
    private let slides: [OnboardingSlide]

    // MARK: - Lifecycle
    init() {
        let slideImageNames = [
            "slide1",
            "slide2",
            "slide3"
        ]

        slides = slideImageNames.enumerated().map { index, imageName in
            OnboardingSlide(
                title: OnboardingLocalizationHelper.localizedTitle(for: index),
                subtitle: OnboardingLocalizationHelper.localizedSubtitle(for: index),
                image: UIImage(named: imageName) ?? UIImage(systemName: "photo")!
            )
        }
    }

    // MARK: - Public Methods
    func getSlides() -> [OnboardingSlide] {
        slides
    }
}
