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

  func delete(hopsInStock indexSet: IndexSet) async throws {
    let hops = self.hopsInStock

    self.objectWillChange.send()

    try await database.transaction { db in
      let result = indexSet.map { index in
        hops[index].delete(on: db)
      }

      try result.forEach { res in
        try res.wait()
      }
    }
  }
}
