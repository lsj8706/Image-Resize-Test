//
//  ViewController.swift
//  Image-Resize-Test
//
//  Created by Aiden.lee on 3/11/25.
//

import UIKit

import SnapKit
import RxSwift
//import Agrume

class ViewController: UIViewController {


  // MARK: - UI

  private var selectedImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .systemGray6
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    imageView.isUserInteractionEnabled = true
    imageView.image = UIImage(systemName: "plus")
    imageView.tintColor = .systemGray4
    return imageView
  }()

  private let resizeMethodSegmentControl: UISegmentedControl = {
    let items = ImageResizeType.allCases.map { $0.title }
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
    imageView.isUserInteractionEnabled = true
    return imageView
  }()

  private let performanceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .darkGray
    label.text = "실행 시간: -"
    label.enableCopyOnTouch()
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

  private let dimensionComparisonLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .darkGray
    label.text = "크기 비교: -"
    label.numberOfLines = 0
    return label
  }()


  // MARK: - Properties

  private var originalImageSize = 0
  private var imageResizer = ImageResizer()
  private var disposeBag = DisposeBag()


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
    view.addSubview(resizeMethodSegmentControl)
    view.addSubview(resizeButton)
    view.addSubview(resultImageView)
    view.addSubview(performanceLabel)
    view.addSubview(sizeComparisonLabel)
    view.addSubview(dimensionComparisonLabel)

    selectedImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(250)
    }

    resizeMethodSegmentControl.snp.makeConstraints { make in
      make.top.equalTo(selectedImageView.snp.bottom).offset(10)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(40)
    }

    resizeButton.snp.makeConstraints { make in
      make.top.equalTo(resizeMethodSegmentControl.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.width.equalTo(150)
      make.height.equalTo(44)
    }

    resultImageView.snp.makeConstraints { make in
      make.top.equalTo(resizeButton.snp.bottom).offset(10)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(250)
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

    dimensionComparisonLabel.snp.makeConstraints { make in
      make.top.equalTo(sizeComparisonLabel.snp.bottom).offset(5)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(40)
    }
  }


  // MARK: - Actions

  private func configureActions() {
    // 이미지 뷰에 탭 제스처 추가
    let selectImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageViewTapped))
    selectedImageView.addGestureRecognizer(selectImageViewTapGesture)

    resizeButton.addTarget(
      self,
      action: #selector(resizeButtonTapped),
      for: .touchUpInside
    )

    let resultImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(resultImageViewTapped))
    resultImageView.addGestureRecognizer(resultImageViewTapGesture)
  }

  @objc
  private func selectImageViewTapped() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true)
  }

  @objc
  private func resultImageViewTapped() {
    guard let image = resultImageView.image else { return }
//    let agrume = Agrume(image: image)
//    agrume.show(from: self)
  }

  @objc
  private func resizeButtonTapped() {
    guard let originalImage = selectedImageView.image else { return }

    // 이미지 리사이징 메서드는 추후 구현
    let selectedMethod = resizeMethodSegmentControl.selectedSegmentIndex
    performImageResize(image: originalImage, method: selectedMethod)
  }

  private func performImageResize(image: UIImage, method: Int) {

    guard let imageResizeType = ImageResizeType(rawValue: method) else {
      print("유효하지 않은 리사이징 방식입니다.")
      return
    }

    // 성능 측정 시작
    let startTime = CFAbsoluteTimeGetCurrent()

    // 리사이징 결과 이미지
    let newSize = uploadTargetSize(image: image)
    let resizedImageSingle = imageResizer.resize(
      image: image,
      imageResizeType: imageResizeType,
      newSize: newSize
    )

    resizedImageSingle.subscribe { [weak self] resizedImage in
      guard let self else { return }

      // 성능 측정 종료
      let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime

      // UI 업데이트
      resultImageView.image = resizedImage
      performanceLabel.text = String(format: "실행 시간: %.4f 초", timeElapsed)

      // 용량 비교
      if let resizedImage {
        let resizedImageSize = getImageSize(image: resizedImage)
        updateSizeComparisonLabel(originalSize: originalImageSize, resizedSize: resizedImageSize)
        updateDimensionComparisonLabel(originalImage: image, resizedImage: resizedImage)
      }
    } onFailure: { error in
      print("디버그 에러 발생", error)
    }.disposed(by: disposeBag)
  }

  private func uploadTargetSize(image: UIImage) -> CGSize {
    let uploadImageSize = CGSize(width: 1440, height: 1440)

    let maxPixel: CGFloat = uploadImageSize.width
    let aspectRatio = image.size.width / image.size.height

    if aspectRatio > 1 {
      return CGSize(width: maxPixel, height: maxPixel / aspectRatio)
    }

    return CGSize(width: maxPixel * aspectRatio, height: maxPixel)
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

  private func updateDimensionComparisonLabel(originalImage: UIImage, resizedImage: UIImage) {
    let originalWidth = originalImage.size.width
    let originalHeight = originalImage.size.height
    let resizedWidth = resizedImage.size.width
    let resizedHeight = resizedImage.size.height

    let dimensionText = String(
      format: "width: %.2f -> %.2f\nheight: %.2f -> %.2f",
      originalWidth,
      resizedWidth,
      originalHeight,
      resizedHeight
    )

    dimensionComparisonLabel.text = dimensionText
  }

  private func reset() {
    // 상태 변수 초기화
    originalImageSize = 0

    // UI 요소 초기화
    selectedImageView.image = nil
    resultImageView.image = nil

    // 버튼 상태 초기화
    resizeButton.isEnabled = false

    // 레이블 초기화
    performanceLabel.text = "실행 시간: -"
    sizeComparisonLabel.text = "용량 비교: -"
    dimensionComparisonLabel.text = "크기 비교: -"

    disposeBag = DisposeBag()
  }
}


// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    if let originalImage = info[.originalImage] as? UIImage {
      reset()
      selectedImageView.image = originalImage
      resizeButton.isEnabled = true

      // 원본 이미지 용량 저장
      originalImageSize = getImageSize(image: originalImage)
      sizeComparisonLabel.text = String(format: "원본: %.1f KB", Double(originalImageSize) / 1024.0)

      // 원본 이미지 크기(가로/세로) 정보 표시
      let width = originalImage.size.width
      let height = originalImage.size.height
      dimensionComparisonLabel.text = String(format: "width: %.2f -> ?\nheight: %.2f -> ?", width, height)
    }

    dismiss(animated: true)
  }
}

