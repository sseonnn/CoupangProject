//
//  HomeProductCollectionViewCell.swift
//  Cproject
//
//  Created by 이정선 on 6/2/24.
//

import UIKit
import Kingfisher

struct HomeProductCellModel: Hashable {
    let imageUrlString: String
    let title: String
    let reasonDiscount: String
    let originalPrice: String
    let discountPrice: String
}

final class HomeProductCollectionViewCell: UICollectionViewCell {
    static let reusableId: String = "HomeProductCollectionViewCell"
    @IBOutlet private weak var productItemImageView: UIImageView! {
        didSet {
            productItemImageView.layer.cornerRadius = 5
        }
    }
    @IBOutlet private weak var productTitleLabel: UILabel!
    @IBOutlet private weak var productReasonDiscountLabel: UILabel!
    @IBOutlet private weak var originalPriceLabel: UILabel!
    @IBOutlet private weak var discountPriceLabel: UILabel!
    
    func setModel(_ model: HomeProductCellModel) {
        productItemImageView.kf.setImage(with: URL(string: model.imageUrlString))
        productTitleLabel.text = model.title
        productReasonDiscountLabel.text = model.reasonDiscount
        originalPriceLabel.attributedText = NSMutableAttributedString(string: model.originalPrice, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        discountPriceLabel.text = model.discountPrice
    }
}

extension HomeProductCollectionViewCell {
    static func horizontalProductLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(117), heightDimension: .estimated(224))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 33, bottom: 0, trailing: 33)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        
        return section
    }
    
    static func verticalProductLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(277))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 40, leading: 19 - 2.5, bottom: 0, trailing: 19 - 2.5)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 10
        
        return section
    }
}
