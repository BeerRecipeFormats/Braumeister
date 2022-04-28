//
//  Repository+FermentablesInStock.swift
//  Braumeister
//
//  Created by Thomas Bonk on 26.04.22.
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

import Foundation

import Fluent
import FluentSQLiteDriver
import Foundation

extension Repository {

  var fermentablesInStock: [FermentablesInStock] {
    return try! database.query(FermentablesInStock.self).sort(FieldKey(stringLiteral: "name")).all().wait()
  }

  func create(fermentablesInStock: FermentablesInStock) throws {
    self.objectWillChange.send()
    try fermentablesInStock.create(on: database).wait()
  }

  func save(fermentablesInStock: FermentablesInStock) throws {
    self.objectWillChange.send()
    try fermentablesInStock.save(on: database).wait()
  }

  func delete(fermentablesInStock: FermentablesInStock) {
    Task {
      do {
        DispatchQueue.main.sync {
          self.objectWillChange.send()
        }
        try await fermentablesInStock.delete(on: database)
      } catch {
        errorAlert(message: "Fehler beim Löschen der Daten", error: error)
      }
    }
  }
}
