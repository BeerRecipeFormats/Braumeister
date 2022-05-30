//
//  MainPostCastCalculationView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 30.05.22.
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

struct MainPostCastCalculationView: View {

  // MARK: - Public Properties
  
  var body: some View {
    Form {
      Section {
        VStack(alignment: .leading) {
          Text("Minimales Volumen:").bold()
          HStack {
            TextField(
              "Minimales Volumen",
              value: $minimalVolume,
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
            Text("Liter")
          }
        }

        VStack(alignment: .leading) {
          Text("Pfanne-Voll-Volumen:").bold()
          HStack {
            TextField(
              "Pfanne-Voll-Volumen",
              value: $panFullVolume,
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
            Text("Liter")
          }
        }

        VStack(alignment: .leading) {
          Text("Schüttung:").bold()
          HStack {
            TextField(
              "Schüttung",
              value: $pouringWeight,
              format: FloatingPointFormatStyle.number.precision(.fractionLength(1)))
            Text("kg")
          }
        }
      }

      if mainCastVolume > 0 {
        Section {
          VStack(alignment: .leading) {
            Text("Hauptguss:").bold()
            HStack {
              Text(String(format: "%.1f", mainCastVolume))
              Text("Liter")
            }
          }

          if postCastVolume > 0 {
            VStack(alignment: .leading) {
              Text("Nachguss:").bold()
              HStack {
                Text(String(format: "%.1f", postCastVolume))
                Text("Liter")
              }
            }
          }

          if dilutionVolume > 0 {
            VStack(alignment: .leading) {
              Text("Verdünnung:").bold()
              HStack {
                Text(String(format: "%.1f", dilutionVolume))
                Text("Liter")
              }
            }
          }
        }
      }
    }
  }


  // MARK: - Private Properties

  @State
  private var minimalVolume: Float = 13.0
  @State
  private var panFullVolume: Float = 0.0
  @State
  private var pouringWeight: Float = 0.0

  private var mainCastVolume: Float {
    //return pouringWeight * 2.7 + 3.5
    let volume = pouringWeight * 2.7 + 3.5

    guard volume >= minimalVolume else {
      return minimalVolume
    }

    return volume
  }

  private var postCastVolume: Float {
    let volume = panFullVolume - (mainCastVolume + pouringWeight * 0.8)

    return volume
  }

  private var dilutionVolume: Float {
    guard mainCastVolume + postCastVolume <= panFullVolume else {
      return (mainCastVolume + postCastVolume) - panFullVolume
    }

    return 0.0
  }
}

struct MainPostCastCalculationView_Previews: PreviewProvider {
  static var previews: some View {
    MainPostCastCalculationView()
  }
}

