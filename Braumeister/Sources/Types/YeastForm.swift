//
//  YeastForm.swift
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

enum YeastForm: String, Codable, RawRepresentable, CaseIterable {

  // MARK: - Cases

  case liquid = "liquid"
  case dry = "dry"
  case slant = "slant"
  case culture = "culture"


  // MARK: - Properties

  var localizedName: String {
    switch self {
      case .liquid:
        return LocalizedStringKey("Flüssighefe").string

      case .dry:
        return LocalizedStringKey("Trockenhefe").string

      case .slant:
        return LocalizedStringKey("Vermehrte Hefe").string

      case .culture:
        return LocalizedStringKey("Hefekultur").string
    }
  }
}
