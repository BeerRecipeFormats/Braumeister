//
//  HopForm.swift
//  Braumeister
//
//  Created by Thomas Bonk on 24.04.22.
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

enum HopForm: String, Codable, RawRepresentable, CaseIterable {

  // MARK: - Cases

  case green = "green"
  case cone = "cone"
  case pellets = "pellets"
  case extract = "extract"


  // MARK: - Properties

  var localizedName: String {
    switch self {
      case .green:
        return LocalizedStringKey("Grünhopfen").string

      case .cone:
        return LocalizedStringKey("Doldenhopfen").string

      case .pellets:
        return LocalizedStringKey("Pellets").string

      case .extract:
        return LocalizedStringKey("Extrakt").string
    }
  }
}
