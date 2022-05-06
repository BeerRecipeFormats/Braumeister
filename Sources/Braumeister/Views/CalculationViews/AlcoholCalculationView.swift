//
//  AlcoholCalculationView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 06.05.22.
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
import SwiftWebUI

struct AlcholoCalculationView: View {
  
  // MARK: - Public Properties
  
  var body: some View {
    Form {
      VStack(alignment: .leading) {
        Text("Stammwürze:")
        HStack {
          TextField($originalGravity, placeholder: Text("Stammwürze"), formatter: gravityNumberFormatter)
          Picker(selection: $originalGravityUnit, label: Text("")) {
            Text("°Plato").tag(0)
            Text("°Brix").tag(1)
            Text("SG").tag(1)
          }
        }
      }
      VStack(alignment: .leading) {
        Text("Restextrakt:")
        HStack {
          TextField($finalGravity, placeholder: Text("Restextrakt"), formatter: gravityNumberFormatter)
          Text("°Brix")
        }
      }
      
      Text("\(originalGravity)")
    }
    .navigationBarTitle(Text("Alkoholgehalt"))
  }
  
  
  // MARK: - Private Properties
  
  var gravityNumberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumIntegerDigits = 2
    formatter.maximumFractionDigits = 1
    return formatter
  }()
  
  @State
  private var originalGravity: Float = 0
  @State
  private var originalGravityUnit: Int = 0
  @State
  private var finalGravity: Float = 0
}
