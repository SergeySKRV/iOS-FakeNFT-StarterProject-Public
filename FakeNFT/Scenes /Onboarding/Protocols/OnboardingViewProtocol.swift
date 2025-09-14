//
//  OnboardingViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import Foundation

// MARK: - Onboarding View Protocol
protocol OnboardingViewProtocol: AnyObject {
    func showSlide(_ slide: OnboardingSlide, at index: Int)
    func updateIndicator(position: Int)
    func showNextButton()
    func hideNextButton()
    func showCloseButton()
    func hideCloseButton()
    func dismiss()
    func goToNextScreen()
}
