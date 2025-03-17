//
//  ImageResizeType.swift
//  Image-Resize-Test
//
//  Created by Aiden.lee on 3/11/25.
//

import Foundation

enum ImageResizeType: Int, CaseIterable {
  case bitmap
  case sdWebImage // UIGraphicsImageRenderer
  case lanczosScaleTransform
  case downSampling // ImageIO

  var title: String {
    switch self {
    case .bitmap:
      return "Bitmap"
    case .sdWebImage:
      return "SDWebImage"
    case .lanczosScaleTransform:
      return "Lanczos"
    case .downSampling:
      return "DownSampling"
    }
  }
}
