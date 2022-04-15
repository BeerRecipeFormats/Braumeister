//
//  Binding+onChange.swift
//  Braumeister
//
//  Created by Thomas Bonk on 15.04.22.
//

import Foundation
import SwiftUI

extension Binding {
  
  func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
    return Binding(
      get: { self.wrappedValue },
      set: { newValue in
        self.wrappedValue = newValue
        handler(newValue)
      }
    )
  }
}
