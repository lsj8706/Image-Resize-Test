//
//  ImageResizer.swift
//  Image-Resize-Test
//
//  Created by Aiden.lee on 3/14/25.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

import SDWebImage
import RxSwift

final class ImageResizer {

  let context = CIContext(options: [.useSoftwareRenderer: false])

  func resize(image: UIImage, imageResizeType: ImageResizeType, newSize: CGSize) -> Single<UIImage?> {
    return .create { [weak self] single in
      guard let self else { return Disposables.create() }

      let resizedImage: UIImage? = switch imageResizeType {
      case .bitmap:
        image.resizedImage(newSize, interpolationQuality: .high)
      case .sdWebImage:
        image.sd_resizedImage(with: newSize, scaleMode: .aspectFit)
      case .lanczosScaleTransform:
        resizeUsingLanczos(image: image, to: newSize)
      case .downSampling:
        downSample(image: image, size: newSize)
      }

      single(.success(resizedImage))

      return Disposables.create()
    }
    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
    .observe(on: MainScheduler.instance)
  }

  /// Lanczos 알고리즘을 사용하여 이미지를 리사이징합니다.
  /// - Parameters:
  ///   - image: 리사이징할 원본 이미지
  ///   - newSize: 타겟 이미지 크기
  /// - Returns: 리사이징된 이미지 또는 nil (처리 실패시)
  private func resizeUsingLanczos(image: UIImage, to newSize: CGSize) -> UIImage? {
    // CGImage로 변환
    guard let cgImage = image.cgImage else { return nil }

    // CIImage 생성
    let ciImage = CIImage(cgImage: cgImage)

    // 비율 유지하면서 스케일 계산
    let scale = min(newSize.width / image.size.width, newSize.height / image.size.height)

    // Lanczos 필터 적용
    let filter = CIFilter.lanczosScaleTransform()
    filter.inputImage = ciImage
    filter.scale = Float(scale)
    filter.aspectRatio = Float(1.0) // 원본 비율 유지

    guard let outputImage = filter.outputImage else { return nil }

    // CIContext 생성 및 이미지 렌더링
    let scaledWidth = image.size.width * CGFloat(scale)
    let scaledHeight = image.size.height * CGFloat(scale)

    guard let outputCGImage = context.createCGImage(
      outputImage,
      from: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
    )
    else { return nil }

    return UIImage(cgImage: outputCGImage)
  }

  func downSample(image: UIImage, size: CGSize) -> UIImage {
    let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
    let data = image.pngData()! as CFData
    let imageSource = CGImageSourceCreateWithData(data, imageSourceOption)!
    let maxPixel = max(size.width, size.height)
    let downSampleOptions = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: maxPixel,
    ] as CFDictionary

    let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!

    let newImage = UIImage(cgImage: downSampledImage)
    return newImage
  }
}
