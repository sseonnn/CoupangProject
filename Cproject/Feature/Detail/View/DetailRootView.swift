//
//  DetailRootView.swift
//  Cproject
//
//  Created by 이정선 on 6/13/24.
//

import SwiftUI
import Kingfisher

struct DetailRootView: View {
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.state.isLoading {
                Text("로딩중...")
            } else {
                if let error = viewModel.state.error {
                    Text(error)
                } else {
                    ScrollView(.vertical) {
                        VStack {
                            bannerView
                            rateView
                            titleView
                            optionView
                            priceView
                            mainImageView
                        }
                    }
                    
                    moreView
                    bottomCtaView
                } 
            }
        }
        .onAppear {
            viewModel.process(.loadData)
        }
    }
    
    @ViewBuilder
    var bannerView: some View {
        if let bannersViewModel = viewModel.state.banners {
            DetailBannerView(viewModel: bannersViewModel)
                .padding(.bottom, 15)
        }
    }
    
    @ViewBuilder
    var rateView: some View {
        if let rateViewModel = viewModel.state.rate {
            HStack {
                Spacer()
                DetailRateView(viewModel: rateViewModel)
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    var titleView: some View {
        if let titleViewModel = viewModel.state.title {
            HStack {
                Text(titleViewModel)
                    .font(CPFont.SwiftUI.m17)
                    .foregroundStyle(CPColor.SwiftUI.bk)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    var optionView: some View {
        if let optionViewModel = viewModel.state.option {
            Group {
                DetailOptionView(viewModel: optionViewModel)
                    .padding(.bottom, 32)
                HStack {
                    Spacer()
                    Button {
                        viewModel.process(.didTapChangeOption)
                    } label: {
                        Text("옵션 선택하기")
                            .font(CPFont.SwiftUI.m12)
                            .foregroundStyle(CPColor.SwiftUI.keyColorBlue)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    var priceView: some View {
        if let priceViewModel = viewModel.state.price {
            HStack {
                DetailPriceView(viewModel: priceViewModel)
                Spacer()
            }
            .padding(.bottom, 32)
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    var mainImageView: some View {
        if let mainImageViewModel = viewModel.state.mainImageUrls {
            LazyVStack {
                ForEach(mainImageViewModel, id: \.self) {
                    KFImage(URL(string: $0))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .padding(.bottom, 32)
            .frame(maxHeight: viewModel.state.more == nil ? .infinity : 200, alignment: .top)
            .clipped()
        }
    }
    
    @ViewBuilder
    var moreView: some View {
        if let moreViewModel = viewModel.state.more {
            DetaillMoreView(viewModel: moreViewModel) {
                viewModel.process(.didTapMore)
            }
        }
    }
    
    @ViewBuilder
    var bottomCtaView: some View {
        if let purchaseViewModel = viewModel.state.purchase {
            DetailPurchaseView(viewModel: purchaseViewModel) {
                viewModel.process(.didTapFavorite)
            } onPurchaseTapped: {
                viewModel.process(.didTapPurchase)
            }
        }
    }
}

#Preview {
    DetailRootView(viewModel: DetailViewModel())
}
