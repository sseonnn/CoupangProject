//
//  PurchaseViewController.swift
//  Cproject
//
//  Created by 이정선 on 6/21/24.
//

import UIKit
import Combine

final class PurchaseViewController: UIViewController {
    private var viewModel: PurchaseViewModel = PurchaseViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    private var rootView: PurchaseRootView = PurchaseRootView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.purchaseButton.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
        view.backgroundColor = .systemBackground
        bindViewModel()
        viewModel.process(.loadData)
    }
    
    @objc func purchaseButtonTapped() {
        viewModel.process(.didTapPurchaseButton)
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let viewModels = self?.viewModel.state.purchaseItems else {return}
                self?.rootView.setPurchaseItem(viewModels)
            }
            .store(in: &subscriptions)
        
        viewModel.showPaymentViewController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let vc = PaymentViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &subscriptions)
    }
}

#Preview {
    PurchaseViewController()
}
