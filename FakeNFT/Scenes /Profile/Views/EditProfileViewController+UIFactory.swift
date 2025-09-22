//
//  EditProfileViewController+UIFactory.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 19.09.2025.
//

import UIKit

// MARK: - UI Factory
extension EditProfileViewController {
    func makeProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .placeholderAvatar)
        return imageView
    }

    func makeCameraButton() -> UIButton {
        let button = UIButton(type: .custom)
        let cameraImage = UIImage(resource: .cameraPic).withRenderingMode(.alwaysTemplate)
        button.setImage(cameraImage, for: .normal)
        button.tintColor = .yaPrimary
        button.backgroundColor = .yaLightGray
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }

    func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold22
        label.textColor = .yaPrimary
        label.text = NSLocalizedString("EditProfile.nameLabel", comment: "")
        return label
    }

    func makeNameTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .yaLightGray
        textField.layer.cornerRadius = 12
        textField.font = Fonts.sfProRegular17
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }

    func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold22
        label.textColor = .yaPrimary
        label.text = NSLocalizedString("EditProfile.descriptionLabel", comment: "")
        return label
    }

    func makeDescriptionTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .yaLightGray
        textView.layer.cornerRadius = 12
        textView.font = Fonts.sfProRegular17
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        return textView
    }

    func makeWebsiteLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold22
        label.textColor = .yaPrimary
        label.text = NSLocalizedString("EditProfile.websiteLabel", comment: "")
        return label
    }

    func makeWebsiteTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .yaLightGray
        textField.layer.cornerRadius = 12
        textField.font = Fonts.sfProRegular17
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }

    func makeSaveButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("EditProfile.save", comment: ""), for: .normal)
        button.titleLabel?.font = Fonts.sfProBold17
        button.setTitleColor(.yaSecondary, for: .normal)
        button.backgroundColor = .yaPrimary
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
