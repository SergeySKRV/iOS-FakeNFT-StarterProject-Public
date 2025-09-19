//
//  OnboardingViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import Foundation

// MARK: - OnboardingViewProtocol

/// Контракт между Presenter и View для экрана онбординга.
///
/// View отвечает только за отображение и навигацию,
/// всю бизнес-логику управляет `OnboardingPresenter`.
protocol OnboardingViewProtocol: AnyObject {
    /// Отображает слайд онбординга на указанной позиции.
    /// - Parameters:
    ///   - slide: Данные слайда (`OnboardingSlide`).
    ///   - index: Индекс позиции слайда.
    func showSlide(_ slide: OnboardingSlide, at index: Int)

    /// Обновляет индикатор текущей страницы (пагинацию).
    /// - Parameter position: Индекс текущего слайда.
    func updateIndicator(position: Int)

    /// Показывает кнопку «Далее».
    func showNextButton()

    /// Скрывает кнопку «Далее».
    func hideNextButton()

    /// Показывает кнопку «Закрыть».
    func showCloseButton()

    /// Скрывает кнопку «Закрыть».
    func hideCloseButton()

    /// Закрывает экран онбординга.
    func dismiss()

    /// Переходит к следующему экрану после завершения онбординга.
    func goToNextScreen()
}
