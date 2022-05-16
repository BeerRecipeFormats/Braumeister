//
//  GravityConvertionView.swift
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

import Combine
import SwiftUI

struct GravityConvertionView: View {

  // MARK: - Public Properties

  var body: some View {
    Form {
      LazyVGrid(columns: [GridItem(alignment: .leading), GridItem(alignment: .leading)]) {
        TextField(
          "",
          value:
            Binding(get: {
              plato
            }, set: { val in
              $plato.wrappedValue = val

              $brix.wrappedValue = Gravity.plato(plato).toBrix.value
              $sg.wrappedValue = Gravity.plato(plato).toSG.value
            }),
          format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
        Text("°Plato")

        TextField(
          "",
          value:
            Binding(get: {
              brix
            }, set: { val in
              $brix.wrappedValue = val

              $plato.wrappedValue = Gravity.brix(brix).toPlato.value
              $sg.wrappedValue = Gravity.brix(brix).toSG.value
            }),
          format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
        Text("°Brix")

        TextField(
          "",
          value:
            Binding(get: {
              sg
            }, set: { val in
              $sg.wrappedValue = val

              $plato.wrappedValue = Gravity.sg(sg).toPlato.value
              $brix.wrappedValue = Gravity.sg(sg).toBrix.value
            }),
          format: FloatingPointFormatStyle.number.precision(.fractionLength(3)))
        Text("SG")
      }
    }
    .navigationTitle("Dichteumrechnung")
  }


  // MARK: - Private Properties

  @State
  private var plato: Float = 0
  @State
  private var brix: Float = 0
  @State
  private var sg: Float = 0
}

struct GravityConvertionView_Previews: PreviewProvider {
  static var previews: some View {
    GravityConvertionView()
  }
}
