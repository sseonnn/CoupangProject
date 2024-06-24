//
//  HomeBannerCollectionViewCell.swift
//  Cproject
//
//  Created by 이정선 on 6/2/24.
//

import UIKit
import Kingfisher

struct HomeBannerModel: Hashable {
    let bannerImageUrl: String
}

final class HomeBannerCollectionViewCell: UICollectionViewCell {
    static let reusableId: String = "HomeBannerCollectionViewCell"
    @IBOutlet private weak var imageView: UIImageView!
    
    func setModel(_ model: HomeBannerModel) {
        imageView.kf.setImage(with: URL(string: model.bannerImageUrl))
    }
}

extension HomeBannerCollectionViewCell {
    static func bannerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(165/393))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}
