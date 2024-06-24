//
//  PurchaseSelectedItemView.swift
//  Cproject
//
//  Created by 이정선 on 6/21/24.
//

import UIKit

struct PurchaseSelectedItemViewModel {
    var title: String
    var description: String
}

final class PurchaseSelectedItemView: UIView {
    var viewModel: PurchaseSelectedItemViewModel
    private var containerStackViewConstraints: [NSLayoutConstraint]?
    
    private var containerStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private var contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CPFont.UIKit.r12
        label.textColor = CPColor.UIKit.bk
        label.numberOfLines = 0
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CPFont.UIKit.r12
        label.textColor = CPColor.UIKit.gray5
        return label
    }()
    
    private var spacer: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    init(viewModel: PurchaseSelectedItemViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(contentStackView)
        containerStackView.addArrangedSubview(spacer)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        setBorder()
        setViewModel()
    }
    
    override func updateConstraints() {
        if containerStackViewConstraints == nil {
            let constraints = [
                containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
                containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ]
            
            NSLayoutConstraint.activate(constraints)
            containerStackViewConstraints = constraints
        }
        
        super.updateConstraints()
    }
    
    private func setBorder() {
        layer.borderColor = CPColor.UIKit.gray1.cgColor
        layer.borderWidth = 1
    }
    
    private func setViewModel() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

#Preview {
    PurchaseSelectedItemView(viewModel: PurchaseSelectedItemViewModel(title: "hi", description: "bye"))
}
