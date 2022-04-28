//
//  OriginalWortCalculatorView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 16.04.22.
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

import Combine
import SwiftUI

struct OriginalWortCalculatorView: View {

  // MARK: - Public Properties

  var body: some View {
    Form {
      Picker(selection: $sourceUnit, label: Text("Stammwürze")) {
        TextField("°Plato", value: $plato, formatter: numberFormatter).tag(0).disabled(sourceUnit != 0)
          .frame(width: "°Plato 99,999999".width())
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .onChange(of: plato) { value in
            let plt = Gravity.plato(value)
            brix = plt.toBrix.value
            sg = plt.toSG.value
          }
        TextField("°Brix", value: $brix, formatter: numberFormatter).tag(1).disabled(sourceUnit != 1)
          .frame(width: "°Brix 99,999999".width())
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .onChange(of: brix) { value in
            let brx = Gravity.brix(value)
            plato = brx.toPlato.value
            sg = brx.toSG.value
          }
        TextField("SG", value: $sg, formatter: numberFormatter).tag(2).disabled(sourceUnit != 2)
          .frame(width: "SG 99,999999".width())
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .onChange(of: sg) { value in
            let _sg = Gravity.sg(value)
            plato = _sg.toPlato.value
            brix = _sg.toBrix.value
          }
      }
      .pickerStyle(.radioGroup)

      Spacer()
    }
    .padding([.leading, .top], 20)
    .navigationTitle("Stammwürzerechner")
  }


  // MARK: - Private Properties

  @State
  private var sourceUnit: Int = 0

  @State
  private var plato: Float = 0
  @State
  private var brix: Float = 0
  @State
  private var sg: Float = 0

  private var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()

    formatter.numberStyle = .decimal
    formatter.allowsFloats = true
    return formatter
  }()
}

