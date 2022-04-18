//
//  CGFloat+Widths.swift
//  Braumeister
//
//  Created by Thomas Bonk on 17.04.22.
//

import Foundation
import CoreGraphics

extension CGFloat {

  static let GravityPickerWidth: CGFloat = {
    return Gravity.allUnits.max()!.width(for: .body)
  }()

  static let NumericInputFieldWidth: CGFloat = {
    return "99.9".width(for: .body) * 2
  }()
}
