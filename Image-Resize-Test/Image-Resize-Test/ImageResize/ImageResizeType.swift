//
//  ImageResizeType.swift
//  Image-Resize-Test
//
//  Created by Aiden.lee on 3/11/25.
//

import Foundation

enum ImageResizeType {
  case bitmap
  case sdWebImage // UIGraphicsImageRenderer
  case lanczosScaleTransform
  case downSampling // ImageIO
}
