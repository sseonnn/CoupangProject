//
//  PurchaseRootView.swift
//  Cproject
//
//  Created by 이정선 on 6/23/24.
//

import UIKit

final class PurchaseRootView: UIView {
    private var scrollViewConstraints: [NSLayoutConstraint]?
    private var titleLabelConstraints: [NSLayoutConstraint]?
    private var purchaseItemStackViewConstraints: [NSLayoutConstraint]?
    private var purchaseButtonConstraints: [NSLayoutConstraint]?
    
    private var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private var containerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "주문 상품 목록"
        titleLabel.font = CPFont.UIKit.m17
        titleLabel.textColor = CPColor.UIKit.bk
        
        return titleLabel
    }()
    
    private var purchaseItemStackView: UIStackView = {
        let purchaseItemStackView: UIStackView = UIStackView()
        purchaseItemStackView.translatesAutoresizingMaskIntoConstraints = false
        purchaseItemStackView.axis = .vertical
        purchaseItemStackView.distribution = .fill
        purchaseItemStackView.alignment = .fill
        purchaseItemStackView.spacing = 7
        return purchaseItemStackView
    }()
    
    var purchaseButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("결제하기", for: .normal)
        button.setTitleColor(CPColor.UIKit.wh, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = CPColor.UIKit.keyColorBlue.cgColor
        button.titleLabel?.font = CPFont.UIKit.m16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if scrollViewConstraints == nil {
            let constraints = [
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
                containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
            scrollViewConstraints = constraints
        }
        
        if titleLabelConstraints == nil, let superView = titleLabel.superview {
            let constraints = [
                titleLabel.topAnchor.constraint(equalTo: superView.topAnchor, constant: 33),
                titleLabel.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 33),
                titleLabel.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -33)
            ]
            
            NSLayoutConstraint.activate(constraints)
            titleLabelConstraints = constraints
        }
        
        if purchaseItemStackViewConstraints == nil, let superView = purchaseItemStackView.superview {
            let constraints = [
                purchaseItemStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 19),
                purchaseItemStackView.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -33),
                purchaseItemStackView.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 20),
                purchaseItemStackView.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -20)
            ]
            
            NSLayoutConstraint.activate(constraints)
            purchaseItemStackViewConstraints = constraints
        }
        
        if purchaseButtonConstraints == nil {
            let constraints = [
                purchaseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
                purchaseButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
                purchaseButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
                purchaseButton.heightAnchor.constraint(equalToConstant: 50)
            ]
            
            NSLayoutConstraint.activate(constraints)
            purchaseButtonConstraints = constraints
        }
        
        super.updateConstraints()
    }
    
    private func commonInit() {
        addSubViews()
    }
    
    private func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(purchaseItemStackView)
        addSubview(purchaseButton)
    }
    
    func setPurchaseItem(_ viewModels: [PurchaseSelectedItemViewModel]) {
        purchaseItemStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        viewModels.forEach {
            purchaseItemStackView.addArrangedSubview(PurchaseSelectedItemView(viewModel: $0))
        }
    }
}
