//
//  UILabel+.swift
//  Image-Resize-Test
//
//  Created by Aiden.lee on 3/17/25.
//

import UIKit

extension UILabel {
  func enableCopyOnTouch() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:)))

    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(tapGesture)
  }

  @objc
  private func labelTapped(sender: UITapGestureRecognizer) {
    guard let _ = sender.view as? UILabel, let text else {
      return
    }

    let components = text.components(separatedBy: " ")
    guard let numberComponent = components.compactMap({ Double($0) }).first else { return }
    UIPasteboard.general.string = String(numberComponent)
  }
}
