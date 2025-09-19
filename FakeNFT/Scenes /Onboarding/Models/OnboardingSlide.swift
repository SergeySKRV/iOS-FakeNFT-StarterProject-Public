//
//  OnboardingItem.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import UIKit

// MARK: - OnboardingSlide

/// Модель слайда для онбординга.
///
/// Содержит заголовок, подзаголовок и изображение,
/// отображаемые на экране приветствия.
struct OnboardingSlide {
    /// Заголовок слайда.
    let title: String

    /// Подзаголовок слайда (дополнительное описание).
    let subtitle: String

    /// Изображение, отображаемое на слайде.
    let image: UIImage
}
