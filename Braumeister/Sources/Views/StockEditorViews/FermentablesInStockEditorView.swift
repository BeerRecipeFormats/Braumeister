//
//  FermentablesInStockEditorView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 26.04.22.
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

struct FermentablesInStockEditorView: View {

  // MARK: - Public Properties

  var body: some View {
    GeometryReader { geometry in
      Form {
        TextField(text: $item.name, prompt: Text("Bezeichnung"), label: { Text("Bezeichnung:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)

        Picker("Typ:", selection: Binding(
          get: {
            return item.type
          }, set: { value in
            item.type = value
            self.updateDatabase()
          })) {
            ForEach(FermentableType.allCases, id: \.self) { type in
            Text(type.localizedName).tag(type)
          }
        }
        .pickerStyle(.menu)

        HStack {
          TextField(
            value: Binding(
              get: {
                return item.amount
              }, set: { value in
                item.amount = value
                self.updateDatabase()
              }),
            format: FloatingPointFormatStyle(),
            prompt: Text("Menge"),
            label: { Text("Menge:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)
          Text("kg")
        }

        HStack {
          TextField(
            value: Binding(
              get: {
                return item.color ?? 0
              }, set: { value in
                item.color = value
                self.updateDatabase()
              }),
            format: FloatingPointFormatStyle(),
            prompt: Text("Farbe"),
            label: { Text("Farbe:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)
          Text("EBC")
        }

        TextField(
          text: Binding(
            get: {
              item.origin ?? ""
            }, set: { value in
              item.origin = value
              self.updateDatabase()
            }),
          prompt: Text("Herkunft"),
          label: { Text("Herkunft:") })
        .textFieldStyle(.roundedBorder)
        .onSubmit(self.updateDatabase)

        HStack {
          TextField(
            value: Binding(
              get: {
                item.maxInBatch ?? 0
              }, set: { value in
                item.maxInBatch = value
                self.updateDatabase()
              }),
            format: IntegerFormatStyle(),
            prompt: Text("Zugabe"),
            label: { Text("Zugabe:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)
          Text("%")
        }

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
    }
    .onDisappear(perform: self.updateDatabase)
    .padding([.leading, .top], 20)
    .padding(.trailing, 100)
    .navigationTitle("Vergärbare Zutat bearbeiten")
  }


  // MARK: - Private Properties

  @State
  private var item: FermentablesInStock

  @State
  private var textEditorHeight: CGFloat = 400

  @EnvironmentObject
  private var repository: Repository


  // MARK: - Initialization

  init(item: FermentablesInStock? = nil) {
    if let itm = item {
      self.item = itm
    } else {
      self.item = FermentablesInStock(name: "Neuer Bestand")
    }
  }


  // MARK: - Private Methods

  private func updateDatabase() {
    do {
      if self.item.id == nil {
        try repository.create(fermentablesInStock: self.item)
      }
      try repository.save(fermentablesInStock: item)
    } catch {
      errorAlert(message: "Fehler beim Speichern der Daten.", error: error)
    }
  }
}
