//
//  MenuView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 14.04.22.
//

import SwiftUI

struct MenuView: View {

  // MARK: - Public Properties

  var body: some View {
    List {
      Section("Berechnungen") {
        NavigationLink("Alkoholgehalt", destination: AlcoholCalculatorView())

      }
    }
  }
}
