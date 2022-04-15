//
//  SplashView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 14.04.22.
//

import SwiftUI

struct SplashView: View {

  // MARK: - Public Properties

  var body: some View {
    HStack(alignment: .center) {
      VStack {
        Image("Logo").padding(.bottom, 30)
        Text("Braumeister").font(.largeTitle)
        Text("Version \(version) (\(buildNumber))").font(.caption).padding(.bottom, 15)
        Text("Copyright © 2022 Thomas Bonk.").font(.title2)
        Spacer()
      }.padding()
    }
  }


  // MARK: - Private Properties

  private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
  private let buildNumber =  Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
}
