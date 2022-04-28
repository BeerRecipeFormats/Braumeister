//
//  FermentablesInStockItemView.swift
//  Braumeister
//
//  Created by Thomas Bonk on 26.04.22.
//

import SwiftUI

struct FermentablesInStockItemView: View {

  // MARK: - Public Properties

  var body: some View {
    VStack(alignment: .leading) {
      Text("\(item.type.localizedName)").font(.subheadline)
      Text(String(format:"\(item.name) | %.2f kg", item.amount))
    }
    .padding([.top, .bottom], 2)
  }

  var item: FermentablesInStock
}
