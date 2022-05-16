//
//  ContentView.swift
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

struct ContentView: View {

  // MARK: - Public Properties
  
  var body: some View {
    NavigationView {
      List {
        Section("Berechnungen") {
          NavigationLink("Alkoholgehalt")         { AlcoholCalculationView() }
          NavigationLink("Dichteumrechnung")      { GravityConvertionView() }
          NavigationLink("Sudhausausbeute ")      { BrewhouseYieldCalculationView() }
          NavigationLink("Verdünnungsrechner")    { DilutionCalculationView() }
        }
      }
      .listStyle(.sidebar)
      .navigationTitle("Braumeister")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
