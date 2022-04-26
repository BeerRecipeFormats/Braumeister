//
//  FermentablesInStock.swift
//  Braumeister
//
//  Created by Thomas Bonk on 25.04.22.
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

import FluentSQLiteDriver
import Foundation

class FermentablesInStock: BaseEntity, Model {

  // MARK: - Model

  static var schema: String = "fermentables_in_stock"


  // MARK: - Properties

  @ID(key: .id)
  var id: UUID?
  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?
  @Timestamp(key: "modified_at", on: .update)
  var modifiedAt: Date?

  @Field(key: "name")
  var name: String
  @Enum(key: "type")
  var `type`: FermentableType
  @Field(key: "amount")
  var amount: Float             // amount in kg
  @OptionalField(key: "color")
  var color: Float?             // color in EBC
  @OptionalField(key: "origin")
  var origin: String?
  @OptionalField(key: "max_in_batch")
  var maxInBatch: UInt8?        // The recommended maximum percentage (by weight) this ingredient should represent in a batch of beer.
  @OptionalField(key: "notes")
  var notes: String?


  // MARK: - Initialization

  required init() {
    // empty by design
  }

  init(id: UUID? = nil, name: String) {
    self.id = id
    self.name = name
    self.type = .grain
    self.amount = 0
    self.color = 0
    self.origin = ""
    self.maxInBatch = 0
  }
}

extension FermentablesInStock {
  struct V1: Migration {
    let name = "V1"

    func prepare(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(FermentablesInStock.schema)
        .id()
        .field("created_at", .datetime, .required)
        .field("modified_at", .datetime, .required)
        .field("name", .string, .required)
        .field("type", .string, .required)
        .field("amount", .float, .required)
        .field("color", .float)
        .field("origin", .string)
        .field("max_in_batch", .uint8)
        .field("notes", .string)
        .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(FermentablesInStock.schema).delete()
    }
  }
}
