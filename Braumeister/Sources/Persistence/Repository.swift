//
//  Repository.swift
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

import Fluent
import FluentSQLiteDriver
import Foundation
import Vapor

class Repository: ObservableObject {

  // MARK: - Private Properties

  let databases: Databases

  var logger: Logger = {
    var logger = Logger(label: "braumeister.database.logger")
    logger.logLevel = .trace
    return logger
  }()

  var database: Database {
    return self.databases.database(
      logger: logger,
      on: self.databases.eventLoopGroup.next()
    )!
  }


  // MARK: - Initialization

  init() {
    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    let threadPool = NIOThreadPool(numberOfThreads: 1)
    threadPool.start()

    databases = Databases(threadPool: threadPool, on: eventLoopGroup)
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let databaseFilePath = paths[0].appendingPathComponent("Braumeister.sqlite").path

    databases.use(.sqlite(.file(databaseFilePath)), as: .sqlite)
    databases.default(to: .sqlite)

    do {
      let migrations = Migrations()

      migrations.add(HopsInStock.V1())
      migrations.add(FermentablesInStock.V1())

      let migrator = Migrator(databases: databases, migrations: migrations, logger: logger, on: eventLoopGroup.next())

      try migrator.setupIfNeeded().flatMap {
        migrator.prepareBatch()
      }.wait()
    } catch {
      fatalErrorAlert(
        message: "Fehler beim Initialisieren der Datenbank. Braumeister wird beendet.",
        error: error)
    }
  }
}
