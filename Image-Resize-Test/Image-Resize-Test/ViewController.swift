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

  private let resizeMethodSegmentControl: UISegmentedControl = {
    let items = ["방식 1", "방식 2", "방식 3"]
    let segmentControl = UISegmentedControl(items: items)
    segmentControl.selectedSegmentIndex = 0
    return segmentControl
  }()

  private let resizeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("리사이징 실행", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.backgroundColor = .systemGreen
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.isEnabled = false
    return button
  }()

  private let resultImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .systemGray6
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    return imageView
  }()

  private let performanceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .darkGray
    label.text = "실행 시간: -"
    return label
  }()

  private let sizeComparisonLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .darkGray
    label.text = "용량 비교: -"
    label.numberOfLines = 0
    return label
  }()

  private var originalImageSize = 0


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
    view.addSubview(resizeMethodSegmentControl)
    view.addSubview(resizeButton)
    view.addSubview(resultImageView)
    view.addSubview(performanceLabel)
    view.addSubview(sizeComparisonLabel)

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

    resizeMethodSegmentControl.snp.makeConstraints { make in
      make.top.equalTo(selectImageButton.snp.bottom).offset(30)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(40)
    }

    resizeButton.snp.makeConstraints { make in
      make.top.equalTo(resizeMethodSegmentControl.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
      make.width.equalTo(150)
      make.height.equalTo(44)
    }

    resultImageView.snp.makeConstraints { make in
      make.top.equalTo(resizeButton.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(200)
    }

    performanceLabel.snp.makeConstraints { make in
      make.top.equalTo(resultImageView.snp.bottom).offset(10)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(30)
    }

    sizeComparisonLabel.snp.makeConstraints { make in
      make.top.equalTo(performanceLabel.snp.bottom).offset(5)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(40)
    }
  }


  // MARK: - Actions

  private func configureActions() {
    selectImageButton.addTarget(
      self,
      action: #selector(selectImageButtonTapped),
      for: .touchUpInside
    )

    resizeButton.addTarget(
      self,
      action: #selector(resizeButtonTapped),
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

  @objc
  private func resizeButtonTapped() {
    guard let originalImage = selectedImageView.image else { return }

    // 이미지 리사이징 메서드는 추후 구현
    let selectedMethod = resizeMethodSegmentControl.selectedSegmentIndex
    performImageResize(image: originalImage, method: selectedMethod)
  }

  private func performImageResize(image: UIImage, method: Int) {
    // 성능 측정 시작
    let startTime = CFAbsoluteTimeGetCurrent()

    // 리사이징 결과 이미지
    var resizedImage: UIImage?

    switch method {
    case 0:
      // 방식 1: UIGraphicsImageRenderer (추후 구현)
      resizedImage = image
    case 1:
      // 방식 2: UIGraphicsBeginImageContextWithOptions (추후 구현)
      resizedImage = image
    case 2:
      // 방식 3: CoreImage (추후 구현)
      resizedImage = image
    default:
      resizedImage = image
    }

    // 성능 측정 종료
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime

    // UI 업데이트
    resultImageView.image = resizedImage
    performanceLabel.text = String(format: "실행 시간: %.4f초", timeElapsed)

    // 용량 비교
    if let resizedImage {
      let resizedImageSize = getImageSize(image: resizedImage)
      updateSizeComparisonLabel(originalSize: originalImageSize, resizedSize: resizedImageSize)
    }
  }


  // MARK: - Helpers

  private func getImageSize(image: UIImage) -> Int {
    guard let imageData = image.jpegData(compressionQuality: 1.0) else { return 0 }
    return imageData.count
  }

  private func updateSizeComparisonLabel(originalSize: Int, resizedSize: Int) {
    let originalSizeKB = Double(originalSize) / 1024.0
    let resizedSizeKB = Double(resizedSize) / 1024.0
    let reductionPercentage = 100.0 - ((resizedSizeKB / originalSizeKB) * 100.0)

    let sizeText = String(
      format: "원본: %.1f KB\n리사이징: %.1f KB (%.1f%% 감소)",
      originalSizeKB,
      resizedSizeKB,
      reductionPercentage
    )
    sizeComparisonLabel.text = sizeText
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
      resizeButton.isEnabled = true

      // 원본 이미지 용량 저장
      originalImageSize = getImageSize(image: originalImage)
      sizeComparisonLabel.text = String(format: "원본: %.1f KB", Double(originalImageSize) / 1024.0)
    }

    dismiss(animated: true)
  }
}

