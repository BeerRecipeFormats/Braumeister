//
//  DilutionCalculatorView.swift
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

import SwiftUI

struct DilutionCalculatorView: View {

  // MARK: - Public Properties
  
  var body: some View {
    Form {
      //LazyVGrid(columns: [GridItem(alignment: .trailing), GridItem(alignment: .leading)], spacing: 10) {
      Section("Stammwürze:") {
        HStack {
          TextField("Stammwürze", value: gravityBinding($og), formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: .NumericInputFieldWidth)
          Picker("", selection: gravityUnitBinding($og, $ogUnit)) {
            ForEach(Gravity.allUnits, id: \.id) { unit in
              Text(unit).tag(unit.id)
            }
          }
          .pickerStyle(MenuPickerStyle())
          .frame(width: .GravityPickerWidth)
          .padding(.leading, 10)
        }
      }

      Section("Würzemenge:") {
        HStack {
          TextField("Volumen", value: $volume, formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: .NumericInputFieldWidth)
          Text("Liter")
        }
      }

      Section("Gewünschte Stammwürze:") {
        HStack {
          TextField("Stammwürze", value: gravityBinding($targetOg), formatter: numberFormatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: .NumericInputFieldWidth)
          Picker("", selection: gravityUnitBinding($targetOg, $targetOgUnit)) {
            ForEach(Gravity.allUnits, id: \.id) { unit in
              Text(unit).tag(unit.id)
            }
          }
          .pickerStyle(MenuPickerStyle())
          .frame(width: .GravityPickerWidth)
          .padding(.leading, 10)
        }
      }


      Section("Verdünnung:") {
        Text(String(format: "%.1f Liter", fillVolume)).font(.title)
      }
    }
    .navigationTitle("Verdünnungsrechner")
  }


  // MARK: - Private Properties

  @State
  private var og = Gravity.plato(0)
  @State
  private var ogUnit: Int = Gravity.allUnits[0].id
  @State
  private var volume: Float = 0
  @State
  private var targetOg = Gravity.plato(1)
  @State
  private var targetOgUnit: Int = Gravity.allUnits[0].id
  @State
  private var fillVolume: Float = 0

  private var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()

    formatter.numberStyle = .decimal
    formatter.allowsFloats = true
    formatter.minimum = 0.1
    return formatter
  }()


  // MARK: - Private Methods

  private func gravityBinding(_ grav: Binding<Gravity>) -> Binding<Float> {
    return Binding {
      return grav.wrappedValue.value
    } set: { newValue in
      grav.wrappedValue.value = newValue
      calculate()
    }
  }

  private func gravityUnitBinding(_ grav: Binding<Gravity>, _ unit: Binding<Int>) -> Binding<Int> {
    return Binding {
      return unit.wrappedValue
    } set: { newValue in
      unit.wrappedValue = newValue
      grav.wrappedValue = Gravity.for(unit: newValue, value: grav.wrappedValue)
      calculate()
    }
  }

  private func calculate() {
    fillVolume = (og.toPlato.value * volume) / targetOg.toPlato.value - volume
  }
}
