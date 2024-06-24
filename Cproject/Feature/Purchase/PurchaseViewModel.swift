//
//  PurchaseViewModel.swift
//  Cproject
//
//  Created by 이정선 on 6/21/24.
//

import Foundation
import Combine

final class PurchaseViewModel: ObservableObject {
    enum Action {
        case loadData
        case didTapPurchaseButton
    }
    
    struct State {
        var purchaseItems: [PurchaseSelectedItemViewModel]?
    }
    @Published private(set) var state: State = State()
    private(set) var showPaymentViewController: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    
    func process(_ action: Action) {
        switch action {
        case .loadData:
            Task { await loadData() }
        case .didTapPurchaseButton:
            Task{ await didTapPurchaseButton() }
        }
    }
}

extension PurchaseViewModel {
    private func loadData() async {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
            self?.state.purchaseItems = [
                PurchaseSelectedItemViewModel(title: "PlayStation1", description: "수량 1개, 무료배송"),
                PurchaseSelectedItemViewModel(title: "아이엠 판다 펀치리버스 애플워치 스트랩, 애플워치SE 용 스트랩", description: "수량 1개, 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation1", description: "수량 1개, 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation1", description: "수량 1개, 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation1", description: "수량 1개, 무료배송"),
                PurchaseSelectedItemViewModel(title: "PlayStation1", description: "수량 1개, 무료배송")
            ]
        }
    }
    
    private func didTapPurchaseButton() async {
        showPaymentViewController.send()
    }
}
