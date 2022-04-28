//
//  Flocculation.swift
//  Braumeister
//
//  Created by Thomas Bonk on 27.04.22.
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

enum Flocculation: String, Codable, RawRepresentable, CaseIterable {

  // MARK: - Cases

  case none = "none"
  case low = "low"
  case medium = "medium"
  case high = "high"
  case veryHigh = "veryHight"


  // MARK: - Properties

  var localizedName: String {
    switch self {
      case .none:
        return LocalizedStringKey("Keine Angabe").string

      case .low:
        return LocalizedStringKey("Niedrig").string

      case .medium:
        return LocalizedStringKey("Mittel").string

      case .high:
        return LocalizedStringKey("Hoch").string

      case .veryHigh:
        return LocalizedStringKey("Sehr Hoch").string
    }
  }
}
