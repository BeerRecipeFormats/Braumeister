//
//  Gravity.swift
//  Braumeister
//
//  Created by Thomas Bonk on 15.04.22.
//

import Foundation

extension String: Identifiable {
  public var id: Int { return self.hashValue }
}

enum Gravity {

  // MARK: - Cases

  case plato(Float)
  case brix(Float)
  case sg(Float)


  // MARK: - Properties

  static var allUnits: [String] {
    return [
      Gravity.plato(0).unit,
      Gravity.brix(0).unit,
      Gravity.sg(0).unit
    ]
  }

  var description: String {
    switch self {
      case .plato(let val):
        return String(format: "%.1f° Plato", val)

      case .brix(let val):
        return String(format: "%.1f° Brix", val)

      case .sg(let val):
        return String(format: "%.3f", val)
    }
  }

  var value: Float {
    get {
      switch self {
        case .plato(let plt):
          return plt

        case .brix(let brx):
          return brx

        case .sg(let sg):
          return sg
      }
    }
    set {
      switch self {
        case .plato(_):
          self = .plato(newValue)

        case .brix(_):
          self = .brix(newValue)

        case .sg(_):
          self = .sg(newValue)
      }
    }
  }

  var unit: String {
    switch self {
      case .plato(_):
        return "° Plato"

      case .brix(_):
        return "° Brix"

      case .sg(_):
        return "SG"
    }
  }

  var toPlato: Gravity {
    switch self {
      case .plato(_):
        return self

      case .brix(let brx):
        return .plato(brx * 0.962)

      case .sg(let sg):
        return .plato(-668.962 + (1262.45 * sg) - (776.43 * sg * sg) + (182.94 * sg * sg * sg))
    }
  }

  var toBrix: Gravity {
    switch self {
      case .plato(let plt):
        return .brix(plt / 0.962)

      case .brix(_):
        return self

      case .sg(let sg):
        let plt = -668.962 + (1262.45 * sg) - (776.43 * sg * sg) + (182.94 * sg * sg * sg)
        return .brix(plt / 0.962)
    }
  }

  var toSG: Gravity {
    switch self {
      case .plato(let plt):
        return .sg(1.00001 + (3.8661E-3 * plt) + (1.3488E-5 * plt * plt) + (4.3074E-8 * plt * plt * plt))

      case .brix(let brx):
        let plt = brx * 0.962
        return .sg(1.00001 + (3.8661E-3 * plt) + (1.3488E-5 * plt * plt) + (4.3074E-8 * plt * plt * plt))

      case .sg(_):
        return self
    }
  }


  // MARK: - Methods

  static func `for`(unit: Int, value: Gravity) -> Gravity {
    if unit == Gravity.plato(0).unit.id {
      return value.toPlato
    } else if unit == Gravity.brix(0).unit.id {
      return value.toBrix
    } else if unit == Gravity.sg(0).unit.id {
      return value.toSG
    }

    return value
  }
}
