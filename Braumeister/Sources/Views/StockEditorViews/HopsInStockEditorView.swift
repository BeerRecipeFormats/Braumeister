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
    GeometryReader { geometry in
      Form {
        TextField(text: $item.name, prompt: Text("Hopfenname"), label: { Text("Hopfenname:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)
        
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
        
        Picker("Hopfenform:", selection: Binding(get: {
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
        
        HStack {
          TextField(
            value: $item.alpha,
            format: FloatingPointFormatStyle(),
            prompt: Text("Alpha-Säure"),
            label: { Text("Alpha-Säure:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)
          Text("%")
        }
        
        TextField(text: $item.cropCountry, prompt: Text("Herkunftsland"), label: { Text("Herkunftsland:") })
          .textFieldStyle(.roundedBorder)
          .onSubmit(self.updateDatabase)
        
        TextField(
          value: $item.cropYear,
          format: IntegerFormatStyle().grouping(IntegerFormatStyle<UInt16>.Configuration.Grouping.never),
          prompt: Text("Erntejahr"),
          label: { Text("Erntejahr:") })
        .textFieldStyle(.roundedBorder)
        .onSubmit(self.updateDatabase)
        
        DatePicker("MHD:", selection: Binding(get: {
          item.bestBefore ?? Date()
        }, set: { date in
          item.bestBefore = date
          self.updateDatabase()
        }), displayedComponents: .date)
        
        TextField(
          text: Binding(get: {
            item.alternatives ?? ""
          }, set: { text in
            item.alternatives = text
            self.updateDatabase()
          }),
          prompt: Text("Alternativen"),
          label: { Text("Alternativen:") })
        .textFieldStyle(.roundedBorder)
        
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
      .frame(height: geometry.size.height)
    }
    .onDisappear(perform: self.updateDatabase)
    .padding([.leading, .top], 20)
    .padding(.trailing, 100)
    .navigationTitle("Hopfenbestand bearbeiten")
  }
  
  
  // MARK: - Private Properties
  
  @State
  private var item: HopsInStock
  
  @EnvironmentObject
  private var repository: Repository
  
  
  // MARK: - Initialization
  
  init(item: HopsInStock? = nil) {
    if let itm = item {
      self.item = itm
    } else {
      self.item = HopsInStock(name: "Neuer Hopfenbestand")
    }
  }
  
  
  // MARK: - Private Methods
  
  private func updateDatabase() {
    do {
      if self.item.id == nil {
        try repository.create(hopsInStock: self.item)
      }
      try repository.save(hopsInStock: item)
    } catch {
      errorAlert(message: "Fehler beim Speichern der Daten.", error: error)
    }
  }
}
