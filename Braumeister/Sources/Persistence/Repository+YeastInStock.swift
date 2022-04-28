//
//  Repository+YeastInStock.swift
//  Braumeister
//
//  Created by Thomas Bonk on 27.04.22.
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

import Fluent
import FluentSQLiteDriver
import Foundation

extension Repository {

  var yeastInStock: [YeastInStock] {
    return try! database.query(YeastInStock.self).sort(FieldKey(stringLiteral: "name")).all().wait()
  }

  func create(yeastInStock: YeastInStock) throws {
    self.objectWillChange.send()
    try hopsInStock.create(on: database).wait()
  }

  func save(yeastInStock: YeastInStock) throws {
    self.objectWillChange.send()
    try yeastInStock.save(on: database).wait()
  }

  func delete(yeastInStock: YeastInStock) {
    Task {
      do {
        DispatchQueue.main.sync {
          self.objectWillChange.send()
        }
        try await yeastInStock.delete(on: database)
      } catch {
        errorAlert(message: "Fehler beim Löschen der Daten", error: error)
      }
    }
  }
}
