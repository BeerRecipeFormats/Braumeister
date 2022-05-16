//
//  BrewhouseYieldCalculationView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 06.05.22.
//

import SwiftUI

struct BrewhouseYieldCalculationView: View {

  // MARK: - Public Properties

  var body: some View {
    Form {
      Section {
        VStack(alignment: .leading) {
          Text("Schüttung:").bold()
          HStack {
            TextField(
              "",
              value:
                Binding(get: {
                  grainBill
                }, set: { val in
                  grainBill = val
                  calculate()
                }),
              format: FloatingPointFormatStyle.number.precision(.fractionLength(2)))
            Text("kg")
          }
        }

        VStack(alignment: .leading) {
          Text("Ausschlagvolumen:").bold()
          HStack {
            TextField(
              "",
              value:
                Binding(get: {
                  wortVolume
                }, set: { val in
                  wortVolume = val
                  calculate()
                }),
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
            Text("Liter")
          }
        }

        VStack(alignment: .leading) {
          Text("Stammwürze:").bold()
          HStack {
            TextField(
              "",
              value: gravityValueBinding($originalGravity, onChange: calculate),
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
            Picker("", selection: gravityUnitBinding($originalGravity, $originalGravityUnit, onChange: calculate)) {
              ForEach(Gravity.allUnits, id: \.id) { unit in
                Text(unit).tag(unit.id).scaledToFit()
              }
            }
            .pickerStyle(.menu)
          }
        }
      }

      Section {
        Text("Sudhausausbeute: \(optionalFloat(brewhouseYield, decimals:0, unit: "%"))").bold()
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
  private var originalGravity = Gravity.plato(0)
  @State
  private var originalGravityUnit: Int = Gravity.allUnits[0].id
  @State
  private var brewhouseYield: Float?


  // MARK: - Private Methods

  private func calculate() {
    guard grainBill != 0 else {
      brewhouseYield = nil
      return
    }

    brewhouseYield = originalGravity.toPlato.value * 1.019 * wortVolume / grainBill
  }
}

struct BrewhouseYieldCalculationView_Previews: PreviewProvider {
  static var previews: some View {
    BrewhouseYieldCalculationView()
  }
}
