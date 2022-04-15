//
//  String+width.swift
//  Braumeister
//
//  Created by Thomas Bonk on 15.04.22.
//

import Foundation
import SwiftUI

extension String {
  func width(for font: Font = .body) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: UIFont.from(font: font)]
    let size = self.size(withAttributes: fontAttributes)
    return size.width
  }
}
