//
//  NSFont+fromFont.swift
//  Braumeister
//
//  Created by Thomas Bonk on 15.04.22.
//  Copyright 2022 Thomas Bonk <thomas@meandmymac.de>
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import SwiftUI

extension NSFont {
  static func from(font: Font) -> NSFont {
    switch font {
      case .largeTitle:
        return NSFont.preferredFont(forTextStyle: .largeTitle)

      case .title:
        return NSFont.preferredFont(forTextStyle: .title1)

      case .title2:
        return NSFont.preferredFont(forTextStyle: .title2)

      case .title3:
        return NSFont.preferredFont(forTextStyle: .title3)

      case .headline:
        return NSFont.preferredFont(forTextStyle: .headline)
        
      case .subheadline:
        return NSFont.preferredFont(forTextStyle: .subheadline)

      case .callout:
        return NSFont.preferredFont(forTextStyle: .callout)

      case .caption:
        return NSFont.preferredFont(forTextStyle: .caption1)

      case .caption2:
        return NSFont.preferredFont(forTextStyle: .caption2)

      case .footnote:
        return NSFont.preferredFont(forTextStyle: .footnote)

      case .body:
        fallthrough
        
      default:
        return NSFont.preferredFont(forTextStyle: .body)
    }
  }
}
