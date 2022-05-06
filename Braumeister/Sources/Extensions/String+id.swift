//
//  String+id.swift
//  Braumeister
//
//  Created by Thomas Bonk on 06.05.22.
//

import Foundation

extension String: Identifiable {
  
  public var id: Int {
    return self.hashValue
  }
}
