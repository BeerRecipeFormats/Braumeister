//
//  YeastInStock.swift
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

import FluentSQLiteDriver
import Foundation

class YeastInStock : BaseEntity, Model {

  // MARK: - Model

  static var schema: String = "yeast_in_stock"


  // MARK: - Properties

  @ID(key: .id)
  var id: UUID?
  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?
  @Timestamp(key: "modified_at", on: .update)
  var modifiedAt: Date?

  @Field(key: "name")
  var name: String
  @Enum(key: "form")
  var form: YeastForm
  @Enum(key: "fermentation")
  var fermentation: YeastFermentation
  @Field(key: "amount")
  var amount: UInt16
  @Field(key: "amount_unit")
  var amountUnit: String
  @Field(key: "best_before")
  var bestBefore: Date?
  @Field(key: "laboratory")
  var laboratory: String
  @Field(key: "product_id")
  var productId: String
  @Field(key: "min_temp")
  var minTemp: UInt8?
  @Field(key: "max_temp")
  var maxTemp: UInt8?
  @Field(key: "final_fermentation")
  var finalFermentation: String?
  @Field(key: "alcohol_tolerance")
  var alcoholTolerance: String?
  @Field(key: "yeast_strain")
  var yeastStrain: String?
  @Enum(key: "flocculation")
  var flocculation: Flocculation
  @Field(key: "best_for")
  var bestFor: String?
  @Field(key: "notes")
  var notes: String?


  // MARK: - Initialization

  required init() {
    // empty by design
  }

  init(id: UUID? = nil, name: String) {
    self.id = id
    self.name = name
    self.form = .liquid
    self.fermentation = .topFermented
    self.bestBefore = Date()
    self.amount = 0
    self.amountUnit = "g"
    self.laboratory = ""
    self.productId = ""
    self.minTemp = 0
    self.maxTemp = 0
    self.finalFermentation = ""
    self.alcoholTolerance = ""
    self.yeastStrain = ""
    self.bestFor = ""
    self.notes = ""
    self.flocculation = .none
  }
}

extension YeastInStock {
  struct V1: Migration {
    let name = "YeastInStock_V1"

    func prepare(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(YeastInStock.schema)
        .id()
        .field("created_at", .datetime, .required)
        .field("modified_at", .datetime, .required)
        .field("name", .string, .required)
        .field("form", .string, .required)
        .field("amount", .uint16, .required)
        .field("amount_unit", .string, .required)
        .field("best_before", .date)
        .field("laboratory", .string, .required)
        .field("product_id", .string, .required)
        .field("min_temp", .uint8)
        .field("max_temp", .uint8)
        .field("final_fermentation", .string)
        .field("alcohol_tolerance", .string)
        .field("yeast_strain", .string)
        .field("flocculation", .string, .required)
        .field("best_for", .string)
        .field("notes", .string)
        .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(YeastInStock.schema).delete()
    }
  }

  struct V2: Migration {
    let name = "YeastInStock_V2"

    func prepare(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(YeastInStock.schema)
        .field("fermentation", .string, .sql(.default(YeastFermentation.topFermented.rawValue)))
        .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(YeastInStock.schema).delete()
    }
  }
}
