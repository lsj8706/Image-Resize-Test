//
//  ImageResizer.swift
//  Image-Resize-Test
//
//  Created by Aiden.lee on 3/14/25.
//

import UIKit

import SDWebImage

final class ImageResizer {
  func resize(image: UIImage, imageResizeType: ImageResizeType, newSize: CGSize) -> UIImage? {
    switch imageResizeType {
    case .bitmap:
      return image.resizedImage(newSize, interpolationQuality: .high)
    case .sdWebImage:
      return image.sd_resizedImage(with: newSize, scaleMode: .aspectFit)
    case .lanczosScaleTransform:
      return nil
    case .downSampling:
      return nil
    }
  }
}
