//
//  DetailViewModel.swift
//  Cproject
//
//  Created by 이정선 on 6/13/24.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    struct State {
        var error: String?
        var isLoading: Bool = false
        var banners: DetailBannerViewModel?
        var rate: DetailRateViewModel?
        var title: String?
        var option: DetailOptionViewModel?
        var price: DetailPriceViewModel?
        var mainImageUrls: [String]?
        var more: DetaillMoreViewModel?
        var purchase: DetailPurchaseViewModel?
    }
    @Published private(set) var state: State = State()
    private var loadDataTask: Task<Void, Never>?
    var needShowMore: Bool = true
    var isFavorite: Bool = true
    private(set) var showOptionViewController: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    private(set) var showPurchaseViewController: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    enum Action {
        case loadData
        case loading(Bool)
        case getDataSuccess(ProductDetailResponse)
        case getDataFailure(Error)
        case didTapChangeOption
        case didTapMore
        case didTapFavorite
        case didTapPurchase
    }
    
    func process(_ action: Action) {
        switch action {
        case .loadData:
            loadData()
        case let .loading(isLoading):
            Task { await toggleLoading(isLoading) }
        case let .getDataSuccess(response):
            Task { await transformProductDetailResponse(response) }
        case let .getDataFailure(error):
            Task { await getDataFailure(error)}
        case .didTapChangeOption:
            showOptionViewController.send()
        case .didTapMore:
            Task { await toggleMore() }
        case .didTapFavorite:
            Task { await toggleFavorite() }
        case .didTapPurchase:
            showPurchaseViewController.send()
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
}

extension DetailViewModel {
    private func loadData() {
        loadDataTask = Task {
            defer {
                process(.loading(false))
            }
            do {
                process(.loading(true))
                let response = try await NetworkService.shared.getProductDetailData()
                process(.getDataSuccess(response))
            } catch {
                process(.getDataFailure(error))
            }
        }
    }
    
    @MainActor
    private func toggleLoading(_ isLoading: Bool) async {
        state.isLoading = isLoading
    }
    
    @MainActor
    private func toggleFavorite() async {
        isFavorite.toggle()
        state.purchase = DetailPurchaseViewModel(isFavorite: isFavorite)
    }
    
    @MainActor
    private func toggleMore() async {
        needShowMore = false
        state.more = needShowMore ? DetaillMoreViewModel() : nil
    }
    
    @MainActor
    private func transformProductDetailResponse(_ resposne: ProductDetailResponse) async {
        state.error = nil
        state.banners = DetailBannerViewModel(imageUrls: resposne.bannerImages)
        state.rate = DetailRateViewModel(rate: resposne.product.rate)
        state.title = resposne.product.name
        state.option = DetailOptionViewModel(
            type: resposne.option.type,
            name: resposne.option.name,
            imageUrl: resposne.option.image
        )
        state.price = DetailPriceViewModel(
            discountRate: "\(resposne.product.discountPercent)%",
            originalPrice: resposne.product.originalPrice.moneyString,
            currentPrice: resposne.product.discountPrice.moneyString,
            shippingType: "무료배송"
        )
        state.mainImageUrls = resposne.detailImages
        state.more = needShowMore ? DetaillMoreViewModel() : nil
        state.purchase = DetailPurchaseViewModel(isFavorite: isFavorite)
    }
    
    @MainActor
    private func getDataFailure(_ error: Error) async {
        print("에러가 발생했습니다. \(error.localizedDescription)")
    }
}
