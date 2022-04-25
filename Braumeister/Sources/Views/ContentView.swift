//
//  ContentView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 14.04.22.
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

struct ContentView: View {

  // MARK: - Public View

  var body: some View {
    NavigationView {
      MenuView()
      SplashView()
    }
    .sheet(
      isPresented: $showAlert,
      onDismiss: {
        data.value?.dismissCallback()
      }, content: {
        AlertView(
          alertType: data.value?.type ?? .information,
          message: data.value?.message ?? "",
          error: data.value?.error)
      })
    .onAppear(perform: registerForAlertNotification)
    .onDisappear(perform: deregisterFromAlertNotification)
  }

  // MARK: - Private Properties

  @State
  private var showAlert = false

  @State
  private var observer: NSObject!

  @ObservedObject
  private var data: ValueWrapper<AlertData> = ValueWrapper()


  // MARK: - Private Methods

  private func registerForAlertNotification() {
    observer =
      NotificationCenter
        .default
        .addObserver(
          forName: .showAlert,
          object: nil,
          queue: OperationQueue.main,
          using: showAlert(notification:)) as? NSObject
  }

  private func deregisterFromAlertNotification() {
    NotificationCenter.default.removeObserver(observer as Any)
  }

  private func showAlert(notification: Notification) {
    self.data.value = notification.alertData
    self.showAlert = true
  }
}
