//
//  ViewController.swift
//  Image-Resize-Test
//
//  Created by Aiden.lee on 3/11/25.
//

import UIKit

import SnapKit

class ViewController: UIViewController {


  // MARK: - Properties

  private let selectImageButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("이미지 선택", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    return button
  }()

  private var selectedImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .systemGray6
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    return imageView
  }()


  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureActions()
  }


  // MARK: - UI Setup

  private func setupUI() {
    view.backgroundColor = .systemBackground

    view.addSubview(selectedImageView)
    view.addSubview(selectImageButton)

    selectedImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(200)
    }

    selectImageButton.snp.makeConstraints { make in
      make.top.equalTo(selectedImageView.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
      make.width.equalTo(150)
      make.height.equalTo(44)
    }
  }


  // MARK: - Actions

  private func configureActions() {
    selectImageButton.addTarget(
      self,
      action: #selector(selectImageButtonTapped),
      for: .touchUpInside
    )
  }

  @objc
  private func selectImageButtonTapped() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true)
  }
}


// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    if let originalImage = info[.originalImage] as? UIImage {
      selectedImageView.image = originalImage
    }

    dismiss(animated: true)
  }
}

