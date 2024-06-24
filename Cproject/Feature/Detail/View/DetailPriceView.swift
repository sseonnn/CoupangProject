//
//  DetailPriceView.swift
//  Cproject
//
//  Created by 이정선 on 6/16/24.
//

import SwiftUI

final class DetailPriceViewModel: ObservableObject{
    init(discountRate: String, originalPrice: String, currentPrice: String, shippingType: String) {
        self.discountRate = discountRate
        self.originalPrice = originalPrice
        self.currentPrice = currentPrice
        self.shippingType = shippingType
    }
    
    @Published var discountRate: String
    @Published var originalPrice: String
    @Published var currentPrice: String
    @Published var shippingType: String
}

struct DetailPriceView: View {
    @ObservedObject var viewModel: DetailPriceViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 21) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(viewModel.discountRate)
                        .font(CPFont.SwiftUI.b14)
                        .foregroundStyle(CPColor.SwiftUI.bk)
                    Text(viewModel.originalPrice)
                        .font(CPFont.SwiftUI.b16)
                        .foregroundStyle(CPColor.SwiftUI.gray5)
                }
                Text(viewModel.currentPrice)
                    .font(CPFont.SwiftUI.b20)
                    .foregroundStyle(CPColor.SwiftUI.keyColorRed)
            }
            Text(viewModel.shippingType)
                .font(CPFont.SwiftUI.r12)
                .foregroundStyle(CPColor.SwiftUI.bk)
        }
    }
}

#Preview {
    DetailPriceView(viewModel: DetailPriceViewModel(
        discountRate: "53%",
        originalPrice: "300,000원",
        currentPrice: "139,000원",
        shippingType: "무료배송"
    ))
}
