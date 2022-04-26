//
//  Repository+HopsInStock.swift
//  Braumeister
//
//  Created by Thomas Bonk on 24.04.22.
//

import Combine
import Fluent
import FluentSQLiteDriver
import Foundation

extension Repository {

  var hopsInStock: [HopsInStock] {
    return try! database.query(HopsInStock.self).sort(FieldKey(stringLiteral: "name")).all().wait()
  }

  func create(hopsInStock: HopsInStock) throws {
    self.objectWillChange.send()
    try hopsInStock.create(on: database).wait()
  }

  func save(hopsInStock: HopsInStock) throws {
    self.objectWillChange.send()
    try hopsInStock.save(on: database).wait()
  }

  func delete(hopsInStock: HopsInStock) {
    Task {
      do {
        DispatchQueue.main.sync {
          self.objectWillChange.send()
        }
        try await hopsInStock.delete(on: database)
      } catch {
        errorAlert(message: "Fehler beim Löschen der Daten", error: error)
      }
    }
  }
}
