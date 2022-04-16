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
      LazyVGrid(columns: [GridItem(alignment: .trailing), GridItem(alignment: .leading)], spacing: 10) {
        if fromPlato {
          TextField("Stammwürze", value: bind($plato), formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: "99.9".width() * 2)
            .onChange(of: plato) { newValue in
              let plt = Gravity.plato(newValue)
              brix = plt.toBrix.value
              sg = plt.toSG.value
            }
        } else {
          Text(String(format: "%.1f", plato))
        }
        Toggle("° Plato", isOn: $fromPlato)
          .onChange(of: fromPlato) { newValue in
            fromBrix = !newValue
            fromSG = false
          }

        if fromBrix {
          TextField("Stammwürze", value: bind($brix), formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: "99.9".width() * 2)
            .onChange(of: brix) { newValue in
              let brx = Gravity.brix(newValue)
              plato = brx.toPlato.value
              sg = brx.toSG.value
            }
        } else {
          Text(String(format: "%.1f", brix))
        }
        Toggle("° Brix", isOn: $fromBrix)
          .onChange(of: fromBrix) { newValue in
            fromSG = !newValue
            fromPlato = false
          }

        if fromSG {
          TextField("Stammwürze", value: bind($sg), formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: "99.9".width() * 2)
            .onChange(of: sg) { newValue in
              let sg_ = Gravity.sg(newValue)
              plato = sg_.toPlato.value
              brix = sg_.toBrix.value
            }
        } else {
          Text(String(format: "%.3f", sg))
        }
        Toggle("SG", isOn: $fromSG)
          .onChange(of: fromSG) { newValue in
            fromPlato = !newValue
            fromBrix = false
          }
      }
    }
    .navigationTitle("Stammwürzerechner")
    .onAppear {

    }
  }


  // MARK: - Private Properties

  @State
  private var plato: Float = 0
  @State
  private var fromPlato = true
  @State
  private var brix: Float = 0
  @State
  private var fromBrix = false
  @State
  private var sg: Float = 0
  @State
  private var fromSG = false

  private var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()

    formatter.numberStyle = .decimal
    formatter.allowsFloats = true
    return formatter
  }()


  // MARK: - Private Methods

  private func bind<V>(_ val: Binding<V>) -> Binding<V> {
    return Binding {
      return val.wrappedValue
    } set: { newVal in
      val.wrappedValue = newVal
    }
  }
}

