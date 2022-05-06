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

import SwiftUI

struct AlcoholCalculationView: View {

  // MARK: - Public Properties

  var body: some View {
    Form {
      Section {
        VStack(alignment: .leading) {
          Text("Stammwürze:").bold()
          HStack {
            TextField(
              "Stammwürze",
               value: gravityValueBinding($originalGravity, onChange: calculate),
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
            Picker("", selection: gravityUnitBinding($originalGravity, $originalGravUnit, onChange: calculate)) {
              ForEach(Gravity.allUnits, id: \.id) { unit in
                Text(unit).tag(unit.id).scaledToFit()
              }
            }
            .pickerStyle(.menu)
          }

          Text("Restextrakt:").bold()
          HStack {
            TextField(
              "Restextrakt",
              value:
                Binding(get: {
                  finalGravity
                }, set: { val in
                  finalGravity = val
                  calculate()
                }),
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
            Text("°Brix")
          }
        }
      }

      Section("Ergebnis") {
        LazyVGrid(columns: [GridItem(alignment: .leading), GridItem(alignment: .leading)]) {
          Group {
            Text("Scheinbarer Restextrakt:")
            Text(reS != nil ? "\(reS!.toPlato.description) (\(reS!.description))" : "").bold()
          }.padding(.bottom, 5)

          Group {
            Text("Scheinbarer Vergärungsgrad:")
            Text(optionalFloat(vgS, unit: "%")).bold()
          }.padding(.bottom, 5)

          Group {
            Text("Tatsächlicher Restextrakt:")
            Text(optionalGravity(reT)).bold()
          }.padding(.bottom, 5)

          Group {
            Text("Tatsächlicher Vergärungsgrad:")
            Text(optionalFloat(vgT, unit: "%")).bold()
          }.padding(.bottom, 5)

          Group {
            Text("Alkoholgehalt:")
            Text(optionalFloat(alc, decimals: 1, unit: "% vol"))
              .bold()
          }.padding(.bottom, 5)
        }
      }
    }
    .navigationTitle("Alkoholgehalt")
  }


  // MARK: - Private Properties

  @State
  private var originalGravity = Gravity.plato(0)
  @State
  private var originalGravUnit: Int = Gravity.allUnits[0].id
  @State
  private var finalGravity: Float = 0

  @State
  private var reS: Gravity?
  @State
  private var vgS: Float?
  @State
  private var reT: Gravity?
  @State
  private var vgT: Float?
  @State
  private var alc: Float?


  // MARK: - Private Methods

  private func calculate() {
    guard originalGravity.value > 0 && finalGravity > 0 else {
      return
    }

    reS = .sg(1.000 - 0.00085683 * originalGravity.toBrix.value + 0.0034941 * finalGravity)
    vgS = (1 - reS!.toPlato.value / originalGravity.toPlato.value ) * 100
    reT = .plato(0.1808 * originalGravity.toPlato.value + 0.8192 * reS!.toPlato.value)
    vgT = (1 - reT!.toPlato.value / originalGravity.toPlato.value ) * 100

    alc = (261.1 / (261.53 - reT!.value)) * ((originalGravity.toPlato.value - reT!.value) / (2.0665 - 0.010665 * originalGravity.toPlato.value)) / 0.794
  }

  private func optionalGravity(_ gravity: Gravity?, unit: String = "") -> String {
    return gravity != nil ? gravity!.description + unit : ""
  }

  private func optionalFloat(_ value: Float?, decimals: Int = 0, unit: String = "") -> String {
    return value != nil ? String(format: "%.\(decimals)f", value!) + unit : ""
  }
}

struct AlcoholCalculationView_Previews: PreviewProvider {
  static var previews: some View {
    AlcoholCalculationView()
  }
}
