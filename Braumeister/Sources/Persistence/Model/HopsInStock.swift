//
//  HopsInStock.swift
//  Braumeister
//
//  Created by Thomas Bonk on 24.04.22.
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

class HopsInStock: BaseEntity, Model {

  // MARK: - Model

  static var schema: String = "hops_in_stock"


  // MARK: - Properties

  @ID(key: .id)
  var id: UUID?
  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?
  @Timestamp(key: "modified_at", on: .update)
  var modifiedAt: Date?

  @Field(key: "name")
  var name: String
  @Field(key: "amount")
  var amount: UInt16
  @Field(key: "amount_unit")
  var amountUnit: String
  @Field(key: "crop_country")
  var cropCountry: String
  @Field(key: "crop_year")
  var cropYear: UInt16
  @Enum(key: "form")
  var form: HopForm
  @Field(key: "alpha")
  var alpha: Float
  @OptionalField(key: "best_before")
  var bestBefore: Date?
  @OptionalField(key: "notes")
  var notes: String?
  @OptionalField(key: "alternatives")
  var alternatives: String?


  // MARK: - Initialization

  required init() {
    // empty by design
  }

  init(id: UUID? = nil, name: String) {
    self.id = id
    self.name = name
    self.amount = 0
    self.amountUnit = "g"
    self.cropCountry = "<Herkunftsland>"
    self.cropYear = 1970
    self.form = .pellets
    self.alpha = 0
  }
}

extension HopsInStock {
  struct V1: Migration {
    let name = "V1"
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(HopsInStock.schema)
        .id()
        .field("created_at", .datetime, .required)
        .field("modified_at", .datetime, .required)
        .field("name", .string, .required)
        .field("amount", .uint16, .required)
        .field("amount_unit", .string, .required)
        .field("crop_country", .string, .required)
        .field("crop_year", .uint16, .required)
        .field("form", .string, .required)
        .field("alpha", .float, .required)
        .field("best_before", .date)
        .field("notes", .string)
        .field("alternatives", .string)
        .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(HopsInStock.schema).delete()
    }
  }
}
