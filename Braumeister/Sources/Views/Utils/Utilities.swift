//
//  Utilities.swift
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

func optionalGravity(_ gravity: Gravity?, unit: String = "") -> String {
  return gravity != nil ? gravity!.description + unit : ""
}

func optionalFloat(_ value: Float?, decimals: Int = 0, unit: String = "") -> String {
  return value != nil ? String(format: "%.\(decimals)f", value!) + unit : ""
}

func gravityValueBinding(_ gravity: Binding<Gravity>, onChange: (() -> ())? = nil) -> Binding<Float> {
  return Binding {
    return gravity.wrappedValue.value
  } set: { val in
    gravity.wrappedValue.value = val
    onChange?()
  }
}

func gravityUnitBinding(
  _ gravity: Binding<Gravity>,
     _ unit: Binding<Int>,
   onChange: (() -> ())? = nil) -> Binding<Int> {
     
  return Binding {
    return unit.wrappedValue
  } set: { newValue in
    unit.wrappedValue = newValue
    gravity.wrappedValue = Gravity.for(unit: newValue, value: gravity.wrappedValue)
    onChange?()
  }
}
