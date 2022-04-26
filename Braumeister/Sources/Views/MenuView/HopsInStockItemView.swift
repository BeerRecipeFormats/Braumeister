//
//  HopsInStockItemView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 24.04.22.
//

import SwiftUI

struct HopsInStockItemView: View {

  // MARK: - Public Properties

  var body: some View {
    VStack(alignment: .leading) {
      Text(String(format: "\(item.name) | \(item.amount)\(item.amountUnit) | ⍺ %.1f%%", item.alpha))
      Text("\(item.cropCountry) | \(String(item.cropYear))").font(.subheadline)
    }
    .padding([.top, .bottom], 4)
  }

  var item: HopsInStock
}
