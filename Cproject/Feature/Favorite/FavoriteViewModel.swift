//
//  FavoriteViewModel.swift
//  Cproject
//
//  Created by 이정선 on 6/11/24.
//

import Foundation

final class FavoriteViewModel {
    enum Action {
        case getFavoriteFromApi
        case getFavoriteSuccess(FavoriteResponse)
        case getFavoriteFailure(Error)
        case didTapPurchaseButton
    }
    
    final class State {
        @Published var tableViewModel: [FavoriteItemTableViewCellViewModel]?
    }
    private(set) var state: State = State()
    private var loadDataTask: Task<Void, Never>?
    
    func process(_ action: Action) {
        switch action {
        case .getFavoriteFromApi:
            getFavoriteFromApi()
        case .getFavoriteSuccess(let favoriteResponse):
            translateFavoriteItemViewModel(favoriteResponse)
        case .getFavoriteFailure(let error):
            print(error)
        case .didTapPurchaseButton:
            break
        }
    }
    
    deinit {
        loadDataTask?.cancel()
    }
}

extension FavoriteViewModel {
    private func getFavoriteFromApi() {
        loadDataTask = Task{
            do {
                let response = try await NetworkService.shared.getFavoriteData()
                process(.getFavoriteSuccess(response))
            } catch {
                process(.getFavoriteFailure(error))
            }
        }
    }
    
    private func translateFavoriteItemViewModel(_ response: FavoriteResponse) {
        state.tableViewModel = response.favorites.map {
            FavoriteItemTableViewCellViewModel(imageUrl: $0.imageUrl, 
                                               productName: $0.title,
                                               productPrice: $0.discountPrice.moneyString)
        }
    }
}
