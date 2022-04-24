//
//  HopsInStockEditorView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 24.04.22.
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

struct HopsInStockEditorView: View {

  // MARK: - Public Properties
  
  var body: some View {
    ViewBody()
      .navigationTitle("Hopfenbestand bearbeiten")
  }


  // MARK: - Private Properties

  @State
  private var item: HopsInStock

  @EnvironmentObject
  private var repository: Repository

  private var create = false


  // MARK: - Initialization

  init(item: HopsInStock? = nil) {
    if let itm = item {
      self.item = itm
    } else {
      self.item = HopsInStock(name: "<Hopfenname>")
      create = true
    }
  }


  // MARK: - Private Methods

  private func ViewBody() -> AnyView {
    var errorOccured = false

    if create {
      do {
        try repository.create(hopsInStock: item)
        try repository.save(hopsInStock: item)
      } catch {
        // TODO Handle error
        errorOccured = true
      }
    }

    if errorOccured {
      return AnyView(Text("Fehler beim Schreiben der Daten!"))
    } else {
      return AnyView(
        Form {
          LazyVGrid(columns: [GridItem(alignment: .trailing), GridItem(alignment: .leading)]) {
            Group {
              Text("Hopfenname:")
              TextField(text: $item.name, prompt: Text("Hopfenname"), label: { Text("Hopfenname") })
                .textFieldStyle(.roundedBorder)
                .onSubmit(self.updateDatabase)
            }.padding([.top, .bottom], 10)

            Group {
              Text("Menge:")
              HStack {
                TextField(
                   value: $item.amount,
                  format: IntegerFormatStyle(),
                  prompt: Text("Hopfenname"),
                   label: { Text("Hopfenname") })
                  .textFieldStyle(.roundedBorder)
                  .onSubmit(self.updateDatabase)
                Text("g")
              }
            }.padding(.bottom, 10)

            Group {
              Text("Hopfenform:")
              Picker("", selection: Binding(get: {
                item.form
              }, set: { value in
                item.form = value
                self.updateDatabase()
              })) {
                ForEach(HopForm.allCases, id: \.self) { form in
                  Text(form.localizedName).tag(form)
                }
              }
              .pickerStyle(.menu)
            }.padding(.bottom, 10)

            Group {
              Text("Alpha-Säure:")
              HStack {
                TextField(
                  value: $item.alpha,
                  format: FloatingPointFormatStyle(),
                  prompt: Text("Alpha-Säure"),
                  label: { Text("Alpha-Säure") })
                .textFieldStyle(.roundedBorder)
                .onSubmit(self.updateDatabase)
                Text("%")
              }
            }.padding(.bottom, 10)

            Group {
              Text("Herkunftsland:")
              TextField(text: $item.cropCountry, prompt: Text("Herkunftsland"), label: { Text("Herkunftsland") })
                .textFieldStyle(.roundedBorder)
                .onSubmit(self.updateDatabase)
            }.padding(.bottom, 10)

            Group {
              Text("Erntejahr:")
              TextField(
                value: $item.cropYear,
                format: IntegerFormatStyle.number,
                prompt: Text("Erntejahr"),
                label: { Text("Erntejahr") })
              .textFieldStyle(.roundedBorder)
              .onSubmit(self.updateDatabase)
            }.padding(.bottom, 10)

            Group {
              Text("MHD:")
              DatePicker("", selection: Binding(get: {
                item.bestBefore ?? Date()
              }, set: { date in
                item.bestBefore = date
                self.updateDatabase()
              }),
              displayedComponents: .date)
            }.padding(.bottom, 10)

            Group {
              Text("Alternativen:")
              TextField(
                text: Binding(get: {
                  item.alternatives ?? ""
                }, set: { text in
                  item.alternatives = text
                  self.updateDatabase()
                }),
                prompt: Text("Alternativen"),
                label: { Text("Alternativen") })
                .textFieldStyle(.roundedBorder)
            }.padding(.bottom, 10)

            Group {
              Text("Beschreibung:")
              TextEditor(text: Binding(get: {
                item.notes ?? ""
              }, set: { text in
                item.notes = text
                self.updateDatabase()
              })).textFieldStyle(.roundedBorder)
            }.padding(.bottom, 10)
          }
        }
      )
    }
  }

  private func updateDatabase() {
    do {
      try repository.save(hopsInStock: item)
    } catch {
      // TODO Handle error
    }
  }
}
