//
//  YeastInStockEditorView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 27.04.22.
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

struct YeastInStockEditorView: View {

  // MARK: - Public Properties

  var body: some View {
    GeometryReader { geometry in
      Form {
        Group {
          TextField(text: $item.name, prompt: Text("Hefe"), label: { Text("Hefe:") })
            .textFieldStyle(.roundedBorder)
            .onSubmit(self.updateDatabase)

          Picker("Hefeform:", selection: Binding(get: {
            item.form
          }, set: { value in
            item.form = value
            self.updateDatabase()
          })) {
            ForEach(YeastForm.allCases, id: \.self) { form in
              Text(form.localizedName).tag(form)
            }
          }
          .pickerStyle(.menu)

          HStack {
            TextField(
              value: $item.amount,
              format: IntegerFormatStyle(),
              prompt: Text("Menge"),
              label: { Text("Menge:") })
            .textFieldStyle(.roundedBorder)
            .onSubmit(self.updateDatabase)
            Text("g")
          }

          DatePicker("MHD:", selection: Binding(get: {
            return item.bestBefore ?? Date()
          }, set: { date in
            item.bestBefore = date
            self.updateDatabase()
          }), displayedComponents: .date)

          TextField(text: $item.laboratory, prompt: Text("Hersteller"), label: { Text("Hersteller:") })
            .textFieldStyle(.roundedBorder)
            .onSubmit(self.updateDatabase)

          TextField(text: $item.productId, prompt: Text("Artikelnummer"), label: { Text("Artikelnummer:") })
            .textFieldStyle(.roundedBorder)
            .onSubmit(self.updateDatabase)

          HStack {
            Text("Vergährtemperatur:")

            HStack {
              TextField(
                value: Binding(
                  get: {
                    return self.item.minTemp ?? 0
                  }, set: { value in
                    self.item.minTemp = value
                    self.updateDatabase()
                  }),
                format: IntegerFormatStyle(),
                prompt: Text("min (°C)"),
                label: { Text("min (°C)") })
              .textFieldStyle(.roundedBorder)
              .onSubmit(self.updateDatabase)

              Text(" - ")

              TextField(
                value: Binding(
                  get: {
                    return self.item.maxTemp ?? 0
                  }, set: { value in
                    self.item.maxTemp = value
                    self.updateDatabase()
                  }),
                format: IntegerFormatStyle(),
                prompt: Text("max (°C)"),
                label: { Text("max (°C)") })
              .textFieldStyle(.roundedBorder)
              .onSubmit(self.updateDatabase)
            }
          }

          TextField(
            text: Binding(
              get: {
                return item.finalFermentation ?? ""
              }, set: { value in
                item.finalFermentation = value
                self.updateDatabase()
              }),
            prompt: Text("Scheinbarer Endvergärungsgrad"),
            label: { Text("Scheinbarer Endvergärungsgrad:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)

          TextField(
            text: Binding(
              get: {
                return item.alcoholTolerance ?? ""
              }, set: { value in
                item.alcoholTolerance = value
                self.updateDatabase()
              }),
            prompt: Text("Alkoholtoleranz"),
            label: { Text("Alkoholtoleranz:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)

          TextField(
            text: Binding(
              get: {
                return item.yeastStrain ?? ""
              }, set: { value in
                item.yeastStrain = value
                self.updateDatabase()
              }),
            prompt: Text("Hefestamm"),
            label: { Text("Hefestamm:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)
        }

        Group {
          Picker("Ausflockung:", selection: Binding(
            get: {
              return item.flocculation
            }, set: { value in
              item.flocculation = value
              self.updateDatabase()
            })) {
              ForEach(Flocculation.allCases, id: \.self) { flocculation in
                Text(flocculation.localizedName).tag(flocculation)
              }
            }
            .pickerStyle(.menu)

          TextField(
            text: Binding(
              get: {
                return item.bestFor ?? ""
              }, set: { value in
                item.bestFor = value
                self.updateDatabase()
              }),
            prompt: Text("Bierstile"),
            label: { Text("Bierstile:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)

          GeometryReader { editorGeometry in
            TextEditor(text: Binding(get: {
              item.notes ?? ""
            }, set: { text in
              item.notes = text
              self.updateDatabase()
            }))
            .overlay(
              RoundedRectangle(cornerRadius: 4)
                .stroke(Color.secondary.opacity(0.5), lineWidth: 1.0)
                .padding(.all, -2)
            )
            .frame(height: editorGeometry.size.height - 20)
          }
        }
      }.frame(height: geometry.size.height)
    }
    .onDisappear(perform: self.updateDatabase)
    .padding([.leading, .top], 20)
    .padding(.trailing, 100)
    .navigationTitle("Hefebestand bearbeiten")
  }


  // MARK: - Private Properties

  @State
  private var item: YeastInStock

  @EnvironmentObject
  private var repository: Repository


  // MARK: - Initialization

  init(item: YeastInStock? = nil) {
    if let itm = item {
      self.item = itm
    } else {
      self.item = YeastInStock(name: "Neuer Hefebestand")
      self.item.amountUnit = "g"
    }
  }


  // MARK: - Private Methods

  private func updateDatabase() {
    do {
      if self.item.id == nil {
        try repository.create(yeastInStock: self.item)
      }
      try repository.save(yeastInStock: item)
    } catch {
      errorAlert(message: "Fehler beim Speichern der Daten.", error: error)
    }
  }
}

