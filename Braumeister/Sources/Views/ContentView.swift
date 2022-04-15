//
//  ContentView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 14.04.22.
//

import SwiftUI

struct ContentView: View {

  // MARK: - Public View

  var body: some View {
    NavigationView {
      MenuView()
      SplashView()
    }
  }
}
