//
//  AlcoholCalculatorView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 14.04.22.
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

import SwiftUI

struct AlcoholCalculatorView: View {

  // MARK: - Public Properties
  
  var body: some View {
    Form {
      LazyVGrid(columns: [GridItem(alignment: .leading), GridItem(alignment: .leading)]) {
        TextField("Stammwürze:", value: ogBinding(), formatter: numberFormatter)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Picker("", selection: ogUnitBinding()) {
          ForEach(Gravity.allUnits, id: \.id) { unit in
            Text(unit).tag(unit.id).scaledToFit()
          }
        }
        .frame(width: .GravityPickerWidth)

        TextField("Restextrakt:", value: fgBinding(), formatter: numberFormatter)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Text("°Brix")
          .padding(.leading, 10)
      }

      Section("Ergebnis:") {
        LazyVGrid(columns: [GridItem(alignment: .trailing), GridItem(alignment: .leading)]) {
          Text("Scheinbarer Restextrakt:")
          Text(String(format: "%.1f °P (%.3f SG)", reS.toPlato.value, reS.value))
            .bold()

          Text("Scheinbarer Vergärungsgrad:")
          Text(String(format: "%.0f%%", vgS))
            .bold()
          Text("Tatsächlicher Restextrakt:")
          Text(String(format: "%.1f °P", reT.value))
            .bold()

          Text("Tatsächlicher Vergärungsgrad:")
          Text(String(format: "%.0f%%", vgT))
            .bold()
          
          Text("Alkoholgehalt:")
          Text(String(format: "%.1f%% vol", alc))
            .bold()
        }
      }
      .padding(.top, 20)
      Spacer()
    }
    .padding([.leading, .trailing, .top], 20)
    .navigationTitle("Alkoholgehalt mit Refraktometerkorrektur")
  }


  // MARK: - Private Properties

  @State
  private var og = Gravity.plato(0)
  @State
  private var fg = Gravity.brix(0)

  @State
  private var ogUnit: Int = Gravity.allUnits[0].id

  @State
  private var reS = Gravity.sg(0)
  @State
  private var vgS: Float = 0
  @State
  private var reT = Gravity.plato(0)
  @State
  private var vgT: Float = 0
  @State
  private var alc: Float = 0

  private var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()

    formatter.numberStyle = .decimal
    return formatter
  }()


  // MARK: - Private Methods

  private func ogBinding() -> Binding<Float> {
    return Binding {
      og.value
    } set: { value in
      og.value = value
      calculate()
    }
  }

  private func ogUnitBinding() -> Binding<Int> {
    return Binding {
      return ogUnit
    } set: { val in
      ogUnit = val
      og = Gravity.for(unit: ogUnit, value: og)
    }
  }

  private func fgBinding() -> Binding<Float> {
    return Binding {
      fg.value
    } set: { value in
      fg.value = value
      calculate()
    }
  }

  private func calculate() {
    guard og.value != 0 && fg.value != 0 else {
      return
    }

    reS = .sg(1.000 - 0.00085683 * og.toBrix.value + 0.0034941 * fg.toBrix.value)
    vgS = (1 - reS.toPlato.value / og.toPlato.value ) * 100
    reT = .plato(0.1808 * og.toPlato.value + 0.8192 * reS.toPlato.value)
    vgT = (1 - reT.toPlato.value / og.toPlato.value ) * 100

    alc = (261.1 / (261.53 - reT.value)) * ((og.toPlato.value - reT.value) / (2.0665 - 0.010665 * og.toPlato.value)) / 0.794
  }
}
