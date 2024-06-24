//
//  HomeViewModel.swift
//  Cproject
//
//  Created by 이정선 on 6/4/24.
//

import Combine
import Foundation

final class HomeViewModel {
    enum Action {
        case loadData
        case loadCoupon
        case getDataSuccess(HomeResponse)
        case getDataFailure(Error)
        case getCouponSuccess(Bool)
        case didTapCouponButton
    }
    
    final class State {
        struct CollectionViewModels {
            var bannerModels: [HomeBannerModel]?
            var horizontalProductModels: [HomeProductCellModel]?
            var verticalProductModels: [HomeProductCellModel]?
            var couponModels: [HomeCouponButtonCollectionViewCellModel]?
            var seperateLine1Models: [HomeSeperateLineCollectionViewCellModel] = [HomeSeperateLineCollectionViewCellModel()]
            var seperateLine2Models: [HomeSeperateLineCollectionViewCellModel] = [HomeSeperateLineCollectionViewCellModel()]
            var themeModels: (headerModels: HomeThemeHeaderCollectionReusableViewModel, items: [HomeThemeCollectionViewCellModel])?
        }
        @Published var collectionViewModels: CollectionViewModels = CollectionViewModels()
    }
    
    private(set) var state: State = State()
    private var loadDataTask: Task<Void, Never>?
    private var couponDownloadedKey: String = "CouponDownloaded"
    
    func process(action: Action) {
        switch action {
        case .loadData:
            loadData()
        case .loadCoupon:
            loadCoupon()
        case let .getDataSuccess(response):
            transformResponse(response: response)
        case let .getDataFailure(error):
            print("networkError: \(error)")
        case let .getCouponSuccess(isDownloaded):
            Task { await transformCoupon(isDownloaded) }
        case .didTapCouponButton:
            downloadCoupon()
        }
    }

    deinit {
        loadDataTask?.cancel()
    }
}

extension HomeViewModel {
    func loadData() {
        loadDataTask = Task {
            do {
                let response = try await NetworkService.shared.getHomeData()
                process(action: .getDataSuccess(response))
                
            } catch {
                process(action: .getDataFailure(error))
                
            }
        }
    }
    
    func loadCoupon() {
        let couponState: Bool = UserDefaults.standard.bool(forKey: couponDownloadedKey)
        process(action: .getCouponSuccess(couponState))
    }
    
    private func transformResponse(response: HomeResponse) {
        Task { await transformBanner(response) }
        Task { await transformHorizontalProduct(response) }
        Task { await transformVerticalProduct(response) }
        Task { await transformTheme(response) }
    }
    
    @MainActor
    private func transformBanner(_ response: HomeResponse) async {
        state.collectionViewModels.bannerModels = response.banners.map {
            HomeBannerModel(bannerImageUrl: $0.imageUrl)
        }
    }
    
    @MainActor
    private func transformHorizontalProduct(_ response: HomeResponse) async {
        state.collectionViewModels.horizontalProductModels = productToHomeProductCollectionViewCellModel(response.horizontalProducts)
    }
    
    @MainActor
    private func transformVerticalProduct(_ response: HomeResponse) async {
        state.collectionViewModels.verticalProductModels = productToHomeProductCollectionViewCellModel(response.verticalProducts)
    }
    
    @MainActor
    private func transformTheme(_ response: HomeResponse) async {
        let items = response.themes.map {
            HomeThemeCollectionViewCellModel(imageUrl: $0.imageUrl)
        }
        let header = HomeThemeHeaderCollectionReusableViewModel(headerText: "테마관")
        
        state.collectionViewModels.themeModels = (header, items)
    }
    
    private func productToHomeProductCollectionViewCellModel(_ product: [Product]) -> [HomeProductCellModel] {
        return product.map {
            HomeProductCellModel(
                imageUrlString: $0.imageUrl,
                title: $0.title,
                reasonDiscount: $0.discount,
                originalPrice: $0.originalPrice.moneyString,
                discountPrice: $0.discountPrice.moneyString
        )}
    }
    
    @MainActor
    private func transformCoupon(_ isDownloaded: Bool) async {
        state.collectionViewModels.couponModels = [.init(state: isDownloaded ? .disable : .enable)]
    }
    
    private func downloadCoupon() {
        UserDefaults.standard.setValue(true, forKey: couponDownloadedKey)
        process(action: .loadCoupon)
    }
}
