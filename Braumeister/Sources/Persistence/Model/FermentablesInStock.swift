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
  @Field(key: "color")
  var color: Float              // color in EBC
  @Field(key: "origin")
  var origin: String
  @Field(key: "max_in_batch")
  var maxInBatch: UInt8         // The recommended maximum percentage (by weight) this ingredient should represent in a batch of beer.
  @OptionalField(key: "notes")
  var notes: String?


  // MARK: - Initialization

  required init() {
    // empty by design
  }

  init(name: String) {
    self.name = name
    self.type = .grain
    self.amount = 0
    self.color = 0
    self.origin = ""
    self.maxInBatch = 0
  }
}

extension FermentablesInStock {
  struct Fly: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(HopsInStock.schema)
        .id()
        .field("created_at", .datetime, .required)
        .field("modified_at", .datetime, .required)
        .field("name", .string, .required)
        .field("amount", .float, .required)
/*        .field("amount_unit", .string, .required)
        .field("crop_country", .string, .required)
        .field("crop_year", .uint16, .required)
        .field("form", .string, .required)
        .field("alpha", .float, .required)
        .field("best_before", .date)
        .field("notes", .string)
        .field("alternatives", .string)*/
        .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(HopsInStock.schema)
        .delete()
    }
  }
}
