//
//  DilutionCalculationView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 06.05.22.
//

import SwiftUI

struct DilutionCalculationView: View {

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
        }

        VStack(alignment: .leading) {
          Text("Würzemenge:").bold()
          HStack {
            TextField(
              "Würzemenge",
              value: $volume,
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
            Text("Liter")
              .padding(.leading, 2)
          }
        }


        VStack(alignment: .leading) {
          Text("Gewünschte Stammwürze:").bold()
          HStack {
            TextField(
              "Gewünschte Stammwürze:",
              value: gravityValueBinding($targetOg, onChange: calculate),
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))

            Picker("", selection: gravityUnitBinding($targetOg, $targetOgUnit, onChange: calculate)) {
              ForEach(Gravity.allUnits, id: \.id) { unit in
                Text(unit).tag(unit.id)
              }
            }
            .pickerStyle(.menu)
          }
        }
      }

      Section("Ergebnis") {
        HStack {
          Text("Verdünnung:").bold()
          Text(fillVolume != nil ? String(format: "%.1f Liter", fillVolume!) : "").bold()
        }
      }
    }
  }


  // MARK: - Private Properties

  @State
  private var originalGravity = Gravity.plato(0)
  @State
  private var originalGravUnit: Int = Gravity.allUnits[0].id
  @State
  private var volume: Float = 0
  @State
  private var targetOg = Gravity.plato(1)
  @State
  private var targetOgUnit: Int = Gravity.allUnits[0].id

  @State
  private var fillVolume: Float?


  // MARK: - Private Methods

  private func calculate() {
    guard targetOg.toPlato.value != 0 else {
      fillVolume = nil
      return
    }
    
    fillVolume = (originalGravity.toPlato.value * volume) / targetOg.toPlato.value - volume
  }
}

struct DilutionCalculationView_Previews: PreviewProvider {
  static var previews: some View {
    DilutionCalculationView()
  }
}
