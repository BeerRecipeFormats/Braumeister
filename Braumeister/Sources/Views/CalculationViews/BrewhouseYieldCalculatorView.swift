//
//  BrewhouseYieldCalculatorView.swift
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

import SwiftUI

struct BrewhouseYieldCalculatorView: View {

  // MARK: - Public Properties

  var body: some View {
    Form {
      LazyVGrid(columns: [GridItem(alignment: .trailing), GridItem(alignment: .leading)], spacing: 10) {
        Text("Schüttungsmenge:")
        HStack {
          TextField("Stammwürze", value: bind($grainBill), formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: "99.9".width() * 2)
          Text("kg")
        }

        Text("Ausschlagvolumen:")
        HStack {
          TextField("Ausschlagvolumen", value: bind($wortVolume), formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: "99.9".width() * 2)
          Text("Liter")
        }

        Text("Stammwürze:")
        HStack {
          TextField("Stammwürze", value: ogBinding(), formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: "99.9".width() * 2)
          Picker("", selection: ogUnitBinding()) {
            ForEach(Gravity.allUnits, id: \.id) { unit in
              Text(unit).tag(unit.id)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }

        Text("Sudhausausbeute:").bold()
        Text(String(format: "%.0f%%", brewhouseYield)).bold()
      }
    }
    .navigationTitle("Sudhausausbeute")
  }


  // MARK: - Private Properties

  @State
  private var grainBill: Float = 0
  @State
  private var wortVolume: Float = 0
  @State
  private var og = Gravity.plato(0)
  @State
  private var ogUnit: Int = Gravity.allUnits[0].id
  @State
  private var brewhouseYield: Float = 0

  private var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()

    formatter.numberStyle = .decimal
    formatter.allowsFloats = true
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

  private func bind<V>(_ val: Binding<V>) -> Binding<V> {
    return Binding {
      return val.wrappedValue
    } set: { newVal in
      val.wrappedValue = newVal
      calculate()
    }
  }

  private func calculate() {
    brewhouseYield = og.toPlato.value * 1.019 * wortVolume / grainBill
    /*
     AS = Stw * SG * 0,96 * VA / Sch

     AS  -  Sudhausausbeute in %
     Stw  -  Stammwürze in %gew (°P)
     SG  -  Spezifisches Gewicht
     0,96  -  Korrekturfaktor
     VA  -  Ausschlagvolumen (heiß) in Liter
     Sch  -  Schüttungsmenge in kg
     */
  }
}
