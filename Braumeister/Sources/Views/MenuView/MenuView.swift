//
//  MenuView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 14.04.22.
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

struct MenuView: View {

  // MARK: - Public Properties

  var body: some View {
    List {
      DisclosureGroup("Rezepte", isExpanded: $recipesDisclosed) {
        Text("Keine Rezepte vorhanden!").italic()
      }

      DisclosureGroup("Sude", isExpanded: $brewsDisclosed) {
        Text("Keine Sude vorhanden!").italic()
      }

      DisclosureGroup("Bestand", isExpanded: $stockDisclosed) {
        DisclosureGroup(isExpanded: $hopsInStockDisclosed) {
          if repository.hopsInStock.isEmpty {
            Text("Kein Bestand").italic()
          } else {
            ForEach(repository.hopsInStock, id: \.id) { item in
              NavigationLink(destination: { HopsInStockEditorView(item: item) }) {
                HopsInStockItemView(item: item)
              }
            }
            .onDelete(perform: self.deleteHopsInStock)
          }
        } label: {
          HStack {
            Text("Hopfen")
            NavigationLink(isActive: $createHopsInStock, destination: { HopsInStockEditorView() }) {
              Button(action: { createHopsInStock = true }, label: { Image(systemName: "plus.rectangle.fill") })
                .buttonStyle(.borderless)
            }
          }
        }
      }

      DisclosureGroup("Berechnungen", isExpanded: $calculationsDisclosed) {
        NavigationLink("Alkoholgehalt", destination: AlcoholCalculatorView())
        NavigationLink("Stammwürzerechner", destination: OriginalWortCalculatorView())
        NavigationLink("Sudhausausbeute", destination: BrewhouseYieldCalculatorView())
        NavigationLink("Verdünnungsrechner", destination: DilutionCalculatorView())
      }
    }
    .listStyle(.sidebar)
    .navigationTitle("Braumeister")
  }


  // MARK: - Private Properties

  @EnvironmentObject
  private var repository: Repository

  @State
  private var createHopsInStock = false

  @AppStorage("menu_recipesDisclosed", store: .standard)
  private var recipesDisclosed = false
  @AppStorage("menu_brewsDisclosed", store: .standard)
  private var brewsDisclosed = false
  @AppStorage("menu_stockDisclosed", store: .standard)
  private var stockDisclosed = true
  @AppStorage("menu_stock_hopsInStockDisclosed", store: .standard)
  private var hopsInStockDisclosed = true
  @AppStorage("menu_calculationsDisclosed", store: .standard)
  private var calculationsDisclosed = true


  // MARK: - Private Methods

  private func deleteHopsInStock(_ indexSet: IndexSet?) {
    if let indexSet = indexSet {
      Task {
        do {
          try await repository.delete(hopsInStock: indexSet)
        } catch {
          // TODO error handling
        }
      }
    }
  }
}
